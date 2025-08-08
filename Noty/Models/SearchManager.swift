//
//  SearchManager.swift
//  Noty
//
//  Created by Moheb Anwari on 07.08.25.
//

import SwiftUI
import Combine

@MainActor
class SearchManager: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var filteredNotes: [Note] = []
    @Published var searchResults: [SearchResult] = []
    
    private var allNotes: [Note] = []
    private var cancellables = Set<AnyCancellable>()
    private let debounceDelay: TimeInterval = 0.3
    
    init() {
        setupSearchDebouncing()
    }
    
    func setNotes(_ notes: [Note]) {
        allNotes = notes
        if !searchText.isEmpty {
            performSearch()
        }
    }
    
    private func setupSearchDebouncing() {
        $searchText
            .debounce(for: .milliseconds(Int(debounceDelay * 1000)), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.performSearch()
            }
            .store(in: &cancellables)
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else {
            filteredNotes = []
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        let query = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        let results = searchNotes(allNotes, query: query)
        filteredNotes = results.map { $0.note }
        searchResults = results
        
        isSearching = false
    }
    
    private func searchNotes(_ notes: [Note], query: String) -> [SearchResult] {
        let results = notes.compactMap { note -> SearchResult? in
            var relevanceScore = 0
            var matchType: SearchMatchType = .content
            var highlightRanges: [NSRange] = []
            
            // Title search (highest priority)
            if let titleRange = note.title.lowercased().range(of: query) {
                relevanceScore += 100
                matchType = .title
                let nsRange = NSRange(titleRange, in: note.title.lowercased())
                highlightRanges.append(nsRange)
            }
            
            // Tag search (high priority)
            if note.tags.contains(where: { $0.lowercased().contains(query) }) {
                relevanceScore += 50
                if matchType == .content { matchType = .tag }
            }
            
            // Content search (lower priority)
            if note.content.lowercased().contains(query) {
                relevanceScore += 10
                if matchType == .content {
                    if let contentRange = note.content.lowercased().range(of: query) {
                        let nsRange = NSRange(contentRange, in: note.content.lowercased())
                        highlightRanges.append(nsRange)
                    }
                }
            }
            
            guard relevanceScore > 0 else { return nil }
            
            return SearchResult(
                note: note,
                matchType: matchType,
                relevanceScore: relevanceScore,
                highlightRanges: highlightRanges,
                searchQuery: query
            )
        }
        
        return results.sorted { lhs, rhs in
            if lhs.relevanceScore != rhs.relevanceScore {
                return lhs.relevanceScore > rhs.relevanceScore
            }
            return lhs.note.date > rhs.note.date
        }
    }
    
    func clearSearch() {
        searchText = ""
        filteredNotes = []
        searchResults = []
        isSearching = false
    }
    
    func selectResult(_ result: SearchResult) {
        // Handle result selection - could navigate to note or perform action
        print("Selected note: \(result.note.title)")
    }
}

// MARK: - Search Models

struct SearchResult: Identifiable {
    let id = UUID()
    let note: Note
    let matchType: SearchMatchType
    let relevanceScore: Int
    let highlightRanges: [NSRange]
    let searchQuery: String
    
    var preview: String {
        let maxLength = 120
        if note.content.count <= maxLength {
            return note.content
        }
        
        // Try to show context around the search match
        if let firstRange = highlightRanges.first, matchType == .content {
            let startIndex = max(0, firstRange.location - 30)
            let endIndex = min(note.content.count, firstRange.location + firstRange.length + 90)
            let start = note.content.index(note.content.startIndex, offsetBy: startIndex)
            let end = note.content.index(note.content.startIndex, offsetBy: endIndex)
            
            let contextText = String(note.content[start..<end])
            return startIndex > 0 ? "..." + contextText : contextText
        }
        
        // Fallback to truncated content
        let endIndex = note.content.index(note.content.startIndex, offsetBy: maxLength)
        return String(note.content[..<endIndex]) + "..."
    }
}

enum SearchMatchType {
    case title
    case content
    case tag
}
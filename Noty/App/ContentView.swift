//
//  ContentView.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var isSearchExpanded = false
    @State private var searchText = ""
    @State private var showSearchResults = false
    @State private var sampleNotes: [Note] = [
        Note(title: "Recent activities", 
             content: "The rain pattered softly against the attic window as I opened my journal. Dust motes danced in the single shaft of sunlight illuminating the aged pages. I picked up my pen, the nib scratching against the paper as I began to write. Today, I stumbled upon an old music box in the antique shop. Its melody was hauntingly familiar, like a forgotten dream.",
             tags: ["New", "Hobbys"]),
        
        Note(title: "Upcoming adventures",
             content: "As the morning light filtered through the curtains, I brewed a cup of herbal tea and flipped through my travel journal. My heart raced with excitement as I mapped out my next journey to the coastal town of Port Haven. The salty breeze and the sound of waves crashing against the cliffs beckoned me.",
             tags: ["Planned", "Travel"]),
        
        Note(title: "Creative projects",
             content: "At my desk, surrounded by sketchbooks and paints, I felt a surge of inspiration. I decided to start a mural in my living room, depicting a vibrant forest scene. Each stroke of the brush transported me into a world of color and imagination.",
             tags: ["Active", "Art"]),
        
        Note(title: "Community events",
             content: "A flyer caught my attention while walking through the park, advertising the upcoming local festival. It promised an array of food stalls, live music, and workshops. Excitement bubbled within me as I envisioned the vibrant atmosphere, filled with laughter and creativity.",
             tags: ["Community"]),
        
        Note(title: "Personal reflections",
             content: "On this quiet evening, I took a moment to reflect on my life choices. Sitting in my favorite armchair with a cozy blanket, I pondered the paths I've taken. The experiences I've had, both good and bad, shaped who I am today."),
        
        Note(title: "Culinary experiments",
             content: "With a fresh batch of organic vegetables from the local market, I decided to experiment in the kitchen. I envisioned a colorful stir-fry, packed with flavors and nutrients. As I chopped the vegetables, I could almost hear Elara's excitement about trying new recipes.",
             tags: ["Completed", "Cooking"]),
        
        Note(title: "Fitness goals",
             content: "The sun was just peeking over the horizon as I laced up my sneakers for a morning run. I set a goal to increase my distance this month, pushing my limits while enjoying the crisp morning air. Each step felt liberating, the rhythm of my breath syncing with the heartbeat of the world around me.",
             tags: ["Active", "Fitness"])
    ]
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return []
        }
        return sampleNotes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.content.localizedCaseInsensitiveContains(searchText) ||
            note.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(222), spacing: 12), count: 4), spacing: 12) {
                        ForEach(sampleNotes) { note in
                            NoteCard(note: note)
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 24)
                }
            }
            
            // Independent bottom elements - positioned absolutely
            VStack {
                Spacer()
                
                // Search component - positioned independently
                HStack {
                    searchComponent
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
            }
            
            // Independent buttons - positioned absolutely
            VStack {
                Spacer()
                
                // New note button - positioned absolutely
                HStack {
                    Spacer()
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Text("New note")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.black)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding(.bottom, 18)
                
                // Theme toggle button - positioned absolutely
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "circle.lefthalf.filled")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                            .frame(width: 40, height: 40)
                            .background(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.06))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 18)
                    .padding(.bottom, 18)
                }
            }
        }
        .frame(minWidth: 1109, minHeight: 782)
    }
    
    private var headerView: some View {
        Color.clear
            .frame(height: 22)
    }
    
    // MARK: - Single Search Component with Variants
    private var searchComponent: some View {
        Group {
            if !isSearchExpanded {
                // Default variant - Search button
                searchButton
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .animation(.bouncy(duration: 0.6, extraBounce: 0.1)),
                        removal: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .animation(.bouncy(duration: 0.6, extraBounce: 0.1))
                    ))
            } else if isSearchExpanded && searchText.isEmpty {
                // New-search variant - Search bar without results
                newSearchBar
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .animation(.bouncy(duration: 0.6, extraBounce: 0.1)),
                        removal: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .animation(.bouncy(duration: 0.6, extraBounce: 0.1))
                    ))
            } else {
                // Results variant - Search bar with results
                resultsSearchBar
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .animation(.bouncy(duration: 0.6, extraBounce: 0.1)),
                        removal: .scale(scale: 0.9)
                            .combined(with: .opacity)
                            .animation(.bouncy(duration: 0.6, extraBounce: 0.1))
                    ))
            }
        }
        .animation(.bouncy(duration: 0.6, extraBounce: 0.1), value: isSearchExpanded)
        .animation(.bouncy(duration: 0.4, extraBounce: 0.05), value: searchText)
    }
    
    // MARK: - Default Search Button Component
    private var searchButton: some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.6, extraBounce: 0.1)) {
                isSearchExpanded = true
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
                
                Text("Search")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
                .tracking(-0.3) // Figma letter spacing
            }
            .padding(.horizontal, 24) // Figma: 24px horizontal padding
            .padding(.vertical, 12)   // Figma: 12px vertical padding
            .background(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.06))
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - New Search Bar Component (without results)
    private var newSearchBar: some View {
        VStack(spacing: 18) { // 18px gap as per Figma
            // Search input section
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
                
                TextField("Search", text: $searchText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                            showSearchResults = !newValue.isEmpty
                        }
                    }
                    .onAppear {
                        // Automatically focus the text field when it appears
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            // This will focus the text field
                        }
                    }
                
                Button(action: {
                    withAnimation(.bouncy(duration: 0.6, extraBounce: 0.1)) {
                        isSearchExpanded = false
                        searchText = ""
                        showSearchResults = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 324) // Fixed expanded width
        .padding(12) // 12px padding all around
        .background(
            Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.6)
                .blur(radius: 0.5) // Blur only the background
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.08), radius: 9.5, x: 0, y: 9)
        .shadow(color: Color.black.opacity(0.06), radius: 17.5, x: 0, y: 35)
        .shadow(color: Color.black.opacity(0.04), radius: 23.5, x: 0, y: 78)
    }
    
    // MARK: - Results Search Bar Component
    private var resultsSearchBar: some View {
        VStack(spacing: 12) { // 12px gap between results and input
            // Search results section (inside the search bar container)
            if !filteredNotes.isEmpty {
                // Inner results container with solid white background
                VStack(spacing: 0) {
                    ForEach(filteredNotes) { note in
                        searchResultRow(for: note)
                    }
                }
                .padding(12) // 12px padding all around
                .background(Color.white.opacity(0.7)) // Solid white background
                .clipShape(RoundedRectangle(cornerRadius: 16)) // 16px corner radius
            }
            
            // Search input section (at the bottom)
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
                
                TextField("Search", text: $searchText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                            showSearchResults = !newValue.isEmpty
                        }
                    }
                
                Button(action: {
                    withAnimation(.bouncy(duration: 0.6, extraBounce: 0.1)) {
                        isSearchExpanded = false
                        searchText = ""
                        showSearchResults = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 12) // 12px horizontal padding
            .padding(.vertical, 12)   // 12px vertical padding
        }
        .frame(width: 324) // Fixed expanded width
        .padding(12) // 12px padding all around the search bar
        .background(
            Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.6)
                .blur(radius: 0.5) // Blur only the background
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.08), radius: 9.5, x: 0, y: 9)
        .shadow(color: Color.black.opacity(0.06), radius: 17.5, x: 0, y: 35)
        .shadow(color: Color.black.opacity(0.04), radius: 23.5, x: 0, y: 78)
    }
    
    // MARK: - Search Result Row
    private func searchResultRow(for note: Note) -> some View {
        HStack(spacing: 12) {
            // Note card thumbnail with proper 4px corner radius
            Image("note-card-thumbnail")
                .resizable()
                .frame(width: 18, height: 22)
                .clipShape(RoundedRectangle(cornerRadius: 4)) // Fixed: 4px corner radius
            
            // Note title with highlighted search text
            HStack {
                highlightedText(for: note.title, searchText: searchText)
                Spacer()
            }
        }
        .padding(.horizontal, 12) // Fixed: proper 12px padding
        .padding(.vertical, 12)
    }
    
    private func highlightedText(for text: String, searchText: String) -> some View {
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: searchText, options: .caseInsensitive)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.backgroundColor, value: NSColor.yellow.withAlphaComponent(0.3), range: range)
        }
        
        return Text(AttributedString(attributedString))
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
            .tracking(-0.5)
            .lineLimit(1)
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import SwiftUI

struct ContentView: View {
    // Search is powered by SearchEngine
    @StateObject private var searchEngine = SearchEngine()
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var notesManager: NotesManager
    @State private var selectedNote: Note?
    @State private var isNoteDetailPresented = false
    
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(222), spacing: 12), count: 4), spacing: 12) {
                        ForEach(displayedNotes) { note in
                            NoteCard(note: note) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedNote = note
                                    isNoteDetailPresented = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 24)
                }
                .scrollIndicators(.never)
            }
            
            // Bottom Bar Component
            BottomBar(onNewNote: createAndOpenNewNote)
                .environmentObject(themeManager)
            
            // Floating Search Overlay (does not affect other buttons)
            FloatingSearch(engine: searchEngine)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, 18)
                .padding(.bottom, 18)
            
            // Note Detail Overlay
            if isNoteDetailPresented, let note = selectedNote {
                NoteDetailView(note: note, isPresented: $isNoteDetailPresented) { updated in
                    notesManager.updateNote(updated)
                    selectedNote = updated
                }
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(100)
            }
        }
        .frame(minWidth: 1109, minHeight: 782)
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
        // Search logic will be reintroduced with the redesigned manager
        .onAppear { searchEngine.setNotes(notesManager.notes) }
        .onChange(of: notesManager.notes) { _, notes in searchEngine.setNotes(notes) }
    }
    
    private var displayedNotes: [Note] {
        // For now always show all notes until the new search manager is introduced
        return notesManager.notes
    }
    
    private var headerView: some View {
        Color.clear
            .frame(height: 22)
    }
    
    private func createAndOpenNewNote() {
        let note = notesManager.addNote(title: "New Note", content: "")
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedNote = note
            isNoteDetailPresented = true
        }
    }
    
}

#Preview {
    ContentView()
        .environmentObject(NotesManager())
        .environmentObject(ThemeManager())
}

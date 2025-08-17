//
//  ContentView.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import SwiftUI

// MARK: - Backward Compatibility Extension
extension View {
    @ViewBuilder
    func adaptiveGlass(in shape: some Shape) -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular, in: shape)
        } else {
            self.background(.ultraThinMaterial, in: shape)
                .overlay(shape.stroke(.quaternary))
        }
    }
    
    @ViewBuilder
    func conditionalGlassEffect(shouldApply: Bool) -> some View {
        if shouldApply {
            if #available(macOS 26.0, *) {
                self.glassEffect(.regular.interactive())
            } else {
                self
            }
        } else {
            self
        }
    }
}

struct ContentView: View {
    // Search will be redesigned; removing old manager
    @StateObject private var searchEngine = SearchEngine()
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedNote: Note?
    @State private var isNoteDetailPresented = false
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
            BottomBar()
                .environmentObject(themeManager)
            
            // Floating Search Overlay (does not affect other buttons)
            FloatingSearch(engine: searchEngine)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, 18)
                .padding(.bottom, 18)
            
            // Note Detail Overlay
            if isNoteDetailPresented, let note = selectedNote {
                NoteDetailView(note: note, isPresented: $isNoteDetailPresented)
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(100)
            }
        }
        .frame(minWidth: 1109, minHeight: 782)
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
        // Search logic will be reintroduced with the redesigned manager
        .onAppear { searchEngine.setNotes(sampleNotes) }
        .onChange(of: sampleNotes) { _, notes in searchEngine.setNotes(notes) }
    }
    
    private var displayedNotes: [Note] {
        // For now always show all notes until the new search manager is introduced
        return sampleNotes
    }
    
    private var headerView: some View {
        Color.clear
            .frame(height: 22)
    }
    
}

#Preview {
    ContentView()
}


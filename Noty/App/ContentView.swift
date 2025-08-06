//
//  ContentView.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var isHoveringSearch = false
    @State private var isSearchExpanded = false
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @Namespace private var searchAnimation
    
    // Sample searchable data
    private let searchableItems = [
        "TODO-2025.md",
        "TODO-2024.md", 
        "TODO-2023.md",
        "Recent activities",
        "Upcoming adventures",
        "Creative projects",
        "Community events",
        "Personal reflections",
        "Culinary experiments",
        "Fitness goals"
    ]
    
    private var filteredResults: [String] {
        if searchText.isEmpty {
            return []
        }
        return searchableItems.filter { item in
            item.lowercased().contains(searchText.lowercased())
        }
    }
    
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
                        ForEach(sampleNotes) { note in
                            NoteCard(note: note)
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 24)
                }
            }
            
            // Liquid Glass Search - Positioned inline with bottom actions
            VStack {
                Spacer()
                
                HStack {
                    // Search Bar - positioned at bottom-left, same level as other bottom actions
                    if isSearchExpanded {
                        // Expanded search container with results inside
                        VStack(spacing: 12) {
                            // Results Container - inside the search bar
                            if !filteredResults.isEmpty {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(Array(filteredResults.enumerated()), id: \.offset) { index, result in
                                        HStack(spacing: 12) {
                                            // Use proper note-card-thumbnail from assets
                                            Image("note-card-thumbnail")
                                                .resizable()
                                                .frame(width: 18, height: 22)
                                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                            
                                            Text(result)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding(.all, 12)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            searchText = result
                                            isSearchExpanded = false
                                            isSearchFocused = false
                                        }
                                    }
                                }
                                .background(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.7), in: RoundedRectangle(cornerRadius: 16))
                                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
                            }
                            
                            // Search Input - at bottom of search container
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.322, green: 0.322, blue: 0.357))
                                
                                TextField("", text: $searchText)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                                    .focused($isSearchFocused)
                                    .textFieldStyle(PlainTextFieldStyle())
                                
                                Button {
                                    isSearchExpanded = false
                                    searchText = ""
                                    isSearchFocused = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 0.322, green: 0.322, blue: 0.357))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.all, 12)
                        .frame(width: 400)
                        .background(Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.6), in: RoundedRectangle(cornerRadius: 24))
                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
                        .shadow(
                            color: Color.black.opacity(0.12),
                            radius: 20,
                            x: 0,
                            y: 8
                        )
                    } else {
                        // Collapsed search button
                        Button {
                            isSearchExpanded = true
                            isSearchFocused = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.322, green: 0.322, blue: 0.357))
                                
                                Text("Search")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(red: 0.322, green: 0.322, blue: 0.357))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 24))
                            .scaleEffect(isHoveringSearch ? 1.05 : 1.0)
                            .shadow(
                                color: Color.black.opacity(isHoveringSearch ? 0.08 : 0.05),
                                radius: isHoveringSearch ? 6 : 3,
                                x: 0,
                                y: isHoveringSearch ? 3 : 1.5
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { hovering in
                            isHoveringSearch = hovering
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18) // Same padding as bottom bar
                .animation(.easeInOut, value: isSearchExpanded)
                .animation(.easeInOut, value: isHoveringSearch)
            }
            
            // Bottom Bar Component
            BottomBar()
        }
        .frame(minWidth: 1109, minHeight: 782)
    }
    
    private var headerView: some View {
        Color.clear
            .frame(height: 22)
    }
    
}

#Preview {
    ContentView()
}

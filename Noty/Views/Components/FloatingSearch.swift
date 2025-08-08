//
//  FloatingSearch.swift
//  Noty
//
//  Created by AI on 08.08.25.
//
//  Clean search component based on Figma design with Apple's glass effects
//

import SwiftUI

enum SearchState {
    case collapsed      // Simple search pill
    case expanded       // Search bar only
    case withResults    // Search bar + current results
}

struct FloatingSearch: View {
    @ObservedObject var engine: SearchEngine
    @State private var searchState: SearchState = .collapsed
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @Namespace private var searchNamespace
    @State private var hoveredResultID: SearchHit.ID?
    @State private var isHoveringCollapsedPill = false
    
    var body: some View {
        // Keep a single surface that grows vertically; avoids jumping
        searchInput
        .onChange(of: searchText) { _, newValue in
            engine.query = newValue
            updateSearchState()
        }
        .onChange(of: engine.results) { _, _ in
            updateSearchState()
        }
        .keyboardShortcut("f", modifiers: [.command])
        .onAppear {
            // Notes are set from ContentView
        }
    }
    
    // MARK: - Search Input

    private var currentCornerRadius: CGFloat {
        switch searchState {
        case .collapsed:
            return 999
        case .expanded:
            return 999
        case .withResults:
            return 24
        }
    }

    // Inner hover highlight radius follows concentricity of the container's liquid glass
    private var hoverCornerRadius: CGFloat {
        // Min inset from container to hover background at corners:
        // horizontal: results padding (12) + row padding (6) = 18
        // vertical (top/bottom): results padding (12)
        let inset = CGFloat(12) // use the limiting inset for concentric rounding (min of 12 and 18)
        return max(6, currentCornerRadius - inset)
    }
    
    @ViewBuilder
    private var searchInput: some View {
        Group {
            if searchState == .collapsed {
                searchPill
            } else {
                searchBar
            }
        }
    }
    
    // Simple search pill button
    private var searchPill: some View {
        Button(action: expandSearch) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.078, green: 0.078, blue: 0.078))

                Text("Search")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102, opacity: 0.7))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: currentCornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .applyGlassEffect()
                    .matchedGeometryEffect(id: "searchSurface", in: searchNamespace)
            )
            .scaleEffect(isHoveringCollapsedPill ? 1.05 : 1.0)
            .shadow(
                color: Color.black.opacity(isHoveringCollapsedPill ? 0.12 : 0.05),
                radius: isHoveringCollapsedPill ? 6 : 3,
                x: 0,
                y: isHoveringCollapsedPill ? 3 : 1.5
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHoveringCollapsedPill = hovering
        }
        .animation(.easeInOut, value: isHoveringCollapsedPill)
    }
    
    // Expanded search bar
    private var searchBar: some View {
        VStack(spacing: 0) {
            // Results live inside the same surface, above the input
            if searchState == .withResults && !engine.results.isEmpty {
                VStack(spacing: 0) {
                    ForEach(engine.results) { result in
                        resultRow(result)
                    }
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)
                .padding(.bottom, 12) // 12px gap to input field below
            }

            // Bottom row: icon, field, trailing action (contextual)
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.078, green: 0.078, blue: 0.078))

                TextField("Search", text: $searchText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                    .focused($isSearchFocused)
                    .textFieldStyle(.plain)
                // Show a delete icon only when results are visible; hide in pure expanded state
                if searchState == .withResults {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "delete.left.fill")
                            .font(.system(size: 18))
                            .background(Color("#000000"))                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .background(
            Group {
                if searchState == .withResults {
                    // Solid background for results container (no translucency)
                    RoundedRectangle(cornerRadius: currentCornerRadius, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: currentCornerRadius, style: .continuous)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        // Subtle highlight for "liquid glass" feel
                        .overlay(
                            RoundedRectangle(cornerRadius: currentCornerRadius, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [
                                        Color.white.opacity(0.55),
                                        Color.white.opacity(0.0)
                                    ], startPoint: .top, endPoint: .bottom)
                                )
                                .blendMode(.overlay)
                                .allowsHitTesting(false)
                        )
                } else {
                    // Keep translucent look for collapsed/expanded bar (no results)
                    RoundedRectangle(cornerRadius: currentCornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .applyGlassEffect()
                        .matchedGeometryEffect(id: "searchSurface", in: searchNamespace)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: currentCornerRadius, style: .continuous))
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1.5)
        .frame(maxWidth: 300)
        // ESC to close the bar (replaces 'x' in expanded state)
        .onExitCommand {
            closeSearch()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
    }
    
    private func resultRow(_ result: SearchHit) -> some View {
        let isHovered = hoveredResultID == result.id
        return HStack(spacing: 12) {
            // Asset-based thumbnail
            Image("note-card-thumbnail")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 22)
                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

            Text(result.note.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                .lineLimit(1)

            Spacer()

            // Hover affordance to indicate navigation
            Image(systemName: "arrow.right.circle.fill")
                .font(.system(size: 13, weight: .semibold))
                .background(Color("#000000"))
                .opacity(isHovered ? 1 : 0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if isHovered {
                    RoundedRectangle(cornerRadius: hoverCornerRadius, style: .continuous)
                        .fill(Color(red: 0.925, green: 0.925, blue: 0.925)) // #ECECEC
                }
            }
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            hoveredResultID = hovering ? result.id : (hoveredResultID == result.id ? nil : hoveredResultID)
        }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
    
    // MARK: - Actions
    
    private func expandSearch() {
        withAnimation(.bouncy(duration: 0.6)) {
            searchState = .expanded
        }
    }
    
    private func closeSearch() {
        if searchText.isEmpty {
            withAnimation(.bouncy(duration: 0.6)) {
                searchState = .collapsed
                isSearchFocused = false
            }
        } else {
            searchText = ""
        }
    }
    
    private func updateSearchState() {
        withAnimation(.bouncy(duration: 0.6)) {
            if searchText.isEmpty {
                searchState = searchState == .collapsed ? .collapsed : .expanded
            } else {
                searchState = .withResults
            }
        }
    }
}

// MARK: - Glass Effect Extension

extension View {
    @ViewBuilder
    func applyGlassEffect() -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular)
        } else {
            self
        }
    }
}

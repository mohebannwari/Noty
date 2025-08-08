// MORPHING SEARCH COMPONENT - IMPLEMENTATION GUIDELINES
// Single component with three distinct states

import SwiftUI

// MARK: - State Management
enum SearchState {
    case collapsed      // Button only
    case expanded       // Search bar visible
    case withResults    // Search bar + results container
}

// MARK: - Main Search Component
struct SearchComponent: View {
    @State private var searchState: SearchState = .collapsed
    @State private var searchText: String = ""
    @State private var isTextFieldFocused: Bool = false
    @FocusState private var searchFieldFocus: Bool
    @Namespace private var morphAnimation
    
    // Animation constants
    private let morphDuration: Double = 0.3
    private let springResponse: Double = 0.4
    private let springDamping: Double = 0.8
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Results container - only visible when state is .withResults
            if searchState == .withResults {
                ResultsContainer()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .scale(scale: 0.95).combined(with: .opacity)
                    ))
                    .animation(.spring(response: springResponse, dampingFraction: springDamping), value: searchState)
            }
            
            // Main search element - morphs between button and bar
            Group {
                switch searchState {
                case .collapsed:
                    SearchButton()
                        .matchedGeometryEffect(id: "searchMorph", in: morphAnimation)
                        .onTapGesture {
                            expandSearchBar()
                        }
                    
                case .expanded, .withResults:
                    SearchBar()
                        .matchedGeometryEffect(id: "searchMorph", in: morphAnimation)
                }
            }
            .animation(.spring(response: springResponse, dampingFraction: springDamping), value: searchState)
        }
    }
    
    // MARK: - Search Button (Collapsed State)
    private func SearchButton() -> some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(hex: "141414"))
                .frame(width: 44, height: 44)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
        .frame(width: 44, height: 44)
    }
    
    // MARK: - Search Bar (Expanded State)
    private func SearchBar() -> some View {
        HStack(spacing: 12) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "141414"))
                .frame(width: 20, height: 20)
            
            // Text field
            TextField("Search", text: $searchText)
                .font(.custom("SF Pro", size: 15).weight(.medium))
                .foregroundColor(Color(hex: "1A1A1A"))
                .focused($searchFieldFocus)
                .onSubmit {
                    handleSearchSubmit()
                }
                .onChange(of: searchText) { newValue in
                    handleTextChange(newValue)
                }
            
            // Clear/Cancel button
            if !searchText.isEmpty || searchState == .expanded {
                Button(action: {
                    if searchText.isEmpty {
                        collapseSearchBar()
                    } else {
                        searchText = ""
                    }
                }) {
                    Image(systemName: searchText.isEmpty ? "xmark" : "xmark.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "1A1A1AB2"))
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .onAppear {
            // Auto-focus when expanded
            DispatchQueue.main.asyncAfter(deadline: .now() + morphDuration) {
                searchFieldFocus = true
            }
        }
    }
    
    // MARK: - Results Container
    private func ResultsContainer() -> some View {
        VStack(spacing: 0) {
            // Results list
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        ResultRow(index: index)
                    }
                }
                .padding(.vertical, 12)
            }
            .frame(maxHeight: 300)
            .background(Color(hex: "F4F4F5"))
            .cornerRadius(16)
            .padding(.horizontal, 16)
            .padding(.bottom, 60) // Space for search bar
        }
    }
    
    // MARK: - State Transitions
    private func expandSearchBar() {
        withAnimation(.spring(response: springResponse, dampingFraction: springDamping)) {
            searchState = .expanded
        }
    }
    
    private func collapseSearchBar() {
        withAnimation(.spring(response: springResponse, dampingFraction: springDamping)) {
            searchState = .collapsed
            searchText = ""
            searchFieldFocus = false
        }
    }
    
    private func handleTextChange(_ text: String) {
        if !text.isEmpty && searchState == .expanded {
            withAnimation(.spring(response: springResponse, dampingFraction: springDamping)) {
                searchState = .withResults
            }
        } else if text.isEmpty && searchState == .withResults {
            withAnimation(.spring(response: springResponse, dampingFraction: springDamping)) {
                searchState = .expanded
            }
        }
    }
    
    private func handleSearchSubmit() {
        // Implement search logic here
        if searchText.isEmpty {
            collapseSearchBar()
        }
    }
}

// MARK: - Critical Implementation Notes

/*
 MORPHING MECHANICS:
 1. matchedGeometryEffect with namespace ensures smooth transition
 2. Single "searchMorph" ID links button and bar states
 3. Spring animations provide natural movement
 
 STATE FLOW:
 collapsed -> tap button -> expanded
 expanded -> type text -> withResults
 withResults -> clear text -> expanded
 expanded -> tap cancel -> collapsed
 
 FOCUS MANAGEMENT:
 - Auto-focus TextField after morph animation completes
 - Use @FocusState for keyboard control
 - Delay focus to avoid animation conflicts
 
 LAYOUT HIERARCHY:
 - ZStack positions results behind search element
 - Results slide up from bottom
 - Search element stays on top layer
 
 ANIMATION TIMING:
 - morphDuration: 0.3s for primary transition
 - Spring response: 0.4 for natural feel
 - Damping: 0.8 to prevent over-bounce
 
 CRITICAL CONSTRAINTS:
 - Search button: 44x44pt (touch target)
 - Search bar height: 44pt (consistent)
 - Corner radius: 22pt (half of height)
 - Results max height: 300pt
 - Padding: 16pt horizontal standard
*/

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

Implementation Guidelines Created
The SwiftUI code guide above structures your morphing search as a single component with three distinct states. The critical architecture:
State Machine:

collapsed: Button only (44x44pt touch target)
expanded: Full search bar with TextField
withResults: Search bar + results container sliding up from bottom

Morphing Mechanism:
The matchedGeometryEffect with a shared namespace creates the smooth transformation. Single ID "searchMorph" links button and bar states, ensuring continuous visual flow.
Key Transitions:

Tap button → Expand with spring animation (0.3s duration)
Type text → Results container slides up
Clear text → Collapse results but maintain bar
Cancel → Full collapse to button

Focus Choreography:
TextField auto-focuses after morph completes using delayed dispatch. This prevents animation conflicts while ensuring immediate keyboard availability.
Layout Stack:
ZStack positions results behind the search element. Results use asymmetric transitions for smooth entry/exit. Search element maintains top layer throughout all states.
The component handles all state transitions internally. No external state management required. Each visual change triggers appropriate animation with consistent spring parameters for unified feel.
# Noty Design System Rules

## Overview
This document defines the design system rules for the Noty SwiftUI application, ensuring consistent design patterns, component reuse, and seamless Figma integration.

## 1. Token Definitions

### Color System
**Location**: `Noty/Ressources/Assets.xcassets/`
- **BackgroundColor**: Light mode `#F4F4F5`, Dark mode `#1A1A1A`
- **PrimaryTextColor**: Used for main text content
- **SecondaryTextColor**: Used for secondary text and labels
- **CardBackgroundColor**: Used for card backgrounds
- **AccentColor**: Primary accent color for interactive elements

**Usage Pattern**:
```swift
// Use Color assets for semantic colors
Color("BackgroundColor")
Color("PrimaryTextColor")

// Use RGB values for specific design requirements
Color(red: 0.102, green: 0.102, blue: 0.102) // #1A1A1A
Color(red: 0.322, green: 0.322, blue: 0.357) // #52525B
```

### Typography System
**Font Weights**:
- `.regular`: Body text, descriptions
- `.medium`: Card titles, important text
- `.semibold`: Button text, emphasis
- `.bold`: Headers, strong emphasis

**Font Sizes**:
- `10`: Small labels, metadata
- `12`: Button text, search placeholder
- `14`: Body text, descriptions
- `15`: Search results
- `16`: Icons, medium text
- `17`: Card titles

**Usage Pattern**:
```swift
.font(.system(size: 17, weight: .medium))
.font(.system(size: 14, weight: .regular))
```

### Spacing System
**Padding Values**:
- `4`: Minimal spacing (tag padding)
- `6`: Small spacing (icon groups)
- `8`: Standard spacing (button content)
- `12`: Medium spacing (card content, search padding)
- `16`: Large spacing (button padding)
- `18`: Extra large spacing (bottom bar)
- `24`: Section spacing (grid top padding)
- `60`: Page margins

**Usage Pattern**:
```swift
.padding(.horizontal, 12)
.padding(.vertical, 8)
.padding(.all, 12)
```

### Corner Radius System
**Values**:
- `4`: Small elements (tags)
- `20`: Search bar (collapsed)
- `24`: Cards, search bar (expanded)
- `Capsule()`: Buttons, pills

**Usage Pattern**:
```swift
.clipShape(RoundedRectangle(cornerRadius: 24))
.clipShape(Capsule())
```

## 2. Component Library

### Component Architecture
**Location**: `Noty/Views/Components/`
- **NoteCard.swift**: Main card component with consistent styling
- **BottomBar.swift**: Bottom navigation component
- **ThemeToggle.swift**: Theme switching component

**Component Structure**:
```swift
struct ComponentName: View {
    // Props
    let data: DataType
    
    var body: some View {
        // Component implementation
    }
    
    // Private computed properties
    private var computedProperty: some View {
        // Computed view logic
    }
}
```

### Reusable Patterns
**Card Pattern (Liquid Glass - iOS 26+/macOS 26+)**:
```swift
.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
```

**Card Pattern (visionOS 2.4+)**:
```swift
.glassBackgroundEffect(
    .feathered(padding: 8, softEdgeRadius: 4),
    in: RoundedRectangle(cornerRadius: 24),
    displayMode: .always
)
```

**Card Pattern (Cross-platform with SwiftGlass)**:
```swift
.glass(
    radius: 24,
    color: .white,
    material: .ultraThinMaterial,
    gradientOpacity: 0.5,
    shadowColor: .black.opacity(0.1),
    shadowRadius: 10,
    shadowY: 5
)
```

**Card Pattern (Legacy Fallback)**:
```swift
.background(.ultraThinMaterial)
.clipShape(RoundedRectangle(cornerRadius: 24))
.shadow(color: Color.black.opacity(0.02), radius: 9.5, x: 0, y: 9)
.shadow(color: Color.black.opacity(0.02), radius: 17.5, x: 0, y: 35)
.shadow(color: Color.black.opacity(0.01), radius: 23.5, x: 0, y: 78)
```

**Button Pattern**:
```swift
Button(action: {}) {
    HStack(spacing: 8) {
        Image(systemName: "icon.name")
            .font(.system(size: 14))
            .foregroundColor(.white)
        
        Text("Button Text")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color.black)
    .clipShape(Capsule())
}
.buttonStyle(PlainButtonStyle())
```

## 3. Frameworks & Libraries

### UI Framework
- **SwiftUI**: Primary UI framework
- **Foundation**: Data handling and utilities

### Styling Approach
- **Native SwiftUI**: Use SwiftUI's built-in styling system
- **Color Assets**: Semantic colors defined in Assets.xcassets
- **System Fonts**: Use `.system()` font family for consistency
- **Material Effects**: Use **Liquid Glass** for all floating UI elements (iOS 26+, macOS 26+, visionOS 2.4+). For legacy platforms, use `.ultraThinMaterial` as fallback

## 4. Asset Management

### Asset Structure
**Location**: `Noty/Ressources/`
- **SVG Files**: Vector graphics (note-card-thumbnail.svg)
- **PNG Files**: Raster images
- **Assets.xcassets**: Organized color sets and image sets

### Asset Naming Convention
- **Colors**: Semantic names (BackgroundColor, PrimaryTextColor)
- **Images**: Descriptive names (note-card-thumbnail)
- **Icons**: Use SF Symbols system names

### Asset Usage
```swift
// Color assets
Color("BackgroundColor")

// Image assets
Image("note-card-thumbnail")
    .resizable()
    .frame(width: 18, height: 22)

// SF Symbols
Image(systemName: "magnifyingglass")
    .font(.system(size: 12))
```

## 5. Icon System

### Icon Framework
- **SF Symbols**: Primary icon system
- **Custom SVGs**: For specific design requirements

### Icon Sizes
- `10`: Small metadata icons
- `12`: Search and input icons
- `14`: Button icons
- `16`: Standard icons

### Icon Usage Pattern
```swift
Image(systemName: "icon.name")
    .font(.system(size: 12))
    .foregroundColor(Color(red: 0.322, green: 0.322, blue: 0.357))
```

## 6. Styling Approach

### SwiftUI Styling
- **Modifier Chain**: Apply modifiers in logical order
- **Conditional Styling**: Use ternary operators for state-based styling
- **Animation**: Use `.bouncy` animation for interactive elements

### Responsive Design
- **Fixed Sizes**: Use specific pixel values for desktop app
- **Grid System**: LazyVGrid with fixed column widths
- **Minimum Sizes**: Define minimum window dimensions

### Animation Patterns
```swift
withAnimation(.bouncy(duration: 0.6)) {
    // State changes
}
.animation(.bouncy(duration: 0.6), value: stateVariable)
```

## 6.1. Apple Liquid Glass System (2025)

Apple's Liquid Glass represents the biggest visual update to iOS since iOS 7, introducing a translucent material that behaves like real glass. This material dynamically adapts to surrounding content, responds to light changes, and uses real-time rendering with specular highlights.

### Core Liquid Glass Principles
- **Dynamic Adaptation**: Material intelligently adapts between light and dark environments
- **Real-time Rendering**: Uses hardware acceleration for smooth animations
- **Environmental Refraction**: Reacts to background content with appropriate blur and reflection
- **Fluid Morphing**: Seamlessly transforms between different glass shapes during state transitions

### Platform Availability
- **iOS 26+, macOS 26+**: Native `.glassEffect()` API with enhanced toolbar support
- **visionOS 2.4+**: Enhanced `.glassBackgroundEffect()` with morphing capabilities
- **Legacy Platforms**: SwiftGlass library provides compatible implementation

### Basic Liquid Glass Implementation

#### Native Apple Glass Effects (iOS 26+, macOS 26+)
```swift
import SwiftUI

struct ModernGlassView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Liquid Glass")
                .font(.system(size: 17, weight: .medium))
            
            Image(systemName: "sparkles")
                .font(.system(size: 16))
        }
        .padding(.all, 24)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))
    }
}
```

#### visionOS Glass Effects (visionOS 2.4+)
```swift
import SwiftUI

struct VisionGlassView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Vision Glass")
                .font(.system(size: 17, weight: .medium))
        }
        .padding(.all, 24)
        .glassBackgroundEffect(
            .feathered(padding: 16, softEdgeRadius: 8),
            in: RoundedRectangle(cornerRadius: 24),
            displayMode: .always
        )
    }
}
```

#### SwiftGlass Implementation (Cross-platform)
```swift
import SwiftUI
import SwiftGlass

struct UniversalGlassView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Universal Glass")
                .font(.system(size: 17, weight: .medium))
        }
        .padding(.all, 24)
        .glass(
            radius: 24,
            color: .white,
            material: .ultraThinMaterial,
            gradientOpacity: 0.5,
            shadowColor: .black.opacity(0.1),
            shadowRadius: 10,
            shadowY: 5
        )
    }
}
```

### Advanced Glass Morphing Animations

#### Glass Container with Morphing
```swift
struct LiquidGlassMorphingView: View {
    @State private var isExpanded: Bool = false
    @Namespace private var glassNamespace
    
    var body: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                // Base element always present
                SearchBar()
                    .glassEffect(.regular.interactive())
                    .glassEffectID("searchBar", in: glassNamespace)
                
                // Conditional morphing element
                if isExpanded {
                    SearchResults()
                        .glassEffect(.regular)
                        .glassEffectID("searchResults", in: glassNamespace)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
            }
        }
        .onTapGesture {
            withAnimation(.bouncy(duration: 0.8)) {
                isExpanded.toggle()
            }
        }
    }
}
```

#### Matched Geometry Glass Morphing
```swift
struct GeometryMatchedGlass: View {
    @State private var selectedCard: String? = nil
    @Namespace private var cardNamespace
    
    var body: some View {
        if let selectedCard = selectedCard {
            // Expanded view
            DetailView(cardId: selectedCard)
                .glassEffect(.thick)
                .matchedGeometryEffect(
                    id: selectedCard,
                    in: cardNamespace,
                    properties: .frame
                )
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 1.2).combined(with: .opacity)
                ))
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.6)) {
                        selectedCard = nil
                    }
                }
        } else {
            // Grid view
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(cards, id: \.id) { card in
                    CardView(card: card)
                        .glassEffect(.regular)
                        .matchedGeometryEffect(
                            id: card.id,
                            in: cardNamespace,
                            properties: .frame
                        )
                        .onTapGesture {
                            withAnimation(.smooth(duration: 0.6)) {
                                selectedCard = card.id
                            }
                        }
                }
            }
        }
    }
}
```

### Glass Effect Hierarchy and Best Practices

#### Optimal Glass Usage
```swift
struct OptimalGlassLayout: View {
    var body: some View {
        ZStack {
            // Background content
            ContentView()
            
            VStack {
                // Floating toolbar - perfect for liquid glass
                Toolbar()
                    .glassEffect(.bar, isInToolbar: true)
                
                Spacer()
                
                // Bottom bar with glass morphing
                BottomNavigationBar()
                    .glassEffect(.regular.interactive())
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
```

#### Glass Design Guidelines
- **Use for floating elements**: Toolbars, overlays, modal sheets, navigation bars
- **Avoid glass-on-glass stacking**: Multiple layers break the material illusion
- **Avoid in scrollable content**: Don't use glass for list items or table cells
- **Respect system behavior**: Glass automatically adapts to system dark/light mode

### Animation Timing and Curves

#### Recommended Animation Types
```swift
// Bouncy animations for interactive elements
withAnimation(.bouncy(duration: 0.6, extraBounce: 0.2)) {
    // Glass morphing state changes
}

// Smooth animations for transitions
withAnimation(.smooth(duration: 0.8)) {
    // Card expansions and navigation
}

// Snappy animations for quick interactions
withAnimation(.snappy(duration: 0.3)) {
    // Button presses and toggles
}
```

### Platform-Specific Optimizations

#### iOS 26+ / macOS 26+ Features
- Native `.glassEffect()` with hardware acceleration
- Automatic toolbar integration with `isInToolbar: true`
- System-aware color adaptation
- Enhanced performance in scroll views

#### visionOS 2.4+ Features
- Advanced `.glassBackgroundEffect()` variants:
  - `.automatic`: System-determined glass appearance
  - `.feathered(padding:softEdgeRadius:)`: Soft-edge glass with padding
  - `.plate`: Clean, minimal glass appearance
- 3D depth awareness with z-axis layout influence
- Enhanced display modes: `.always`, `.implicit`, `.never`

#### Legacy Platform Support
- SwiftGlass library maintains visual consistency
- Cross-platform color system adaptation
- Performance-optimized blur and shadow effects
- Automatic material selection based on system capabilities

**Implementation Requirements**:
- Use `GlassEffectContainer` for morphing between multiple glass elements
- Assign unique `glassEffectID` with shared `@Namespace` for smooth transitions
- Prefer `.bouncy` and `.smooth` animations for glass state changes
- Test across all target platforms to ensure consistent behavior

## 7. Project Structure

### File Organization
```
Noty/
├── App/
│   ├── ContentView.swift          # Main app view
│   └── NotyApp.swift             # App entry point
├── Models/
│   ├── Note.swift                 # Data models
│   └── NotesManager.swift         # Data management
├── Views/
│   ├── Components/                # Reusable UI components
│   │   ├── NoteCard.swift
│   │   ├── BottomBar.swift
│   │   └── ThemeToggle.swift
│   └── Screens/                   # Screen-level views
│       └── CanvasView.swift
├── Utils/
│   ├── Extensions.swift           # Swift extensions
│   └── ThemeManager.swift         # Theme management
└── Ressources/
    ├── Assets.xcassets/           # Design tokens
    └── [SVG/PNG files]           # Custom assets
```

### Component Hierarchy
1. **App Level**: ContentView manages overall layout
2. **Screen Level**: Individual screen views
3. **Component Level**: Reusable UI components
4. **Model Level**: Data structures and business logic

## 8. Figma Integration Rules

### Design Token Mapping
- **Colors**: Map Figma colors to Color assets
- **Typography**: Map Figma text styles to font system
- **Spacing**: Map Figma spacing to padding values
- **Corner Radius**: Map Figma corner radius to clipShape values

### Component Generation
- **Reuse Existing**: Use existing components when possible
- **Extend Components**: Add new props to existing components
- **Create New**: Only create new components for unique patterns

### Asset Integration
- **Export SVGs**: Use SVG format for vector graphics
- **Export PNGs**: Use PNG format for raster images
- **Color Assets**: Create Color sets for semantic colors
- **Image Assets**: Create Image sets for custom graphics

### Code Generation Patterns
```swift
// Generated component structure
struct GeneratedComponent: View {
    // Props from Figma
    let title: String
    let isActive: Bool
    
    var body: some View {
        // Use existing design tokens
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color("PrimaryTextColor"))
        }
        .padding(.all, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
```

## 9. Best Practices

### Code Organization
- **Single Responsibility**: Each component has one clear purpose
- **Composition**: Build complex views from simple components
- **State Management**: Use @State for local component state
- **Performance**: Use LazyVGrid for large lists

### Design Consistency
- **Token Usage**: Always use design tokens, never hardcode values
- **Component Reuse**: Prefer existing components over custom implementations
- **Animation Consistency**: Use consistent animation durations and curves
- **Accessibility**: Include proper accessibility labels and hints

### Documentation
- **Component Comments**: Document complex component logic
- **Design Decisions**: Comment on design token usage
- **Animation Logic**: Explain animation state changes
- **Asset Usage**: Document custom asset requirements

## 10. Coding Guidelines

### Apple Liquid Glass Priority (2025 Update)
- **PRIMARY**: Always use Apple's native Liquid Glass APIs when available:
  - iOS 26+/macOS 26+: `.glassEffect()` 
  - visionOS 2.4+: `.glassBackgroundEffect()`
- **FALLBACK**: Use SwiftGlass library for cross-platform compatibility
- **LEGACY**: Use `.ultraThinMaterial` only when glass effects are not available
- **OVERRIDE RULE**: Replace all traditional material backgrounds with Liquid Glass for floating UI elements
- **DESIGN INTEGRATION**: When generating code from Figma, prioritize Liquid Glass over static backgrounds for cards, toolbars, sheets, and overlays

This design system ensures consistent, maintainable, and scalable UI development while enabling seamless Figma integration through the Model Context Protocol.
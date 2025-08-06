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
**Card Pattern**:
```swift
.background(Color.white)
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
- **Material Effects**: Use `.ultraThinMaterial` for floating elements

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

### Styling Memory
- Always work with the newest `.glassEffect()`
- **Overwrite the design styles of figma components with liquid glass where possible, as long as the new SDK is provided!**

This design system ensures consistent, maintainable, and scalable UI development while enabling seamless Figma integration through the Model Context Protocol.
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Noty is an iOS note-taking application built with SwiftUI. The project follows a clean architecture pattern with organized folders for models, views, utilities, and resources.

## Development Commands

### Build and Run
- Open `Noty.xcodeproj` in Xcode
- Use Cmd+R to build and run the app in the simulator
- Use Cmd+B to build without running
- Use Cmd+U to run tests (when available)

### Project Management
- The project uses Xcode's built-in build system
- No external package managers (CocoaPods, Carthage, SPM) are currently configured
- Asset catalogs are managed through Xcode's interface

## Architecture

### Folder Structure
- `App/`: Contains the main app entry point (`NotyApp.swift`) and root content view
- `Models/`: Data models including `Note.swift` and `NotesManager.swift` 
- `Views/`: UI components organized into:
  - `Screens/`: Full-screen views like `CanvasView.swift`
  - `Components/`: Reusable UI components (`NoteCard.swift`, `BottomBar.swift`, `ThemeToggle.swift`)
- `Utils/`: Utility classes including `ThemeManager.swift` and `Extensions.swift`
- `Ressources/`: Assets including color sets for theming support

### Key Components
- **App Entry**: `NotyApp.swift` is the main app struct using `@main`
- **Content View**: Currently shows a placeholder "Hello, world!" interface
- **Theme System**: Dedicated color assets for light/dark theme support with custom colors:
  - AccentColor, BackgroundColor, CardBackgroundColor
  - PrimaryTextColor, SecondaryTextColor
- **Component Architecture**: Prepared structure for note cards, bottom navigation, and theme toggling

### Current State
The project appears to be in early development with:
- Basic SwiftUI app structure established
- Theme system color assets configured
- Component files created but not yet implemented
- Model files prepared but empty

## Development Notes

- Most Swift files contain only copyright headers and are ready for implementation
- The Info.plist contains malformed content that may need correction
- Theme system is prepared with comprehensive color asset catalog
- Project structure suggests a canvas-based note-taking interface with card-based note display
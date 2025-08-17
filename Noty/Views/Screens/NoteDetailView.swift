//
//  NoteDetailView.swift
//  Noty
//
//  Created by AI on 15.08.25.
//
//  Note detail/editor view with optimized liquid glass animations

import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @Binding var isPresented: Bool
    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var editedTags: [String]
    // Todo items are now integrated into the text content
    @State private var newTagText = ""
    @State private var isAddingTag = false
    @FocusState private var isAddingTagFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    // Animation states for liquid glass coordination
    @State private var isViewMaterialized = false
    @State private var glassElementsVisible = false
    @State private var bottomControlsExpanded = false
    @Namespace private var glassNamespace
    
    init(note: Note, isPresented: Binding<Bool>) {
        self.note = note
        self._isPresented = isPresented
        self._editedTitle = State(initialValue: note.title)
        
        // Initialize content with integrated checkboxes
        let contentWithTodos = """
\(note.content)

[ ] Get coffee
[ ] Buy groceries  
[ ] Go for a walk
"""
        self._editedContent = State(initialValue: contentWithTodos)
        self._editedTags = State(initialValue: note.tags)
    }
    
    var body: some View {
        ZStack {
            // Clean background matching app background
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            // Main content layout
            VStack(spacing: 0) {
                // Header area with back button
                headerGlassContainer
                
                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        // Date and edit info
                        dateAndEditInfo
                        
                        // Title
                        titleSection
                        
                        // Tags with liquid glass interaction
                        tagSection
                        
                        // Main text content - editable with inline checkbox blocks
                        RichTextEditor(text: $editedContent)
                        
                        // Webclip preview card (Figma)
                        WebClipThumbnail(
                            imageNameLight: "note-card-thumbnail",
                            imageNameDark: "note-card-thumbnail-DM",
                            title: "Exciting Recent Activities to Explore",
                            excerpt: "Raindrops gently tapped on the attic window while I flipped open my journal. Dust particles swirled in the lone beam of light.",
                            domain: "funadventures.com"
                        )
                        
                        // Bottom spacing for floating controls
                        Spacer()
                            .frame(height: 120)
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .scrollIndicators(.never)
                
                Spacer()
            }
            
            // Floating bottom controls - separate glass element
            VStack {
                Spacer()
                bottomGlassControls
            }
        }
        .opacity(isViewMaterialized ? 1 : 0)
        .scaleEffect(isViewMaterialized ? 1 : 0.95)
        .animation(.bouncy(duration: 0.8), value: isViewMaterialized)
        .onAppear {
            // Materialization animation following liquid glass guidelines
            withAnimation(.bouncy(duration: 0.8).delay(0.1)) {
                isViewMaterialized = true
            }
            
            // Staggered glass element materialization for droplet effect
            withAnimation(.bouncy(duration: 0.6).delay(0.3)) {
                glassElementsVisible = true
            }
            
            withAnimation(.bouncy(duration: 0.6).delay(0.5)) {
                bottomControlsExpanded = true
            }
        }
        .onDisappear {
            // Dematerialization animation
            withAnimation(.bouncy(duration: 0.6)) {
                isViewMaterialized = false
                glassElementsVisible = false
                bottomControlsExpanded = false
            }
        }
    }
    
    // MARK: - Header Glass Container
    
    private var headerGlassContainer: some View {
        HStack {
            // Back button with liquid glass interactive behavior
            Button(action: closeNote) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial, in: Circle())
                    .applyGlassEffect()
                    .scaleEffect(glassElementsVisible ? 1 : 0.8)
                    .opacity(glassElementsVisible ? 1 : 0)
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Date and Edit Info (now separate, left-aligned)
    
    private var dateAndEditInfo: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .font(.system(size: 12))
                .foregroundColor(Color("TertiaryTextColor"))
            
            Text(dateFormatter.string(from: note.date))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("TertiaryTextColor"))
            
            Text("•")
                .font(.system(size: 12))
                .foregroundColor(Color("TertiaryTextColor"))
            
            Text("Edited Today at 12:15")
                .font(.system(size: 12))
                .foregroundColor(Color("TertiaryTextColor"))
        }
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        TextField("Note Title", text: $editedTitle)
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(Color("PrimaryTextColor"))
            .textFieldStyle(.plain)
            .padding(.vertical, 12)
    }
    
    // MARK: - Tag Section with Liquid Glass Morphing
    
    private var tagSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                // New tag button with morphing glass behavior (Figma: dashed capsule with plus)
                Group {
                    if isAddingTag {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                                .foregroundColor(Color("AccentColor"))
                            TextField("New tag", text: $newTagText)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color("PrimaryTextColor"))
                                .focused($isAddingTagFocused)
                                .textFieldStyle(.plain)
                                .lineLimit(1)
                                .onSubmit { addNewTag() }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.black.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        )
                        .applyGlassEffect()
                    } else {
                        Button(action: startAddingTag) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 12))
                                Text("New tag")
                                    .font(.system(size: 12, weight: .semibold))
                                    .lineLimit(1)
                            }
                            .foregroundColor(Color("TertiaryTextColor"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.black.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [4]))
                            )
                            .applyGlassEffect()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .animation(.bouncy(duration: 0.6), value: isAddingTag)
                
                // Existing tags with glass droplet behavior
                ForEach(editedTags, id: \.self) { tag in
                    tagView(tag)
                }
                
                Spacer()
            }
        }
    }
    
    private func tagView(_ tag: String) -> some View {
        HStack(spacing: 6) {
            Text(tag)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
            
            Button(action: { removeTag(tag) }) {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color("AccentColor"), in: Capsule())
        .applyGlassEffect()
        .scaleEffect(glassElementsVisible ? 1 : 0.8)
        .opacity(glassElementsVisible ? 1 : 0)
        .animation(.bouncy(duration: 0.6).delay(Double.random(in: 0.1...0.3)), value: glassElementsVisible)
    }

    // MARK: - Removed inline webclip; now uses WebClipThumbnail component.
    
    // MARK: - Todo items are now integrated into the text content
    // Users can add checkboxes by typing ☐ or ☑ symbols directly in the text
    
    // MARK: - Bottom Glass Controls - Floating Interactive Layer
    
    private var bottomGlassControls: some View {
        GlassEffectContainer(spacing: 12) {
            HStack {
                // Text size control with droplet behavior
                Button(action: {}) {
                    Text("Aa")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                        .glassEffect(.regular.interactive())
                        .glassEffectID("textSizeControl", in: glassNamespace)
                        .scaleEffect(bottomControlsExpanded ? 1 : 0.7)
                        .opacity(bottomControlsExpanded ? 1 : 0)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                // Voice controls cluster - glass elements that merge like droplets
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "mic")
                            .font(.system(size: 20))
                            .foregroundColor(Color("PrimaryTextColor"))
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                            .glassEffect(.regular.interactive())
                            .glassEffectID("micControl", in: glassNamespace)
                            .scaleEffect(bottomControlsExpanded ? 1 : 0.7)
                            .opacity(bottomControlsExpanded ? 1 : 0)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {}) {
                        Image(systemName: "apple.intelligence")
                            .font(.system(size: 20))
                            .foregroundColor(Color("AccentColor"))
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial, in: Circle())
                            .glassEffect(.regular.interactive())
                            .glassEffectID("aiControl", in: glassNamespace)
                            .scaleEffect(bottomControlsExpanded ? 1 : 0.7)
                            .opacity(bottomControlsExpanded ? 1 : 0)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .animation(.bouncy(duration: 0.8), value: bottomControlsExpanded)
        }
    }
    
    // MARK: - Actions with Liquid Glass Coordination
    
    private func closeNote() {
        // Dematerialize glass elements in reverse order for droplet-like behavior
        withAnimation(.bouncy(duration: 0.5)) {
            bottomControlsExpanded = false
        }
        
        withAnimation(.bouncy(duration: 0.5).delay(0.1)) {
            glassElementsVisible = false
        }
        
        withAnimation(.bouncy(duration: 0.6).delay(0.2)) {
            isViewMaterialized = false
        }
        
        // Close the view after animations complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isPresented = false
        }
    }
    
    private func startAddingTag() {
        // Morphing animation - button transforms into input field like liquid droplet
        withAnimation(.bouncy(duration: 0.6)) {
            isAddingTag = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isAddingTagFocused = true
        }
    }
    
    private func addNewTag() {
        if !newTagText.isEmpty && !editedTags.contains(newTagText) {
            // Add tag with glass materialization effect
            withAnimation(.bouncy(duration: 0.6)) {
                editedTags.append(newTagText)
                newTagText = ""
                isAddingTag = false
            }
        }
    }
    
    private func removeTag(_ tag: String) {
        // Remove tag with glass dematerialization effect
        withAnimation(.bouncy(duration: 0.5)) {
            editedTags.removeAll { $0 == tag }
        }
    }
    
    private func cancelAddingTag() {
        // Cancel tag addition with glass morphing animation
        isAddingTagFocused = false
        withAnimation(.bouncy(duration: 0.6)) {
            isAddingTag = false
            newTagText = ""
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}

// MARK: - TodoItem Model

struct TodoItem: Identifiable {
    let id = UUID()
    var text: String
    var isCompleted: Bool
}

// MARK: - Rich Text Editor with Inline Checkboxes

struct RichTextEditor: View {
    @Binding var text: String
    @State private var parsedContent: [TextElement] = []
    @FocusState private var isTextFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(parsedContent.indices, id: \.self) { index in
                switch parsedContent[index] {
                case .text(let content):
                    TextEditor(text: Binding(
                        get: { content },
                        set: { newValue in
                            updateTextElement(at: index, with: newValue)
                        }
                    ))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.never)
                    .scrollDisabled(true)
                    .frame(minHeight: max(80, CGFloat(content.count) / 50 * 24 + 40))
                    .background(Color.clear)
                    .fixedSize(horizontal: false, vertical: true)
                    .focused($isTextFocused)
                    
                case .checkbox(let isChecked, let content):
                    HStack(alignment: .top, spacing: 8) {
                        Button(action: {
                            toggleCheckbox(at: index)
                        }) {
                            Image(checkboxImageName(isChecked: isChecked))
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                        
                        TextEditor(text: Binding(
                            get: { content },
                            set: { newValue in
                                updateCheckboxText(at: index, with: newValue)
                            }
                        ))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.never)
                        .scrollDisabled(true)
                        .frame(minHeight: 30)
                        .background(Color.clear)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            
            // Empty text editor for adding new content
            TextEditor(text: Binding(
                get: { "" },
                set: { newValue in
                    if !newValue.isEmpty {
                        appendNewContent(newValue)
                    }
                }
            ))
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(Color("PrimaryTextColor"))
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .frame(minHeight: 60)
            .background(Color.clear)
            .fixedSize(horizontal: false, vertical: true)
            .focused($isTextFocused)
        }
        .onAppear {
            parseText()
        }
        .onChange(of: text) { _, _ in
            parseText()
        }
    }
    
    private func parseText() {
        let lines = text.components(separatedBy: "\n")
        var elements: [TextElement] = []
        var currentTextLines: [String] = []
        
        for line in lines {
            if line.hasPrefix("[ ] ") {
                // Add accumulated text as text element
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                // Add checkbox element
                let content = String(line.dropFirst(4))
                elements.append(.checkbox(false, content))
            } else if line.hasPrefix("[x] ") {
                // Add accumulated text as text element
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                // Add checked checkbox element
                let content = String(line.dropFirst(4))
                elements.append(.checkbox(true, content))
            } else {
                currentTextLines.append(line)
            }
        }
        
        // Add remaining text
        if !currentTextLines.isEmpty {
            elements.append(.text(currentTextLines.joined(separator: "\n")))
        }
        
        parsedContent = elements
    }
    
    private func updateTextElement(at index: Int, with newValue: String) {
        if index < parsedContent.count {
            parsedContent[index] = .text(newValue)
            rebuildText()
        }
    }
    
    private func updateCheckboxText(at index: Int, with newValue: String) {
        if case .checkbox(let isChecked, _) = parsedContent[index] {
            parsedContent[index] = .checkbox(isChecked, newValue)
            rebuildText()
        }
    }
    
    private func toggleCheckbox(at index: Int) {
        if case .checkbox(let isChecked, let content) = parsedContent[index] {
            parsedContent[index] = .checkbox(!isChecked, content)
            rebuildText()
        }
    }
    
    private func appendNewContent(_ newValue: String) {
        parsedContent.append(.text(newValue))
        rebuildText()
    }
    
    private func rebuildText() {
        var lines: [String] = []
        
        for element in parsedContent {
            switch element {
            case .text(let content):
                if !content.isEmpty {
                    lines.append(content)
                }
            case .checkbox(let isChecked, let content):
                let symbol = isChecked ? "[x]" : "[ ]"
                lines.append("\(symbol) \(content)")
            }
        }
        
        text = lines.joined(separator: "\n")
    }
    
    private func checkboxImageName(isChecked: Bool) -> String {
        if isChecked {
            return "checkmark_checked"
        } else {
            // Use appropriate unchecked asset based on color scheme
            return colorScheme == .dark ? "checkmark_unchecked_DM" : "checkmark_unchecked_LM"
        }
    }
}

enum TextElement {
    case text(String)
    case checkbox(Bool, String)
}

// Note: Glass effect extension is already defined in FloatingSearch.swift

// MARK: - WebClip Thumbnail (Figma-spec card)

struct WebClipThumbnail: View {
    var imageNameLight: String
    var imageNameDark: String
    var title: String
    var excerpt: String
    var domain: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Image(colorScheme == .dark ? imageNameDark : imageNameLight)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 182, height: 116)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.04))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text(excerpt)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(Color("SecondaryTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "link")
                        .font(.system(size: 10))
                        .foregroundColor(Color("AccentColor"))
                    Text(domain)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            .padding(8)
            .frame(width: 182)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(colorScheme == .dark ? 0.06 : 1.0))
            )
        }
        .background(Color.black.opacity(colorScheme == .dark ? 0.12 : 0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.02), lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.02), radius: 19, x: 0, y: 9)
        .shadow(color: Color.black.opacity(0.02), radius: 35, x: 0, y: 35)
        .shadow(color: Color.black.opacity(0.01), radius: 47, x: 0, y: 78)
    }
}

// MARK: - GlassEffectContainer (local wrapper)

struct GlassEffectContainer<Content: View>: View {
    var spacing: CGFloat = 12
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack(spacing: spacing) {
            content()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .applyGlassEffect()
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 18)
    }
}

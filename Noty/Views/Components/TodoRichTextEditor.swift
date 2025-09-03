//
//  TodoRichTextEditor.swift
//  Noty
//
//  Created by AI on 17.08.25.
//
//  Rich text-like editor that parses [ ] / [x] todo lines
//  and renders interactive checkboxes with editable text.

import SwiftUI

enum TextElement {
    case text(String)
    case checkbox(Bool, String)
    case webclip(title: String, excerpt: String, domain: String, url: String? = nil)
}

struct TodoRichTextEditor: View {
    @Binding var text: String
    @State private var parsedContent: [TextElement] = []
    @FocusState private var isTextFocused: Bool
    @FocusState private var focusedRowIndex: Int?
    @State private var hoveredRowIndex: Int?
    @Environment(\.colorScheme) private var colorScheme
    
    // Toolbar integration
    var onToolbarAction: ((EditTool) -> Void)?
    
    init(text: Binding<String>, onToolbarAction: ((EditTool) -> Void)? = nil) {
        self._text = text
        self.onToolbarAction = onToolbarAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(parsedContent.indices, id: \.self) { index in
                switch parsedContent[index] {
                case .text(let content):
                    if #available(iOS 26.0, macOS 26.0, *) {
                        // Use rich text capabilities for iOS 26+
                        TextEditor(text: Binding(
                            get: { content },
                            set: { newValue in updateTextElement(at: index, with: newValue) }
                        ))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.never)
                        .scrollDisabled(true)
                        .frame(minHeight: max(80, CGFloat(max(1, content.count)) / 50 * 24 + 40))
                        .background(Color.clear)
                        .fixedSize(horizontal: false, vertical: true)
                        .focused($isTextFocused)
                    } else {
                        // Fallback for older OS versions
                        TextEditor(text: Binding(
                            get: { content },
                            set: { newValue in updateTextElement(at: index, with: newValue) }
                        ))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.never)
                        .scrollDisabled(true)
                        .frame(minHeight: max(80, CGFloat(max(1, content.count)) / 50 * 24 + 40))
                        .background(Color.clear)
                        .fixedSize(horizontal: false, vertical: true)
                        .focused($isTextFocused)
                    }

                case .checkbox(let isChecked, let content):
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: { toggleCheckbox(at: index) }) {
                            Image(checkboxImageName(isChecked: isChecked))
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(CheckboxButtonStyle())
                        .focusEffectDisabled()

                        ZStack(alignment: .leading) {
                            TextField("", text: Binding(
                                get: { content },
                                set: { newValue in updateCheckboxText(at: index, with: newValue) }
                            ))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("PrimaryTextColor"))
                            .textFieldStyle(.plain)
                            .opacity(isChecked ? 0.7 : 1.0)
                            .focused($focusedRowIndex, equals: index)
                            .onSubmit {
                                // Add new checkbox on Enter
                                parsedContent.insert(.checkbox(false, ""), at: index + 1)
                                rebuildText()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedRowIndex = index + 1
                                }
                            }
                            .onKeyPress(.delete) {
                                if content.isEmpty {
                                    deleteRow(at: index)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        if index > 0 {
                                            focusedRowIndex = index - 1
                                        } else {
                                            isTextFocused = true
                                        }
                                    }
                                    return .handled
                                }
                                return .ignored
                            }
                            .onKeyPress(KeyEquivalent.delete, phases: .down) { keyPress in
                                if keyPress.modifiers.contains(.command) {
                                    deleteRow(at: index)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        if index > 0 {
                                            focusedRowIndex = index - 1
                                        } else {
                                            isTextFocused = true
                                        }
                                    }
                                    return .handled
                                }
                                return .ignored
                            }
                            
                            // Strikethrough for checked items
                            if isChecked && !content.isEmpty {
                                Text(content)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.clear)
                                    .strikethrough(true, pattern: .solid, color: Color("PrimaryTextColor").opacity(0.6))
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .onHover { hovering in
                        hoveredRowIndex = hovering ? index : (hoveredRowIndex == index ? nil : hoveredRowIndex)
                    }
                    
                case .webclip(let title, let excerpt, let domain, let url):
                    WebClipThumbnail(
                        imageNameLight: "note-card-thumbnail",
                        imageNameDark: "note-card-thumbnail-DM",
                        title: title,
                        excerpt: excerpt,
                        domain: domain,
                        url: url,
                        onDelete: { deleteRow(at: index) }
                    )
                    .focusable()
                    .focused($focusedRowIndex, equals: index)
                    .focusEffectDisabled() // Disable the default focus ring
                    .onHover { hovering in
                        hoveredRowIndex = hovering ? index : (hoveredRowIndex == index ? nil : hoveredRowIndex)
                    }
                    .onKeyPress(.delete) {
                        deleteRow(at: index)
                        return .handled
                    }
                    .onKeyPress(.deleteForward) {
                        deleteRow(at: index)
                        return .handled
                    }
                    .padding(.vertical, 4)
                }
            }

            // Empty editor for quickly appending new content
            TextEditor(text: Binding(
                get: { "" },
                set: { newValue in 
                    if !newValue.isEmpty { 
                        // Check if user is trying to type a checkbox
                        if newValue.hasPrefix("[ ]") || newValue.hasPrefix("[x]") {
                            let isChecked = newValue.hasPrefix("[x]")
                            let content = String(newValue.dropFirst(3).trimmingCharacters(in: .whitespaces))
                            parsedContent.append(.checkbox(isChecked, content))
                            rebuildText()
                        } else {
                            appendNewContent(newValue)
                        }
                    }
                }
            ))
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color("PrimaryTextColor"))
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .frame(minHeight: 60)
            .background(Color.clear)
            .fixedSize(horizontal: false, vertical: true)
            .focused($isTextFocused)
        }
        .onAppear { parseText() }
        .onChange(of: text) { _, _ in parseText() }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TodoToolbarAction"))) { _ in
            // Handle toolbar action if needed
            insertTodo()
        }
    }

    // MARK: - Parsing / Rebuild
    private func parseText() {
        let lines = text.components(separatedBy: "\n")
        var elements: [TextElement] = []
        var currentTextLines: [String] = []

        for line in lines {
            // Support both webclip formats:
            // 1. Inline webclip: [[webclip|Title|Excerpt|domain.com]]
            // 2. Link webclip: [webclip](url)
            if line.hasPrefix("[[webclip") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                let content = line.trimmingCharacters(in: CharacterSet(charactersIn: "[] "))
                // Expected format: webclip|title|excerpt|domain
                let parts = content.components(separatedBy: "|")
                if parts.count >= 4 {
                    let title = parts[1]
                    let excerpt = parts[2]
                    let domain = parts[3]
                    let url = parts.count > 4 ? parts[4] : nil
                    elements.append(.webclip(title: title, excerpt: excerpt, domain: domain, url: url))
                }
            } else if line.hasPrefix("[webclip](") && line.hasSuffix(")") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                // Extract URL from [webclip](url)
                let urlStart = line.firstIndex(of: "(")!
                let urlEnd = line.lastIndex(of: ")")!
                let url = String(line[line.index(after: urlStart)..<urlEnd])
                
                elements.append(.webclip(
                    title: "Web Link",
                    excerpt: "Click to open",
                    domain: URL(string: url)?.host ?? url,
                    url: url
                ))
            } else if line.hasPrefix("[ ]") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                let content = String(line.dropFirst(3).trimmingCharacters(in: .whitespaces))
                elements.append(.checkbox(false, content))
            } else if line.hasPrefix("[x]") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                let content = String(line.dropFirst(3).trimmingCharacters(in: .whitespaces))
                elements.append(.checkbox(true, content))
            } else {
                currentTextLines.append(line)
            }
        }

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
    
    private func deleteRow(at index: Int) {
        guard index >= 0 && index < parsedContent.count else { return }
        parsedContent.remove(at: index)
        rebuildText()
    }

    private func rebuildText() {
        var lines: [String] = []
        for element in parsedContent {
            switch element {
            case .text(let content):
                if !content.isEmpty { lines.append(content) }
            case .checkbox(let isChecked, let content):
                let symbol = isChecked ? "[x]" : "[ ]"
                lines.append("\(symbol) \(content)")
            case .webclip(let title, let excerpt, let domain, let url):
                // Prefer the simpler [webclip](url) format for links inserted via toolbar
                if title == "Web Link" && excerpt.contains("Click to open"), let url = url {
                    lines.append("[webclip](\(url))")
                } else {
                    // Use full format for manually created webclips
                    if let url = url {
                        lines.append("[[webclip|\(title)|\(excerpt)|\(domain)|\(url)]]")
                    } else {
                        lines.append("[[webclip|\(title)|\(excerpt)|\(domain)]]")
                    }
                }
            }
        }
        text = lines.joined(separator: "\n")
    }

    private func checkboxImageName(isChecked: Bool) -> String {
        if isChecked {
            return "checkmark_checked"
        } else {
            return colorScheme == .dark ? "checkmark_unchecked_DM" : "checkmark_unchecked_LM"
        }
    }
    
    // MARK: - Toolbar Integration
    
    func handleToolbarAction(_ tool: EditTool) {
        switch tool {
        case .todo:
            insertTodo()
        default:
            break
        }
    }
    
    private func insertTodo() {
        let insertIndex: Int
        
        // Determine where to insert based on current focus
        if let focusedIndex = focusedRowIndex {
            // Insert after the currently focused element
            insertIndex = focusedIndex + 1
        } else if isTextFocused {
            // If main text area is focused, insert at the end
            insertIndex = parsedContent.count
        } else {
            // Fallback: insert at the end
            insertIndex = parsedContent.count
        }
        
        // Insert the new checkbox at the determined position
        parsedContent.insert(.checkbox(false, ""), at: insertIndex)
        rebuildText()
        
        // Focus the newly created todo after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            focusedRowIndex = insertIndex
        }
    }
}

// MARK: - Custom Button Style
struct CheckboxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.clear)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
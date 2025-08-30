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
    case webclip(title: String, excerpt: String, domain: String)
}

struct TodoRichTextEditor: View {
    @Binding var text: String
    @State private var parsedContent: [TextElement] = []
    @FocusState private var isTextFocused: Bool
    @FocusState private var focusedRowIndex: Int?
    @State private var hoveredRowIndex: Int?
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(parsedContent.indices, id: \.self) { index in
                switch parsedContent[index] {
                case .text(let content):
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

                case .checkbox(let isChecked, let content):
                    HStack(alignment: .top, spacing: 10) {
                        Button(action: { toggleCheckbox(at: index) }) {
                            Image(checkboxImageName(isChecked: isChecked))
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 4)

                        TextEditor(text: Binding(
                            get: { content },
                            set: { newValue in updateCheckboxText(at: index, with: newValue) }
                        ))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .scrollContentBackground(.hidden)
                        .scrollIndicators(.never)
                        .scrollDisabled(true)
                        .frame(minHeight: 30)
                        .background(Color.clear)
                        .fixedSize(horizontal: false, vertical: true)
                        .opacity(isChecked ? 0.7 : 1.0)
                        .focused($focusedRowIndex, equals: index)
                    }
                    .overlay(alignment: .center) {
                        if isChecked {
                            Rectangle()
                                .fill(Color("PrimaryTextColor").opacity(0.35))
                                .frame(height: 1)
                                .padding(.leading, 26) // leave space for checkbox icon
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.white.opacity((hoveredRowIndex == index || focusedRowIndex == index) ? 0.06 : 0))
                    )
                    .onHover { hovering in
                        hoveredRowIndex = hovering ? index : (hoveredRowIndex == index ? nil : hoveredRowIndex)
                    }
                case .webclip(let title, let excerpt, let domain):
                    WebClipThumbnail(
                        imageNameLight: "note-card-thumbnail",
                        imageNameDark: "note-card-thumbnail-DM",
                        title: title,
                        excerpt: excerpt,
                        domain: domain
                    )
                }
            }

            // Empty editor for quickly appending new content
            TextEditor(text: Binding(
                get: { "" },
                set: { newValue in if !newValue.isEmpty { appendNewContent(newValue) } }
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
    }

    // MARK: - Parsing / Rebuild
    private func parseText() {
        let lines = text.components(separatedBy: "\n")
        var elements: [TextElement] = []
        var currentTextLines: [String] = []

        for line in lines {
            // Inline webclip: [[webclip|Title|Excerpt|domain.com]]
            if line.hasPrefix("[[webclip") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                let content = line.trimmingCharacters(in: CharacterSet(charactersIn: "[] "))
                // Expected format: webclip|title|excerpt|domain
                let parts = content.components(separatedBy: "|")
                if parts.count >= 1 && parts[0].lowercased().contains("webclip") {
                    let title = parts.count > 1 ? parts[1] : "Exciting Recent Activities to Explore"
                    let excerpt = parts.count > 2 ? parts[2] : "Raindrops gently tapped the attic window while a single beam of light cut the dust."
                    let domain = parts.count > 3 ? parts[3] : "funadventures.com"
                    elements.append(.webclip(title: title, excerpt: excerpt, domain: domain))
                    continue
                }
            }
            if line.hasPrefix("[ ] ") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                let content = String(line.dropFirst(4))
                elements.append(.checkbox(false, content))
            } else if line.hasPrefix("[x] ") {
                if !currentTextLines.isEmpty {
                    elements.append(.text(currentTextLines.joined(separator: "\n")))
                    currentTextLines = []
                }
                let content = String(line.dropFirst(4))
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

    private func rebuildText() {
        var lines: [String] = []
        for element in parsedContent {
            switch element {
            case .text(let content):
                if !content.isEmpty { lines.append(content) }
            case .checkbox(let isChecked, let content):
                let symbol = isChecked ? "[x]" : "[ ]"
                lines.append("\(symbol) \(content)")
            case .webclip(let title, let excerpt, let domain):
                lines.append("[[webclip|\(title)|\(excerpt)|\(domain)]]")
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
}

//
//  EditToolbar.swift
//  Noty
//
//  Rich text editing toolbar with expandable formatting options
//

import SwiftUI

struct EditToolbar: View {
    @Binding var isExpanded: Bool
    @State private var selectedTool: EditTool? = nil
    @State private var hoveredTool: EditTool? = nil
    @Namespace private var toolbarNamespace
    
    // Animation states
    @State private var toolsVisible = false
    @State private var toolbarWidth: CGFloat = 44
    
    // Link input states
    @State private var showLinkInput = false
    @State private var linkURL = ""
    @FocusState private var isLinkInputFocused: Bool
    
    // Tool actions
    var onToolAction: ((EditTool) -> Void)?
    var onLinkInsert: ((String) -> Void)?
    
    var body: some View {
        HStack(spacing: isExpanded ? 16 : 0) {
            // Main toggle button (always visible)
            Button(action: toggleExpansion) {
                Image(systemName: "textformat")
                    .font(.system(size: 16))
                    .foregroundColor(Color("PrimaryTextColor"))
            }
            .buttonStyle(.plain)
            .frame(width: 20, height: 20)
            .matchedGeometryEffect(id: "title-case", in: toolbarNamespace)
            
            if isExpanded {
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // Heading styles
                headingTools
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
                
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // Text styles
                textStyleTools
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
                
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // List tool
                listTool
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
                
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // Indentation tools
                indentationTools
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
                
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // Alignment tools
                alignmentTools
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
                
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // Selection tools
                selectionTools
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
                
                // Divider
                Rectangle()
                    .fill(Color("TertiaryTextColor").opacity(0.2))
                    .frame(width: 1, height: 20)
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(y: toolsVisible ? 1 : 0.5)
                
                // Link tool
                linkTool
                    .opacity(toolsVisible ? 1 : 0)
                    .scaleEffect(toolsVisible ? 1 : 0.8)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(width: isExpanded ? nil : 44, height: 44)
        .liquidGlass(in: Capsule())
        .animation(.bouncy(duration: 0.6), value: isExpanded)
        .animation(.bouncy(duration: 0.4).delay(isExpanded ? 0.1 : 0), value: toolsVisible)
        .onChange(of: isExpanded) { _, newValue in
            if newValue {
                withAnimation(.bouncy(duration: 0.4).delay(0.15)) {
                    toolsVisible = true
                }
            } else {
                toolsVisible = false
            }
        }
    }
    
    // MARK: - Tool Groups
    
    private var headingTools: some View {
        HStack(spacing: 12) {
            ToolButton(
                tool: .h1,
                systemName: "1.circle",
                isSelected: selectedTool == .h1,
                isHovered: hoveredTool == .h1,
                action: { handleToolAction(.h1) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .h1 : nil
            }
            
            ToolButton(
                tool: .h2,
                systemName: "2.circle",
                isSelected: selectedTool == .h2,
                isHovered: hoveredTool == .h2,
                action: { handleToolAction(.h2) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .h2 : nil
            }
            
            ToolButton(
                tool: .h3,
                systemName: "3.circle",
                isSelected: selectedTool == .h3,
                isHovered: hoveredTool == .h3,
                action: { handleToolAction(.h3) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .h3 : nil
            }
        }
    }
    
    private var textStyleTools: some View {
        HStack(spacing: 12) {
            ToolButton(
                tool: .bold,
                systemName: "bold",
                isSelected: selectedTool == .bold,
                isHovered: hoveredTool == .bold,
                action: { handleToolAction(.bold) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .bold : nil
            }
            
            ToolButton(
                tool: .italic,
                systemName: "italic",
                isSelected: selectedTool == .italic,
                isHovered: hoveredTool == .italic,
                action: { handleToolAction(.italic) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .italic : nil
            }
            
            ToolButton(
                tool: .underline,
                systemName: "underline",
                isSelected: selectedTool == .underline,
                isHovered: hoveredTool == .underline,
                action: { handleToolAction(.underline) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .underline : nil
            }
            
            ToolButton(
                tool: .strikethrough,
                systemName: "strikethrough",
                isSelected: selectedTool == .strikethrough,
                isHovered: hoveredTool == .strikethrough,
                action: { handleToolAction(.strikethrough) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .strikethrough : nil
            }
        }
    }
    
    private var listTool: some View {
        HStack(spacing: 12) {
            ToolButton(
                tool: .bulletList,
                systemName: "list.bullet",
                isSelected: selectedTool == .bulletList,
                isHovered: hoveredTool == .bulletList,
                action: { handleToolAction(.bulletList) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .bulletList : nil
            }
            
            ToolButton(
                tool: .todo,
                systemName: "checkmark.square",
                isSelected: selectedTool == .todo,
                isHovered: hoveredTool == .todo,
                action: { handleToolAction(.todo) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .todo : nil
            }
        }
    }
    
    private var indentationTools: some View {
        HStack(spacing: 12) {
            ToolButton(
                tool: .indentLeft,
                systemName: "decrease.indent",
                isSelected: selectedTool == .indentLeft,
                isHovered: hoveredTool == .indentLeft,
                action: { handleToolAction(.indentLeft) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .indentLeft : nil
            }
            
            ToolButton(
                tool: .indentRight,
                systemName: "increase.indent",
                isSelected: selectedTool == .indentRight,
                isHovered: hoveredTool == .indentRight,
                action: { handleToolAction(.indentRight) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .indentRight : nil
            }
        }
    }
    
    private var alignmentTools: some View {
        HStack(spacing: 12) {
            ToolButton(
                tool: .alignLeft,
                systemName: "text.alignleft",
                isSelected: selectedTool == .alignLeft,
                isHovered: hoveredTool == .alignLeft,
                action: { handleToolAction(.alignLeft) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .alignLeft : nil
            }
            
            ToolButton(
                tool: .alignCenter,
                systemName: "text.aligncenter",
                isSelected: selectedTool == .alignCenter,
                isHovered: hoveredTool == .alignCenter,
                action: { handleToolAction(.alignCenter) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .alignCenter : nil
            }
            
            ToolButton(
                tool: .alignRight,
                systemName: "text.alignright",
                isSelected: selectedTool == .alignRight,
                isHovered: hoveredTool == .alignRight,
                action: { handleToolAction(.alignRight) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .alignRight : nil
            }
            
            ToolButton(
                tool: .alignJustify,
                systemName: "text.justify",
                isSelected: selectedTool == .alignJustify,
                isHovered: hoveredTool == .alignJustify,
                action: { handleToolAction(.alignJustify) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .alignJustify : nil
            }
            
            ToolButton(
                tool: .lineBreak,
                systemName: "return",
                isSelected: selectedTool == .lineBreak,
                isHovered: hoveredTool == .lineBreak,
                action: { handleToolAction(.lineBreak) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .lineBreak : nil
            }
        }
    }
    
    private var selectionTools: some View {
        HStack(spacing: 12) {
            ToolButton(
                tool: .textSelect,
                systemName: "selection.pin.in.out",
                isSelected: selectedTool == .textSelect,
                isHovered: hoveredTool == .textSelect,
                action: { handleToolAction(.textSelect) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .textSelect : nil
            }
            
            ToolButton(
                tool: .divider,
                systemName: "minus",
                isSelected: selectedTool == .divider,
                isHovered: hoveredTool == .divider,
                action: { handleToolAction(.divider) }
            )
            .onHover { hovering in
                hoveredTool = hovering ? .divider : nil
            }
        }
    }
    
    private var linkTool: some View {
        ToolButton(
            tool: .link,
            systemName: "link",
            isSelected: selectedTool == .link || showLinkInput,
            isHovered: hoveredTool == .link,
            action: { 
                withAnimation(.bouncy(duration: 0.4)) {
                    showLinkInput.toggle()
                    if showLinkInput {
                        isLinkInputFocused = true
                    } else {
                        linkURL = ""
                    }
                }
            }
        )
        .onHover { hovering in
            hoveredTool = hovering ? .link : nil
        }
        .overlay(alignment: .top) {
            if showLinkInput {
                linkInputField
                    .offset(y: -60)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.9).combined(with: .opacity)
                    ))
            }
        }
    }
    
    // MARK: - Link Input Field
    
    private var linkInputField: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "link")
                    .font(.system(size: 12))
                    .foregroundColor(Color("SecondaryTextColor"))
                
                TextField("Enter URL", text: $linkURL)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .focused($isLinkInputFocused)
                    .onSubmit {
                        insertLink()
                    }
                
                Button(action: insertLink) {
                    Image(systemName: "return")
                        .font(.system(size: 10))
                        .foregroundColor(Color("AccentColor"))
                }
                .buttonStyle(.plain)
                .opacity(linkURL.isEmpty ? 0.5 : 1.0)
                .disabled(linkURL.isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .liquidGlass(in: Capsule())
            .frame(width: 200)
            
            // Small arrow pointing to the link button
            Triangle()
                .fill(Color("SurfaceTranslucentColor"))
                .frame(width: 8, height: 4)
                .offset(y: -2)
        }
        .zIndex(100)
    }
    
    // MARK: - Actions
    
    private func toggleExpansion() {
        withAnimation(.bouncy(duration: 0.6)) {
            isExpanded.toggle()
        }
    }
    
    private func handleToolAction(_ tool: EditTool) {
        selectedTool = tool
        onToolAction?(tool)
        
        // Auto-deselect after a moment for toggle-style tools
        if tool.isToggleable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                selectedTool = nil
            }
        }
    }
    
    private func insertLink() {
        guard !linkURL.isEmpty else { return }
        
        // Add https:// if no protocol is specified
        var finalURL = linkURL
        if !linkURL.hasPrefix("http://") && !linkURL.hasPrefix("https://") {
            finalURL = "https://" + linkURL
        }
        
        onLinkInsert?(finalURL)
        
        // Hide the input field
        withAnimation(.bouncy(duration: 0.4)) {
            showLinkInput = false
            linkURL = ""
        }
    }
}

// MARK: - Triangle Shape for Pointer

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

// MARK: - Tool Button Component

private struct ToolButton: View {
    let tool: EditTool
    let systemName: String
    let isSelected: Bool
    let isHovered: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(
                    isSelected ? Color("AccentColor") : 
                    isHovered ? Color("PrimaryTextColor") : 
                    Color("SecondaryTextColor")
                )
                .scaleEffect(isSelected ? 1.1 : (isHovered ? 1.05 : 1.0))
                .animation(.bouncy(duration: 0.2), value: isSelected)
                .animation(.bouncy(duration: 0.2), value: isHovered)
        }
        .buttonStyle(.plain)
        .frame(width: 20, height: 20)
    }
}

// MARK: - Edit Tool Enum

enum EditTool: String, CaseIterable {
    case titleCase
    case h1, h2, h3
    case bold, italic, underline, strikethrough
    case bulletList, todo
    case indentLeft, indentRight
    case alignLeft, alignCenter, alignRight, alignJustify
    case lineBreak
    case textSelect, divider
    case link
    
    var isToggleable: Bool {
        switch self {
        case .bold, .italic, .underline, .strikethrough, .bulletList, .todo:
            return true
        default:
            return false
        }
    }
    
    var name: String {
        switch self {
        case .titleCase: return "Title Case"
        case .h1: return "Heading 1"
        case .h2: return "Heading 2"
        case .h3: return "Heading 3"
        case .bold: return "Bold"
        case .italic: return "Italic"
        case .underline: return "Underline"
        case .strikethrough: return "Strikethrough"
        case .bulletList: return "Bullet List"
        case .todo: return "Todo Checkbox"
        case .indentLeft: return "Decrease Indent"
        case .indentRight: return "Increase Indent"
        case .alignLeft: return "Align Left"
        case .alignCenter: return "Align Center"
        case .alignRight: return "Align Right"
        case .alignJustify: return "Justify"
        case .lineBreak: return "Line Break"
        case .textSelect: return "Select Text"
        case .divider: return "Insert Divider"
        case .link: return "Insert Link"
        }
    }
    
    var keyboardShortcut: KeyEquivalent? {
        switch self {
        case .bold: return "b"
        case .italic: return "i"
        case .underline: return "u"
        default: return nil
        }
    }
}

// MARK: - Preview

struct EditToolbar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            // Collapsed state
            EditToolbar(isExpanded: .constant(false))
            
            // Expanded state
            EditToolbar(isExpanded: .constant(true))
        }
        .padding(60)
        .background(Color("BackgroundColor"))
    }
}
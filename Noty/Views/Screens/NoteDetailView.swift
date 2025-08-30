//
//  NoteDetailView.swift
//  Noty
//
//  Created by AI on 15.08.25.
//
//  Simpler, Figma-aligned note detail view

import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @Binding var isPresented: Bool
    var onSave: (Note) -> Void
    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var editedTags: [String]

    @State private var isAddingTag = false
    @State private var newTagText = ""
    @FocusState private var isAddingTagFocused: Bool

    // Liquid glass animation states
    @State private var isViewMaterialized = false
    @State private var glassElementsVisible = false
    @State private var bottomControlsExpanded = false
    @State private var hoveredTag: String?
    @State private var pressedTag: String?
    @State private var selectedTags: Set<String> = []

    init(note: Note, isPresented: Binding<Bool>, onSave: @escaping (Note) -> Void) {
        self.note = note
        self._isPresented = isPresented
        self.onSave = onSave
        self._editedTitle = State(initialValue: note.title)
        self._editedContent = State(initialValue: note.content)
        self._editedTags = State(initialValue: note.tags)
    }

    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        headerMeta
                        titleField
                        tagsRow
                        contentEditor
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .scrollIndicators(.never)
            }

            // Floating bottom controls
            VStack {
                Spacer()
                bottomGlassControls
            }
        }
        .opacity(isViewMaterialized ? 1 : 0)
        .scaleEffect(isViewMaterialized ? 1 : 0.98)
        .animation(.bouncy(duration: 0.6), value: isViewMaterialized)
        .onAppear {
            withAnimation(.bouncy(duration: 0.6).delay(0.05)) { isViewMaterialized = true }
            withAnimation(.bouncy(duration: 0.6).delay(0.2)) { glassElementsVisible = true }
            withAnimation(.bouncy(duration: 0.6).delay(0.35)) { bottomControlsExpanded = true }
        }
        .onDisappear {
            withAnimation(.bouncy(duration: 0.4)) {
                isViewMaterialized = false
                glassElementsVisible = false
                bottomControlsExpanded = false
            }
        }
        .transition(.opacity)
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            Button(action: closeNote) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .frame(width: 32, height: 32)
                    .adaptiveGlass(in: Circle())
                    .applyGlassEffect()
                    .scaleEffect(glassElementsVisible ? 1 : 0.9)
                    .opacity(glassElementsVisible ? 1 : 0)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }

    // MARK: - Meta (Date + Last Edited)
    private var headerMeta: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.system(size: 12))
                .foregroundColor(Color("TertiaryTextColor"))

            Text(dateFormatter.string(from: note.date))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("TertiaryTextColor"))

            Text("·")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color("TertiaryTextColor"))

            Text(editedDisplayString)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("TertiaryTextColor"))

            Spacer()
        }
    }

    // MARK: - Title
    private var titleField: some View {
        TextField("Note Title", text: $editedTitle)
            .font(.system(size: 32, weight: .medium))
            .foregroundColor(Color("PrimaryTextColor"))
            .textFieldStyle(.plain)
            .padding(.top, 4)
    }

    // MARK: - Tags
    private var tagsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if isAddingTag {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                            .font(.system(size: 12))
                            .foregroundColor(Color("AccentColor"))
                        TextField("New tag", text: $newTagText)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("PrimaryTextColor"))
                            .textFieldStyle(.plain)
                            .lineLimit(1)
                            .focused($isAddingTagFocused)
                            .onSubmit(addTag)
                            .onExitCommand { cancelTagInput() }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color("SurfaceTranslucentColor"))
                    )
                    // Removed dashed border per design feedback
                    .onAppear { isAddingTagFocused = true }
                } else {
                    Button(action: { isAddingTag = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                            Text("New tag")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(Color("TertiaryTextColor"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule().fill(Color("SurfaceTranslucentColor"))
                        )
                    }
                    .buttonStyle(.plain)
                }

                ForEach(editedTags, id: \.self) { tag in
                    TagPill(
                        text: tag,
                        isSelected: selectedTags.contains(tag),
                        isHovered: hoveredTag == tag,
                        isPressed: pressedTag == tag,
                        visible: glassElementsVisible,
                        onRemove: { removeTag(tag) }
                    )
                    .onHover { hovering in
                        hoveredTag = hovering ? tag : (hoveredTag == tag ? nil : hoveredTag)
                    }
                    .onTapGesture {
                        if selectedTags.contains(tag) { selectedTags.remove(tag) } else { selectedTags.insert(tag) }
                    }
                    .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
                        pressedTag = pressing ? tag : (pressedTag == tag ? nil : pressedTag)
                    }, perform: {})
                }
            }
        }
        .background(Color.clear)
        .scrollClipDisabled(true)
        .onExitCommand {
            if isAddingTag { cancelTagInput() }
        }
    }

    // MARK: - Content
    private var contentEditor: some View {
        TodoRichTextEditor(text: $editedContent)
            .padding(.top, 4)
    }

    // MARK: - Bottom Controls
    private var bottomGlassControls: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Text("Aa")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
                    .applyGlassEffect()
                    .scaleEffect(bottomControlsExpanded ? 1 : 0.7)
                    .opacity(bottomControlsExpanded ? 1 : 0)
            }
            .buttonStyle(.plain)

            Spacer()

            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "mic")
                        .font(.system(size: 20))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial, in: Circle())
                        .applyGlassEffect()
                        .scaleEffect(bottomControlsExpanded ? 1 : 0.7)
                        .opacity(bottomControlsExpanded ? 1 : 0)
                }
                .buttonStyle(.plain)

                Button(action: {}) {
                    // Apple Intelligence symbol with gradient mask
                    let aiGradient = AngularGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.63, green: 0.38, blue: 0.98),   // purple
                            Color(red: 0.25, green: 0.63, blue: 0.98),   // blue
                            Color(red: 0.24, green: 0.84, blue: 0.55),   // green
                            Color(red: 0.98, green: 0.85, blue: 0.29),   // yellow
                            Color(red: 0.95, green: 0.44, blue: 0.32),   // orange
                            Color(red: 0.92, green: 0.29, blue: 0.60)    // pink
                        ]),
                        center: .center
                    )
                    ZStack {
                        aiGradient
                            .mask(
                                Image(systemName: "apple.intelligence")
                                    .font(.system(size: 20, weight: .regular))
                            )
                    }
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
                    .applyGlassEffect()
                    .scaleEffect(bottomControlsExpanded ? 1 : 0.7)
                    .opacity(bottomControlsExpanded ? 1 : 0)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .animation(.bouncy(duration: 0.6), value: bottomControlsExpanded)
    }

    // MARK: - Helpers
    private func closeNote() {
        // Persist edits
        var updated = note
        updated.title = editedTitle
        updated.content = editedContent
        updated.tags = editedTags
        updated.date = Date()
        onSave(updated)

        withAnimation(.bouncy(duration: 0.4)) { bottomControlsExpanded = false }
        withAnimation(.bouncy(duration: 0.4).delay(0.05)) { glassElementsVisible = false }
        withAnimation(.bouncy(duration: 0.5).delay(0.1)) { isViewMaterialized = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isPresented = false
        }
    }
    private func addTag() {
        let trimmed = newTagText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !editedTags.contains(trimmed) else {
            cancelTagInput()
            return
        }
        editedTags.append(trimmed)
        cancelTagInput()
    }

    private func removeTag(_ tag: String) {
        editedTags.removeAll { $0 == tag }
    }

    private func cancelTagInput() {
        newTagText = ""
        isAddingTag = false
        isAddingTagFocused = false
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    private var editedDisplayString: String {
        let cal = Calendar.current
        let time = timeFormatter.string(from: note.date)
        if cal.isDateInToday(note.date) {
            return "Edited Today at \(time)"
        } else if cal.isDateInYesterday(note.date) {
            return "Edited Yesterday at \(time)"
        } else {
            let date = dateFormatter.string(from: note.date)
            return "Edited \(date) at \(time)"
        }
    }
}

// MARK: - Subviews
private struct TagPill: View {
    let text: String
    let isSelected: Bool
    let isHovered: Bool
    let isPressed: Bool
    let visible: Bool
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "tag.fill")
                .font(.system(size: 10))
                .foregroundColor(Color("AccentColor"))
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color("PrimaryTextColor"))
                .lineLimit(1)
                .truncationMode(.tail)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .opacity(0.7)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .tintedLiquidGlass(in: Capsule(), tint: Color("TagBackgroundColor"))
        .scaleEffect((visible ? 1 : 0.92) * (isPressed ? 0.96 : 1.0))
        .opacity(visible ? 1 : 0)
    }
}

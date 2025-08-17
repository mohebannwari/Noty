//
//  NoteCard.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import SwiftUI

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 10))
                            .foregroundColor(Color("TertiaryTextColor"))
                        
                        Text(dateFormatter.string(from: note.date))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color("TertiaryTextColor"))
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color("SurfaceTranslucentColor"))
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            // Pin functionality will be implemented later
                        } label: {
                            Label("Pin Note", systemImage: "pin")
                        }
                        
                        Button {
                            // Move to folder functionality will be implemented later
                        } label: {
                            Label("Move to Folder", systemImage: "folder")
                        }
                        
                        Divider()
                        
                        Button("Delete", role: .destructive) {
                            // Delete functionality will be implemented later
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 12))
                            .foregroundColor(Color("MenuButtonColor"))
                            .frame(width: 24, height: 24)
                            .background(Color("SurfaceTranslucentColor"), in: Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.title)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color("PrimaryTextColor"))
                        .lineLimit(1)
                    
                    ZStack(alignment: .topLeading) {
                        // Base clear text
                        Text(note.content)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("SecondaryTextColor"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        
                        // Progressive blur overlay
                        Text(note.content)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("SecondaryTextColor"))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .blur(radius: 2.0)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.clear, location: 0.0),
                                        .init(color: Color.clear, location: 0.6),
                                        .init(color: Color.black.opacity(0.3), location: 0.8),
                                        .init(color: Color.black.opacity(0.7), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .mask(
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.black)
                            
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.black, location: 0.0),
                                    .init(color: Color.black.opacity(0.7), location: 0.3),
                                    .init(color: Color.black.opacity(0.3), location: 0.7),
                                    .init(color: Color.clear, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 60)
                        }
                    )
                }
            }
            
            
            // Floating tags
            if !note.tags.isEmpty {
                VStack {
                    Spacer()
                    HStack(spacing: 4) {
                        ForEach(note.tags, id: \.self) { tag in
                            HStack(spacing: 4) {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("AccentColor"))
                                
                                Text(tag)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color("PrimaryTextColor"))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: Capsule())
                            .background(Color("AccentColor").opacity(0.2))
                            .clipShape(Capsule())
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(.all, 12)
        .frame(width: 222, height: 182, alignment: .topLeading)
        .background(Color("CardBackgroundColor"))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .shadow(
            color: Color.black.opacity(isHovering ? 0.08 : 0.04),
            radius: isHovering ? 20 : 12,
            x: 0,
            y: isHovering ? 12 : 6
        )
        .shadow(
            color: Color.black.opacity(0.02),
            radius: 30,
            x: 0,
            y: 15
        )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
        .animation(.easeInOut, value: isHovering)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        return formatter
    }
}


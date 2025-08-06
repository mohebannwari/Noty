//
//  BottomBar.swift
//  Noty
//
//  Created by Moheb Anwari on 05.08.25.
//

import SwiftUI

struct BottomBar: View {
    @State private var isHoveringNewNote = false
    @State private var isHoveringTheme = false
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                // New note button - Bottom center with liquid glass effect
                Button {
                    // New note functionality will be implemented
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 14))
                            
                        Text("New note")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .glassEffect(.regular.interactive(), in: Capsule())
                    .scaleEffect(isHoveringNewNote ? 1.05 : 1.0)
                    .shadow(
                        color: Color.black.opacity(isHoveringNewNote ? 0.12 : 0.08),
                        radius: isHoveringNewNote ? 8 : 4,
                        x: 0,
                        y: isHoveringNewNote ? 4 : 2
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    isHoveringNewNote = hovering
                }
                .animation(.easeInOut, value: isHoveringNewNote)
                
                Spacer()
                
                // Theme toggle button - Bottom right with liquid glass effect
                Button {
                    // Theme toggle functionality will be implemented
                } label: {
                    Image(systemName: "circle.lefthalf.filled")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                        .frame(width: 40, height: 40)
                        .glassEffect(.regular.interactive(), in: Circle())
                        .scaleEffect(isHoveringTheme ? 1.1 : 1.0)
                        .shadow(
                            color: Color.black.opacity(isHoveringTheme ? 0.08 : 0.05),
                            radius: isHoveringTheme ? 6 : 3,
                            x: 0,
                            y: isHoveringTheme ? 3 : 1.5
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    isHoveringTheme = hovering
                }
                .animation(.easeInOut, value: isHoveringTheme)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 18)
        }
    }
}
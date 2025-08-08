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
        ZStack(alignment: .bottom) {
            Color.clear.ignoresSafeArea()

            // Search pill is provided by FloatingSearch; remove duplicate button

            // Independent: Bottom-center New note
            Button {
                // New note functionality will be implemented
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    Text("New note")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.black, in: Capsule())
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
            .padding(.bottom, 18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

            // Independent: Bottom-right Theme toggle
            Button {
                // Theme toggle functionality will be implemented
            } label: {
                Image(systemName: "circle.lefthalf.filled")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.102, green: 0.102, blue: 0.102))
                    .frame(width: 40, height: 40)
                    .adaptiveGlass(in: Circle())
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
            .padding(.trailing, 18)
            .padding(.bottom, 18)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
}

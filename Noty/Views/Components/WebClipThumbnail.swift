//
//  WebClipThumbnail.swift
//  Noty
//
//  Created by AI on 17.08.25.
//
//  Figma-spec web clip preview card with light/dark asset support

import SwiftUI

struct WebClipThumbnail: View {
    var imageNameLight: String
    var imageNameDark: String
    var title: String
    var excerpt: String
    var domain: String
    var url: String?
    var onDelete: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    @State private var metadata: WebMetadata?
    @State private var isLoading = false
    @StateObject private var thumbnailCache = ThumbnailCache.shared
    var body: some View {
        Button(action: openURL) {
            ZStack {
                // Outer glass container with 16px radius
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color("SurfaceTranslucentColor").opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                    )
                
                // Inner content with 4px padding
                VStack(spacing: 0) {
                    // Image section with top rounded corners
                    ZStack {
                        if let thumbnail = metadata?.thumbnail {
                            Image(nsImage: thumbnail)
                                .resizable()
                                .interpolation(.high)
                                .antialiased(true)
                                .scaledToFill()
                                .frame(width: 182, height: 116)
                                .clipped()
                        } else {
                            Image(colorScheme == .dark ? imageNameDark : imageNameLight)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 182, height: 116)
                        }
                        
                        if isLoading {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(0.8)
                                )
                                .frame(width: 182, height: 116)
                        }
                    }
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 12,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 12,
                            style: .continuous
                        )
                    )
                    
                    // Content section with bottom rounded corners
                    VStack(alignment: .leading, spacing: 8) {
                        Text(metadata?.title ?? title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("PrimaryTextColor"))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(metadata?.description ?? excerpt)
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(Color("SecondaryTextColor").opacity(0.7))
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 3) {
                            Image(systemName: "link")
                                .font(.system(size: 10))
                                .foregroundColor(Color("AccentColor"))
                            Text(metadata?.domain ?? domain)
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(Color("AccentColor"))
                        }
                    }
                    .padding(8)
                    .frame(width: 182)
                    .background(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 12,
                            bottomTrailingRadius: 12,
                            topTrailingRadius: 0,
                            style: .continuous
                        )
                        .fill(Color.white.opacity(colorScheme == .dark ? 0.1 : 1))
                    )
                }
                .padding(4)
            }
            .frame(width: 190)
            .shadow(
                color: Color.black.opacity(0.02),
                radius: 9,
                x: 0,
                y: 0
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.bouncy(duration: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
        .onAppear { loadMetadata() }
        .onChange(of: url) { _, _ in loadMetadata() }
        .onChange(of: domain) { _, _ in loadMetadata() }
    }
    
    private func loadMetadata() {
        guard let urlString = resolvedURLString() else { return }

        if let cachedMetadata = thumbnailCache.getMetadata(for: urlString) {
            metadata = cachedMetadata
            return
        }

        if let cachedImage = thumbnailCache.loadCachedThumbnail(for: urlString) {
            let domainString = URL(string: urlString)?.host ?? (domain.isEmpty ? urlString : domain)
            metadata = WebMetadata(
                title: title,
                description: excerpt,
                domain: domainString,
                url: urlString,
                thumbnail: cachedImage
            )
        }

        if thumbnailCache.isLoading(urlString) {
            isLoading = true
            return
        }

        isLoading = true
        thumbnailCache.fetchMetadata(for: urlString) { fetchedMetadata in
            DispatchQueue.main.async {
                metadata = fetchedMetadata
                isLoading = false

                if let thumbnail = fetchedMetadata.thumbnail {
                    thumbnailCache.cacheThumbnail(thumbnail, for: urlString)
                }
            }
        }
    }

    private func resolvedURLString() -> String? {
        if let u = url, !u.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return u.hasPrefix("http://") || u.hasPrefix("https://") ? u : "https://\(u)"
        }
        if !domain.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let d = domain
            return d.hasPrefix("http://") || d.hasPrefix("https://") ? d : "https://\(d)"
        }
        return nil
    }
    
    private func openURL() {
        let urlString = url ?? (domain.contains("://") ? domain : "https://\(domain)")
        guard let url = URL(string: urlString) else { return }
        
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #else
        UIApplication.shared.open(url)
        #endif
    }
}
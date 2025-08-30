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
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Thumbnail area
            Image(colorScheme == .dark ? imageNameDark : imageNameLight)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 182, height: 116)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
                )

            // Text block
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("PrimaryTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)

                Text(excerpt)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color("SecondaryTextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "link")
                        .font(.system(size: 10))
                        .foregroundColor(Color("AccentColor"))
                    Text(domain)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color("TertiaryTextColor"))
                }
            }
            .padding(10)
            .frame(width: 182)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color("CardBackgroundColor"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
                )
        )
    }
}

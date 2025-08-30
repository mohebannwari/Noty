//
//  GlassEffects.swift
//  Noty
//
//  Shared helpers to apply Apple's Liquid Glass effects with
//  sensible fallbacks on older OS versions.
//

import SwiftUI

extension View {
    /// Applies a standard liquid glass surface inside the given shape, bounded to that shape.
    /// - On modern OS versions uses `glassEffect(..., in:)`.
    /// - On older OS versions falls back to `.ultraThinMaterial` with a light stroke.
    @ViewBuilder
    func liquidGlass(in shape: some Shape) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            self.glassEffect(.regular.interactive(), in: shape)
        } else {
            self
                .background(.ultraThinMaterial, in: shape)
                .overlay(shape.stroke(Color.primary.opacity(0.06), lineWidth: 0.5))
        }
    }

    /// Applies a tinted liquid glass surface inside the given shape, bounded to that shape.
    /// The `tint` color may be an asset color that already encodes light/dark variants and alpha.
    /// You can additionally scale its opacity using `tintOpacity` if needed.
    @ViewBuilder
    func tintedLiquidGlass(
        in shape: some Shape,
        tint: Color,
        strokeOpacity: Double = 0.06,
        tintOpacity: Double = 1.0
    ) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            self
                .glassEffect(.regular.interactive(), in: shape)
                .background(shape.fill(tint.opacity(tintOpacity)))
                .overlay(shape.stroke(Color.primary.opacity(strokeOpacity), lineWidth: 0.5))
        } else {
            self
                .background(.ultraThinMaterial, in: shape)
                .background(shape.fill(tint.opacity(tintOpacity)))
                .overlay(shape.stroke(Color.primary.opacity(strokeOpacity), lineWidth: 0.5))
        }
    }
}

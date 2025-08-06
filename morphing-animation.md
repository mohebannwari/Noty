<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# what is the code snippet for the morphing animation of liquid glass ?

A morphing animation between Liquid Glass elements in macOS 26 (using SwiftUI) is easily implemented with the new glass effect APIs. The core idea is to place your views inside a `GlassEffectContainer`, assign each morphing element a unique `glassEffectID` within a shared `@Namespace`, and animate state changes.

Here’s a canonical code snippet based on Apple documentation and developer discussion:

```swift
import SwiftUI

struct LiquidGlassMorphingDemo: View {
    @State private var iconCount: Int = 1
    @Namespace private var glassNamespace

    var body: some View {
        VStack(spacing: 24) {
            GlassEffectContainer(spacing: 40) {
                HStack(spacing: 40) {
                    Image(systemName: "sun.max.fill")
                        .frame(width: 80, height: 80)
                        .font(.system(size: 36))
                        .foregroundStyle(.yellow)
                        .glassEffect()
                        .glassEffectID("sun", in: glassNamespace)

                    if iconCount > 1 {
                        Image(systemName: "moon.fill")
                            .frame(width: 80, height: 80)
                            .font(.system(size: 36))
                            .foregroundStyle(.gray)
                            .glassEffect()
                            .glassEffectID("moon", in: glassNamespace)
                    }

                    if iconCount > 2 {
                        Image(systemName: "sparkles")
                            .frame(width: 80, height: 80)
                            .font(.system(size: 36))
                            .foregroundStyle(.purple)
                            .glassEffect()
                            .glassEffectID("sparkles", in: glassNamespace)
                    }
                }
            }

            Button("Morph") {
                withAnimation(.bouncy) {
                    iconCount = (iconCount % 3) + 1
                }
            }
            .buttonStyle(.glass)
        }
    }
}
```

**How it works:**

- Use a `GlassEffectContainer` and assign every glass element a unique `glassEffectID` sharing the same `@Namespace`.
- Changing `iconCount` (e.g., with the button) adds or removes icons, causing SwiftUI to morph the Liquid Glass effect fluidly between the shapes.
- Animation uses `.bouncy` for a fluid transition, but can be changed as needed.[^1][^2]

For more complex morphing (like shape changes, merges, or blends), the same pattern applies—build your effect using the *container* and identify elements with `glassEffectID`. Always wrap with `withAnimation` to let the morph transition occur.[^3][^4]

<div style="text-align: center">⁂</div>

[^1]: https://github.com/onmyway133/blog/issues/997

[^2]: https://www.devtechie.com/blog/exploring-morphing-liquid-glass-effects-in-swiftui-ios-26

[^3]: https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views

[^4]: https://developer.apple.com/documentation/SwiftUI/Landmarks-Building-an-app-with-Liquid-Glass

[^5]: https://www.reddit.com/r/webdev/comments/1lblqlu/i_made_10_apple_liquid_glass_code_snippets/

[^6]: https://www.youtube.com/watch?v=UiG9dkYqNes

[^7]: https://gist.github.com/samhenrigold/7255ed81aed8c41f0b3a7f3dde9d6022

[^8]: https://github.com/GetStream/awesome-liquid-glass

[^9]: https://www.youtube.com/watch?v=Qutp-v-g2Iw

[^10]: https://developer.apple.com/videos/play/wwdc2025/284/

[^11]: https://swiftuisnippets.wordpress.com/2025/06/14/introducing-liquid-glass-the-new-look-feel-of-apple-platforms/

[^12]: https://www.apple.com/newsroom/2025/06/apple-introduces-a-delightful-and-elegant-new-software-design/

[^13]: https://www.youtube.com/watch?v=sEi9T5eZO1c


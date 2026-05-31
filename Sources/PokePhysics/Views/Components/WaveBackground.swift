import SwiftUI

private struct WaveShape: Shape {
    let verticalOffset: CGFloat
    let amplitude: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let y = rect.height * verticalOffset

        path.move(to: CGPoint(x: 0, y: y))
        path.addCurve(
            to: CGPoint(x: w, y: y),
            control1: CGPoint(x: w * 0.25, y: y - amplitude),
            control2: CGPoint(x: w * 0.75, y: y + amplitude)
        )
        return path
    }
}

struct WaveBackground: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        // Higher opacity in dark mode so waves remain subtly visible.
        let opacity: Double = scheme == .dark ? 0.10 : 0.04
        ZStack {
            WaveShape(verticalOffset: 0.32, amplitude: 22)
                .stroke(Color.navyAccent.opacity(opacity), lineWidth: 1.5)
            WaveShape(verticalOffset: 0.54, amplitude: 18)
                .stroke(Color.navyAccent.opacity(opacity * 0.87), lineWidth: 1.5)
            WaveShape(verticalOffset: 0.73, amplitude: 25)
                .stroke(Color.navyAccent.opacity(opacity * 0.75), lineWidth: 1.5)
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

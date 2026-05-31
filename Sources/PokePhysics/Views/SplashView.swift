import SwiftUI

struct SplashView: View {
    var onComplete: () -> Void

    // Apple physics states
    @State private var appleY: CGFloat = 0
    @State private var scaleX: CGFloat = 1
    @State private var scaleY: CGFloat = 1
    @State private var isSpinning = false

    // Orbit / text
    @State private var orbitVisible = false
    @State private var orbitStart: Date = .now
    @State private var showText = false

    var body: some View {
        GeometryReader { geo in
            let topStart   = -(geo.size.height / 2) - 80
            let bottomLand =  (geo.size.height / 2) - 130

            ZStack {
                Color.appBackground.ignoresSafeArea()

                // Atom orbits — TimelineView gives per-frame electron positions
                if orbitVisible {
                    TimelineView(.animation) { ctx in
                        let t   = ctx.date.timeIntervalSince(orbitStart)
                        let deg = (t * 144).truncatingRemainder(dividingBy: 360)
                        AtomOrbits(degrees: deg)
                    }
                    .transition(.opacity.animation(.easeIn(duration: 0.4)))
                }

                // Apple
                Text("🍎")
                    .font(.system(size: 52))
                    .scaleEffect(x: scaleX, y: scaleY, anchor: .center)
                    .rotationEffect(.degrees(isSpinning ? 360 : 0))
                    .animation(
                        isSpinning
                            ? .linear(duration: 7).repeatForever(autoreverses: false)
                            : .none,
                        value: isSpinning
                    )
                    .offset(y: appleY)

                // "ポケ物理" — 丸字
                Text("ポケ物理")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.navyAccent)
                    .opacity(showText ? 1 : 0)
                    .offset(y: showText ? 112 : 144)
                    .animation(.spring(response: 0.55, dampingFraction: 0.7), value: showText)
            }
            .onAppear {
                appleY = topStart
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    run(topStart: topStart, bottomLand: bottomLand)
                }
            }
        }
    }

    private func run(topStart: CGFloat, bottomLand: CGFloat) {
        // 1. 落下
        withAnimation(.easeIn(duration: 0.62)) {
            appleY = bottomLand
        }

        // 2. 着地 squash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) {
            withAnimation(.easeOut(duration: 0.08)) {
                scaleX = 1.4
                scaleY = 0.62
            }
        }

        // 3. 跳ね返り → 中央へ (stretch しながら上昇)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.70) {
            withAnimation(.interpolatingSpring(stiffness: 160, damping: 13)) {
                appleY  = 0
                scaleX  = 0.88
                scaleY  = 1.22
            }
        }

        // 3b. スケール正規化
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.98) {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.55)) {
                scaleX = 1.0
                scaleY = 1.0
            }
        }

        // 4. ゆっくり回転開始
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.08) {
            isSpinning = true
        }

        // 5. 電子軌道 表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.28) {
            orbitStart = .now
            withAnimation { orbitVisible = true }
        }

        // 6. テキスト 表示
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            showText = true
        }

        // 7. 完了コールバック
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
            onComplete()
        }
    }
}

// MARK: - 3軌道

private struct AtomOrbits: View {
    let degrees: Double

    var body: some View {
        ZStack {
            OrbitTrack(a: 76, b: 25, rotation:   0, degrees: degrees, phase:   0)
            OrbitTrack(a: 76, b: 25, rotation:  60, degrees: degrees, phase: 120)
            OrbitTrack(a: 76, b: 25, rotation: -60, degrees: degrees, phase: 240)
        }
    }
}

private struct OrbitTrack: View {
    let a: CGFloat        // semi-major (x)
    let b: CGFloat        // semi-minor (y)
    let rotation: Double  // orbital plane rotation in 2D (degrees)
    let degrees: Double   // current electron angle
    let phase: Double

    var body: some View {
        // 電子の軌道上位置を計算
        let θ = ((degrees + phase).truncatingRemainder(dividingBy: 360)) * .pi / 180
        let φ = rotation * .pi / 180
        let ex = a * cos(θ)
        let ey = b * sin(θ)
        let rx = ex * cos(φ) - ey * sin(φ)
        let ry = ex * sin(φ) + ey * cos(φ)

        ZStack {
            Ellipse()
                .stroke(Color.navyAccent.opacity(0.22), lineWidth: 1.2)
                .frame(width: a * 2, height: b * 2)
                .rotationEffect(.degrees(rotation))

            Circle()
                .fill(Color.navyAccent.opacity(0.85))
                .frame(width: 8, height: 8)
                .shadow(color: Color.navyAccent.opacity(0.45), radius: 4)
                .offset(x: rx, y: ry)
        }
    }
}

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color(hex: "FAFAFA")
                    .ignoresSafeArea()

                WaveBackground()

                VStack(spacing: 0) {
                    Spacer()

                    GlassBadgeView()

                    Spacer().frame(height: 32)

                    Text("ポケぶつ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "1F355C"))

                    Spacer().frame(height: 8)

                    Text("高校物理の公式集")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Spacer()

                    BeginButton {
                        router.path.append(AppRoute.home)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    HomeView()
                case .formulaList(let category):
                    FormulaListView(category: category)
                case .formulaDetail(let formula):
                    FormulaDetailView(formula: formula)
                }
            }
        }
    }
}

// MARK: - Glass Badge
private struct GlassBadgeView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.72, green: 0.80, blue: 0.90),
                            Color(red: 0.85, green: 0.90, blue: 0.97)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                )
                .shadow(color: Color(hex: "1F355C").opacity(0.15), radius: 16, x: 0, y: 8)
                .frame(width: 120, height: 120)

            Text("f")
                .font(.system(size: 52, weight: .bold, design: .serif))
                .italic()
                .foregroundColor(.white)
        }
    }
}

// MARK: - Begin Button
private struct BeginButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("はじめる")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1F355C"))
                )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}

import GoogleMobileAds
import SwiftUI

enum LaunchDefaults {
    static let hasLaunchedBeforeKey = "hasLaunchedBefore"
}

@main
struct PokePhysicsApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var bookmarkStore = BookmarkStore()
<<<<<<< HEAD
    @State private var shouldShowWelcome = !UserDefaults.standard.bool(forKey: LaunchDefaults.hasLaunchedBeforeKey)

    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                Group {
                    if shouldShowWelcome {
                        WelcomeView()
                    } else {
                        HomeView()
                    }
                }
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
            .environmentObject(router)
            .environmentObject(bookmarkStore)
=======
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                // WelcomeView は常に背後に用意。スプラッシュが消えた瞬間に見える。
                WelcomeView()
                    .environmentObject(router)
                    .environmentObject(bookmarkStore)

                if showSplash {
                    SplashView {
                        withAnimation(.easeOut(duration: 0.45)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                }
            }
>>>>>>> origin/claude/charming-curie-iXXnt
        }
    }
}

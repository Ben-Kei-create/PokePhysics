import SwiftUI

enum LaunchDefaults {
    static let hasLaunchedBeforeKey = "hasLaunchedBefore"
}

@main
struct PokePhysicsApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var bookmarkStore = BookmarkStore()
    @State private var shouldShowWelcome = !UserDefaults.standard.bool(forKey: LaunchDefaults.hasLaunchedBeforeKey)

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
        }
    }
}

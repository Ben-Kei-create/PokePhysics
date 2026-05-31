import GoogleMobileAds
import SwiftUI

@main
struct PokePhysicsApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var bookmarkStore = BookmarkStore()
    @State private var showSplash = true

    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack(path: $router.path) {
                    HomeView()
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
                .fontDesign(.rounded)
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
        }
    }
}

import SwiftUI

@main
struct PokePhysicsApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var bookmarkStore = BookmarkStore()
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
        }
    }
}

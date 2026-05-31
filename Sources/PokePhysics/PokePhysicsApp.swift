import SwiftUI

@main
struct PokePhysicsApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var bookmarkStore = BookmarkStore()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(router)
                .environmentObject(bookmarkStore)
        }
    }
}

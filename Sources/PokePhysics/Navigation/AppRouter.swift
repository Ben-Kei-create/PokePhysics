import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
}

enum AppRoute: Hashable {
    case home
    case formulaList(FormulaCategory)
    case formulaDetail(Formula)
}

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: HomeTab = .formulas
    @State private var bookmarkSearchText = ""
    @State private var formulaSearchText = ""
    @State private var constantSearchText = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoryListTab()
                .tabItem {
                    Label("公式", systemImage: "function")
                }
                .tag(HomeTab.formulas)

            BookmarksView(searchText: $bookmarkSearchText)
                .tabItem {
                    Label("ブックマーク", systemImage: "bookmark")
                }
                .tag(HomeTab.bookmarks)

            SearchView(searchText: $formulaSearchText)
                .tabItem {
                    Label("検索", systemImage: "magnifyingglass")
                }
                .tag(HomeTab.search)

            ConstantsView(searchText: $constantSearchText)
                .tabItem {
                    Label("定数", systemImage: "number")
                }
                .tag(HomeTab.constants)
        }
        .tint(.navyAccent)
        .navigationTitle(selectedTab.navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar(selectedTab == .formulas ? .hidden : .visible, for: .navigationBar)
    }
}

private enum HomeTab {
    case formulas
    case bookmarks
    case search
    case constants

    var navigationTitle: String {
        switch self {
        case .formulas:
            "ポケぶつ"
        case .bookmarks:
            "ブックマーク"
        case .search:
            "検索"
        case .constants:
            "定数"
        }
    }
}

// MARK: - Category List Tab
private struct CategoryListTab: View {
    @EnvironmentObject private var router: AppRouter

    private let categories = FormulaLibrary.allCategories

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ポケぶつ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("高校物理の公式集")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(categories) { category in
                        CategoryCard(category: category)
                            .onTapGesture {
                                router.path.append(AppRoute.formulaList(category))
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

// MARK: - Category Card
private struct CategoryCard: View {
    let category: FormulaCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 28))
                .foregroundColor(.navyAccent)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.navyAccent.opacity(0.12))
                )

            Spacer()

            Text(category.name)
                .font(.headline)
                .foregroundColor(.primary)

            Text("\(category.formulas.count)公式")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.navyButton.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}

import SwiftUI

struct HomeView: View {
    @State private var selectedTab: HomeTab = .formulas
    @State private var bookmarkSearchText = ""
    @State private var formulaSearchText = ""
    @State private var constantSearchText = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            CategoryListTab(searchText: $formulaSearchText)
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
            ""
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
    @Binding var searchText: String

    private let categories = FormulaLibrary.allCategories
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private var query: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var searchResults: [Formula] {
        FormulaLibrary.allCategories
            .flatMap(\.formulas)
            .filter { formula in
                formula.title.localizedCaseInsensitiveContains(query)
                    || formula.summary.localizedCaseInsensitiveContains(query)
                    || formula.latex.localizedCaseInsensitiveContains(query)
            }
    }

    var body: some View {
        VStack(spacing: 12) {
            AdBannerSlot()
                .padding(.horizontal, 16)
                .padding(.top, 8)

            InlineSearchField(prompt: "公式を検索", text: $searchText)
                .padding(.horizontal, 16)

            ScrollView {
                if query.isEmpty {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(categories) { category in
                            CategoryCard(category: category)
                                .onTapGesture {
                                    router.path.append(AppRoute.formulaList(category))
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                } else if searchResults.isEmpty {
                    EmptyFormulaSearchPlaceholder()
                        .padding(.top, 64)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(searchResults) { formula in
                            FormulaCard(formula: formula)
                                .onTapGesture {
                                    router.path.append(AppRoute.formulaDetail(formula))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

private struct AdBannerSlot: View {
    var body: some View {
        AdBannerView(adUnitID: AdMobConfiguration.formulaBannerAdUnitID)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.navyButton.opacity(0.07), radius: 8, x: 0, y: 3)
            )
    }
}

private struct EmptyFormulaSearchPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundColor(Color.navyAccent.opacity(0.3))

            Text("該当する公式はありません")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
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

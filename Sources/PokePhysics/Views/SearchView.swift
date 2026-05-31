import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var searchText = ""

    private let allFormulas = FormulaLibrary.allCategories.flatMap(\.formulas)

    private var searchResults: [Formula] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return allFormulas }

        return allFormulas.filter { formula in
            formula.title.localizedCaseInsensitiveContains(query)
                || formula.summary.localizedCaseInsensitiveContains(query)
                || formula.latex.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ScrollView {
            if searchResults.isEmpty {
                EmptySearchPlaceholder()
                    .padding(.top, 80)
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
                .padding(.vertical, 8)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("検索")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.visible, for: .navigationBar)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "公式を検索"
        )
    }
}

private struct EmptySearchPlaceholder: View {
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

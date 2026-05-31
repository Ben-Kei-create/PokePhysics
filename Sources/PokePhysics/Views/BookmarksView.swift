import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var bookmarkStore: BookmarkStore
    @Binding var searchText: String

    private var bookmarkedFormulas: [Formula] {
        FormulaLibrary.allCategories
            .flatMap(\.formulas)
            .filter { bookmarkStore.isBookmarked($0) }
    }

    private var visibleFormulas: [Formula] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return bookmarkedFormulas }

        return bookmarkedFormulas.filter { formula in
            formula.title.localizedCaseInsensitiveContains(query)
                || formula.summary.localizedCaseInsensitiveContains(query)
                || formula.latex.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !bookmarkedFormulas.isEmpty {
                    InlineSearchField(prompt: "ブックマークを検索", text: $searchText)
                        .padding(.horizontal, 16)
                }

                if bookmarkedFormulas.isEmpty {
                    EmptyBookmarksPlaceholder()
                        .padding(.top, 64)
                } else if visibleFormulas.isEmpty {
                    EmptyBookmarkSearchPlaceholder()
                        .padding(.top, 64)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(visibleFormulas) { formula in
                            FormulaCard(formula: formula)
                                .onTapGesture {
                                    router.path.append(AppRoute.formulaDetail(formula))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

private struct EmptyBookmarkSearchPlaceholder: View {
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

private struct EmptyBookmarksPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark")
                .font(.system(size: 44))
                .foregroundColor(Color.navyAccent.opacity(0.3))

            Text("ブックマークはありません")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("公式の右上のアイコンをタップして\nブックマークに追加できます。")
                .font(.caption)
                .foregroundColor(Color.secondary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

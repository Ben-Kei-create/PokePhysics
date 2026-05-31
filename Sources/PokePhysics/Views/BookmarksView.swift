import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var bookmarkStore: BookmarkStore

    private var bookmarkedFormulas: [Formula] {
        FormulaLibrary.allCategories
            .flatMap(\.formulas)
            .filter { bookmarkStore.isBookmarked($0) }
    }

    var body: some View {
        ScrollView {
            if bookmarkedFormulas.isEmpty {
                EmptyBookmarksPlaceholder()
                    .padding(.top, 80)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(bookmarkedFormulas) { formula in
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
        .navigationTitle("ブックマーク")
        .navigationBarTitleDisplayMode(.large)
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

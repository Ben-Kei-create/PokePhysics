import SwiftUI

struct ArticleListView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var selectedCategory: ArticleCategory? = nil

    private let categories = ArticleCategory.allCases

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("教科書")
                        .font(.largeTitle.bold())
                    Text("単元を章立てで学ぶ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                // Category filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryChip(title: "すべて", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        ForEach(categories, id: \.self) { cat in
                            CategoryChip(title: cat.localizedName, isSelected: selectedCategory == cat) {
                                selectedCategory = (selectedCategory == cat) ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                }

                // Content grouped by category → chapter
                ForEach(visibleCategories, id: \.self) { cat in
                    CategorySection(category: cat) { article in
                        router.path.append(AppRoute.articleDetail(article))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private var visibleCategories: [ArticleCategory] {
        if let sel = selectedCategory { return [sel] }
        return categories.filter { !ArticleLibrary.articles(for: $0).isEmpty }
    }
}

// MARK: - Category Section

private struct CategorySection: View {
    let category: ArticleCategory
    let onTap: (Article) -> Void

    private var chapters: [(name: String, articles: [Article])] {
        let arts = ArticleLibrary.articles(for: category)
            .sorted { ($0.order, $0.title) < ($1.order, $1.title) }
        var dict: [(String, [Article])] = []
        var seen: [String] = []
        for art in arts {
            if seen.contains(art.chapter) {
                if let idx = dict.firstIndex(where: { $0.0 == art.chapter }) {
                    dict[idx].1.append(art)
                }
            } else {
                seen.append(art.chapter)
                dict.append((art.chapter, [art]))
            }
        }
        return dict.map { (name: $0.0, articles: $0.1) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Category header
            HStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.navyAccent)
                    .frame(width: 30, height: 30)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.navyAccent.opacity(0.1)))
                Text(category.localizedName)
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                Spacer()
                Text("\(ArticleLibrary.articles(for: category).count)単元")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Chapters
            ForEach(chapters, id: \.name) { chapter in
                ChapterBlock(chapterName: chapter.name, articles: chapter.articles, onTap: onTap)
            }
        }
    }
}

// MARK: - Chapter Block

private struct ChapterBlock: View {
    let chapterName: String
    let articles: [Article]
    let onTap: (Article) -> Void
    @State private var expanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Chapter header
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    expanded.toggle()
                }
            } label: {
                HStack {
                    Text(chapterName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(articles.count)単元")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            if expanded {
                Divider().padding(.horizontal, 16)
                VStack(spacing: 0) {
                    ForEach(Array(articles.enumerated()), id: \.element.id) { idx, article in
                        Button { onTap(article) } label: {
                            ArticleRowView(article: article, index: idx + 1)
                        }
                        .buttonStyle(.plain)
                        if idx < articles.count - 1 {
                            Divider().padding(.leading, 56)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.navyButton.opacity(0.07), radius: 10, x: 0, y: 3)
        )
    }
}

// MARK: - Article Row

private struct ArticleRowView: View {
    let article: Article
    let index: Int

    var body: some View {
        HStack(spacing: 14) {
            Text(String(format: "%02d", index))
                .font(.system(.subheadline, design: .monospaced).weight(.semibold))
                .foregroundColor(.navyAccent.opacity(0.6))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)

                Text(article.excerpt)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Category Chip

private struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.navyButton : Color.cardBackground)
                        .shadow(color: Color.navyButton.opacity(isSelected ? 0 : 0.06), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(.plain)
    }
}

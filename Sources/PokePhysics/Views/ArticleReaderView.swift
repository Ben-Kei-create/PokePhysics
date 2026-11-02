import SwiftUI

struct ArticleReaderView: View {
    let article: Article
    @EnvironmentObject private var router: AppRouter
    @State private var activeSectionID: String = ""
    @State private var scrollToSection: String? = nil
    @Environment(\.colorScheme) private var scheme

    private var sections: [ArticleSection] { article.sections }
    private var relatedArticles: [Article] { ArticleLibrary.relatedArticles(for: article) }

    var body: some View {
        HStack(spacing: 0) {
            // Main content
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        articleHeader
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .padding(.bottom, 24)

                        ForEach(sections) { section in
                            SectionView(
                                section: section,
                                isActive: activeSectionID == section.id,
                                onWikiLinkTap: { target in navigate(to: target) }
                            )
                            .id(section.id)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                            .onAppear {
                                if activeSectionID.isEmpty { activeSectionID = section.id }
                            }
                            .background(
                                GeometryReader { geo in
                                    Color.clear.preference(
                                        key: SectionOffsetKey.self,
                                        value: [section.id: geo.frame(in: .global).minY]
                                    )
                                }
                            )
                        }

                        relatedSection
                            .padding(.horizontal, 20)
                            .padding(.bottom, 48)
                    }
                }
                .onPreferenceChange(SectionOffsetKey.self) { offsets in
                    updateActiveSection(offsets: offsets)
                }
                .onChange(of: scrollToSection) { id in
                    if let id = id {
                        withAnimation { proxy.scrollTo(id, anchor: .top) }
                        scrollToSection = nil
                    }
                }
            }
            .background(Color.appBackground.ignoresSafeArea())

            // Section sidebar (iPad style, hidden on small screens)
            SectionSidebar(
                sections: sections,
                activeSectionID: activeSectionID,
                onTap: { id in scrollToSection = id; activeSectionID = id }
            )
        }
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CategoryLabel(category: article.category)
            }
        }
    }

    // MARK: - Article Header

    private var articleHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(article.category.localizedName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.navyAccent)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Capsule().fill(Color.navyAccent.opacity(0.1)))

                Text(article.chapter)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(article.title)
                .font(.title.bold())
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 4) {
                Text("\(sections.count)節構成")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("·")
                    .foregroundColor(.secondary)
                Text(article.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider().padding(.top, 4)
        }
    }

    // MARK: - Related Articles

    @ViewBuilder
    private var relatedSection: some View {
        if !relatedArticles.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("関連する単元")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)

                VStack(spacing: 0) {
                    ForEach(Array(relatedArticles.enumerated()), id: \.element.id) { idx, art in
                        Button { router.path.append(AppRoute.articleDetail(art)) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(art.title)
                                        .font(.body.weight(.medium))
                                        .foregroundColor(.primary)
                                    Text(art.category.localizedName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(.plain)
                        if idx < relatedArticles.count - 1 { Divider().padding(.horizontal, 16) }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.navyButton.opacity(0.07), radius: 10, x: 0, y: 3)
                )
            }
        }
    }

    // MARK: - Helpers

    private func navigate(to target: String) {
        if let art = ArticleLibrary.article(title: target) {
            router.path.append(AppRoute.articleDetail(art))
        }
    }

    private func updateActiveSection(offsets: [String: CGFloat]) {
        let threshold: CGFloat = UIScreen.main.bounds.height * 0.35
        let visible = offsets.filter { $0.value < threshold }.sorted { $0.value > $1.value }
        if let topID = visible.first?.key {
            activeSectionID = topID
        }
    }
}

// MARK: - Section View

private struct SectionView: View {
    let section: ArticleSection
    let isActive: Bool
    let onWikiLinkTap: (String) -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if section.number > 0 {
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.navyAccent)
                        .frame(width: 3, height: 18)
                    Text("SECTION \(section.number)")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.navyAccent)
                        .tracking(0.8)
                }
            }

            MarkdownContentView(markdown: section.markdown, onWikiLinkTap: onWikiLinkTap)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.cardBackground)
                .shadow(
                    color: Color.navyButton.opacity(isActive ? 0.12 : 0.05),
                    radius: isActive ? 14 : 8,
                    x: 0, y: isActive ? 5 : 2
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.navyAccent.opacity(isActive ? 0.2 : 0), lineWidth: 1.5)
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

// MARK: - Section Sidebar

private struct SectionSidebar: View {
    let sections: [ArticleSection]
    let activeSectionID: String
    let onTap: (String) -> Void

    var body: some View {
        if sections.count > 1 {
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    ForEach(sections) { section in
                        Button { onTap(section.id) } label: {
                            Circle()
                                .fill(activeSectionID == section.id ? Color.navyAccent : Color.navyAccent.opacity(0.2))
                                .frame(width: 7, height: 7)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.trailing, 8)
                .padding(.vertical, 20)
                Spacer()
            }
            .frame(width: 22)
        }
    }
}

// MARK: - Category Label

private struct CategoryLabel: View {
    let category: ArticleCategory
    var body: some View {
        Label(category.localizedName, systemImage: category.icon)
            .font(.caption.weight(.semibold))
            .foregroundColor(.navyAccent)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Capsule().fill(Color.navyAccent.opacity(0.1)))
    }
}

// MARK: - Preference Key

private struct SectionOffsetKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]
    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

import SwiftUI

struct FormulaDetailView: View {
    let formula: Formula

    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var bookmarkStore: BookmarkStore
    @Environment(\.colorScheme) private var scheme

    private var relatedFormulas: [Formula] {
        FormulaLibrary.relatedFormulas(for: formula)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                LaTeXView(
                    latex: formula.latex,
                    fontSize: 44,
                    textColor: scheme == .dark ? .white : .black
                )
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .padding(.top, 8)

                SectionCard(title: "概要") {
                    Text(formula.summary)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if !formula.symbols.isEmpty {
                    SectionCard(title: "記号の意味") {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(formula.symbols) { sym in
                                HStack(alignment: .top, spacing: 4) {
                                    Text(sym.symbol)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.navyAccent)
                                    Text(": \(sym.description)")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }

                if !formula.conditions.isEmpty {
                    SectionCard(title: "成立条件") {
                        Text(formula.conditions)
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                if !relatedFormulas.isEmpty {
                    SectionCard(title: "関連する公式") {
                        VStack(spacing: 0) {
                            ForEach(Array(relatedFormulas.enumerated()), id: \.element.id) { index, related in
                                if index > 0 {
                                    Divider()
                                }
                                Button {
                                    router.path.append(AppRoute.formulaDetail(related))
                                } label: {
                                    HStack {
                                        Text(related.title)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle(formula.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    bookmarkStore.toggle(formula)
                } label: {
                    Image(systemName: bookmarkStore.isBookmarked(formula) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.navyAccent)
                }
            }
        }
    }
}

// MARK: - Section Card
private struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)

            VStack(alignment: .leading) {
                content()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.navyButton.opacity(0.07), radius: 10, x: 0, y: 3)
            )
        }
    }
}

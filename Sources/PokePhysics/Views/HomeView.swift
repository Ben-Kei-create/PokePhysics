import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            CategoryListTab()
                .tabItem {
                    Label("公式", systemImage: "function")
                }

            FlashcardView()
                .tabItem {
                    Label("暗記", systemImage: "square.stack")
                }

            BookmarksView()
                .tabItem {
                    Label("ブックマーク", systemImage: "bookmark")
                }
        }
        .tint(.navyAccent)
        .navigationBarHidden(true)
    }
}

// MARK: - Category List Tab
private struct CategoryListTab: View {
    @EnvironmentObject private var router: AppRouter

    private let categories = FormulaLibrary.allCategories

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("ポケぶつ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    HStack(spacing: 8) {
                        Text("高校物理の公式集")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("学習指導要領準拠")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.navyAccent)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(
                                Capsule().fill(Color.navyAccent.opacity(0.10))
                            )
                    }
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

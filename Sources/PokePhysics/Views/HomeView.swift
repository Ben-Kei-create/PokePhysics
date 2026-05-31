import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            CategoryListTab()
                .tabItem {
                    Label("公式", systemImage: "function")
                }

            BookmarksView()
                .tabItem {
                    Label("ブックマーク", systemImage: "bookmark")
                }
        }
        .tint(Color(hex: "1F355C"))
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
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("ポケぶつ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "1F355C"))
                    Text("高校物理の公式集")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)

                // Category grid
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
        .background(Color(hex: "FAFAFA").ignoresSafeArea())
    }
}

// MARK: - Category Card
private struct CategoryCard: View {
    let category: FormulaCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 28))
                .foregroundColor(Color(hex: "1F355C"))
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "1F355C").opacity(0.08))
                )

            Spacer()

            Text(category.name)
                .font(.headline)
                .foregroundColor(Color(hex: "1F355C"))

            Text("\(category.formulas.count)公式")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color(hex: "1F355C").opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter

    private let categories: [FormulaCategory] = [
        .sampleMechanics
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(categories) { category in
                    CategoryRow(category: category)
                        .onTapGesture {
                            router.path.append(AppRoute.formulaList(category))
                        }
                }
            }
            .padding(20)
        }
        .background(Color(hex: "FAFAFA").ignoresSafeArea())
        .navigationTitle("ポケぶつ")
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct CategoryRow: View {
    let category: FormulaCategory

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "1F355C"))
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "1F355C").opacity(0.08))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(Color(hex: "1F355C"))
                Text("\(category.formulas.count)公式")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color(hex: "1F355C").opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}

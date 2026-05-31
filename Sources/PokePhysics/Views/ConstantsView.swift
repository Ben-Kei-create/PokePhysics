import SwiftUI
import UIKit

struct ConstantsView: View {
    @Environment(\.colorScheme) private var scheme
    @Binding var searchText: String

    private var filteredCategories: [PhysicsConstantCategory] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return ConstantLibrary.allCategories }

        return ConstantLibrary.allCategories.compactMap { category in
            let constants = category.constants.filter { constant in
                constant.name.localizedCaseInsensitiveContains(query)
                    || constant.symbolLatex.localizedCaseInsensitiveContains(query)
                    || constant.value.localizedCaseInsensitiveContains(query)
                    || constant.unit.localizedCaseInsensitiveContains(query)
                    || constant.summary.localizedCaseInsensitiveContains(query)
            }
            guard !constants.isEmpty else { return nil }
            return PhysicsConstantCategory(
                id: category.id,
                name: category.name,
                icon: category.icon,
                constants: constants
            )
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                InlineSearchField(prompt: "定数を検索", text: $searchText)

                if filteredCategories.isEmpty {
                    EmptyConstantsPlaceholder()
                        .padding(.top, 64)
                } else {
                    ForEach(filteredCategories) { category in
                        ConstantsSection(
                            category: category,
                            textColor: scheme == .dark ? .white : .black
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .padding(.bottom, 24)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

private struct ConstantsSection: View {
    let category: PhysicsConstantCategory
    let textColor: UIColor

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .foregroundColor(.navyAccent)
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 4)

            LazyVStack(spacing: 12) {
                ForEach(category.constants) { constant in
                    ConstantCard(constant: constant, textColor: textColor)
                }
            }
        }
    }
}

private struct ConstantCard: View {
    let constant: PhysicsConstant
    let textColor: UIColor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                LaTeXView(latex: constant.symbolLatex, fontSize: 26, textColor: textColor)
                    .frame(width: 72, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.navyAccent.opacity(0.10))
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text(constant.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(constant.summary)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    valueText
                    unitText
                }

                VStack(alignment: .leading, spacing: 4) {
                    valueText
                    unitText
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.navyButton.opacity(0.07), radius: 10, x: 0, y: 3)
        )
    }

    private var valueText: some View {
        Text(constant.value)
            .font(.system(.body, design: .monospaced))
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var unitText: some View {
        Text(constant.unit)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct EmptyConstantsPlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "number")
                .font(.system(size: 44))
                .foregroundColor(Color.navyAccent.opacity(0.3))

            Text("該当する定数はありません")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

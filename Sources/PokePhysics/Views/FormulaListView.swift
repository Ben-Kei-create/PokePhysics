import SwiftUI

struct FormulaListView: View {
    let category: FormulaCategory

    @EnvironmentObject private var router: AppRouter
    @State private var selectedSegment: Int = 0

    private var segments: [String] { category.subcategories }

    private var filteredFormulas: [Formula] {
        guard !segments.isEmpty else { return category.formulas }
        let selected = segments[selectedSegment]
        return category.formulas.filter { $0.subcategory == selected }
    }

    var body: some View {
        VStack(spacing: 0) {
            if segments.count > 1 {
                Picker("", selection: $selectedSegment) {
                    ForEach(segments.indices, id: \.self) { index in
                        Text(segments[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredFormulas) { formula in
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
        .background(Color(hex: "FAFAFA").ignoresSafeArea())
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            styleSegmentedControl()
        }
    }

    private func styleSegmentedControl() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(hex: "1F355C"))
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.white],
            for: .selected
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color(hex: "1F355C"))],
            for: .normal
        )
    }
}

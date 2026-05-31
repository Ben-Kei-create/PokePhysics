import Foundation

struct FormulaCategory: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let formulas: [Formula]

    init(id: UUID = UUID(), name: String, icon: String, formulas: [Formula] = []) {
        self.id = id
        self.name = name
        self.icon = icon
        self.formulas = formulas
    }

    var subcategories: [String] {
        var seen = Set<String>()
        return formulas.compactMap { f in
            guard !f.subcategory.isEmpty, seen.insert(f.subcategory).inserted else { return nil }
            return f.subcategory
        }
    }
}

// MARK: - Sample Data
extension FormulaCategory {
    static let sampleMechanics: FormulaCategory = {
        let newton = Formula(
            title: "ニュートンの運動方程式",
            latex: "F = ma",
            summary: "物体に働く力 F は、物体の質量 m と加速度 a の積に等しい。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]")
            ],
            conditions: "慣性系で成立する。",
            subcategory: "運動の法則"
        )

        let momentum = Formula(
            title: "運動量保存則",
            latex: "m_1v_1 + m_2v_2 = m_1v_1' + m_2v_2'",
            summary: "外力が働かない系では全運動量は保存される。",
            symbols: [
                FormulaSymbol(symbol: "m_1, m_2", description: "各物体の質量 [kg]"),
                FormulaSymbol(symbol: "v_1, v_2", description: "衝突前の速度 [m/s]"),
                FormulaSymbol(symbol: "v_1', v_2'", description: "衝突後の速度 [m/s]")
            ],
            conditions: "外力が働かない孤立した系で成立する。",
            relatedFormulaIDs: [newton.id],
            subcategory: "力と運動"
        )

        let energy = Formula(
            title: "力学的エネルギー保存則",
            latex: "E = K + U = \\mathrm{const.}",
            summary: "運動エネルギーと位置エネルギーの和は一定。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "力学的エネルギー [J]"),
                FormulaSymbol(symbol: "K", description: "運動エネルギー [J]"),
                FormulaSymbol(symbol: "U", description: "位置エネルギー [J]")
            ],
            conditions: "保存力のみが働く系で成立する。",
            relatedFormulaIDs: [momentum.id],
            subcategory: "仕事とエネルギー"
        )

        let kineticEnergy = Formula(
            title: "運動エネルギー",
            latex: "K = \\frac{1}{2}mv^2",
            summary: "速度 v で運動する質量 m の物体が持つエネルギー。",
            symbols: [
                FormulaSymbol(symbol: "K", description: "運動エネルギー [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "v", description: "速度 [m/s]")
            ],
            conditions: "古典力学の範囲で成立する。",
            relatedFormulaIDs: [energy.id],
            subcategory: "仕事とエネルギー"
        )

        let velocityKinematics = Formula(
            title: "等加速度運動の速度",
            latex: "v = v_0 + at",
            summary: "初速度 v₀ から加速度 a で時間 t 後の速度。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "速度 [m/s]"),
                FormulaSymbol(symbol: "v_0", description: "初速度 [m/s]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]"),
                FormulaSymbol(symbol: "t", description: "時間 [s]")
            ],
            conditions: "加速度が一定のとき成立する。",
            subcategory: "力と運動"
        )

        return FormulaCategory(
            name: "力学",
            icon: "arrow.up.right.circle",
            formulas: [newton, momentum, energy, kineticEnergy, velocityKinematics]
        )
    }()
}

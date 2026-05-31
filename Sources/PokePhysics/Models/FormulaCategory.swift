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

    // MARK: - 電磁気学
    static let sampleElectromagnetism: FormulaCategory = {
        let coulomb = Formula(
            title: "クーロンの法則",
            latex: "F = k\\frac{q_1 q_2}{r^2}",
            summary: "二つの点電荷の間に働く静電気力は電荷の積に比例し距離の二乗に反比例する。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "静電気力 [N]"),
                FormulaSymbol(symbol: "k", description: "クーロン定数 ≈ 9×10⁹ [N·m²/C²]"),
                FormulaSymbol(symbol: "q_1, q_2", description: "各電荷 [C]"),
                FormulaSymbol(symbol: "r", description: "電荷間の距離 [m]")
            ],
            conditions: "真空中の点電荷間で成立する。",
            subcategory: "静電気"
        )

        let ohm = Formula(
            title: "オームの法則",
            latex: "V = IR",
            summary: "導体の両端の電圧は電流と抵抗の積に等しい。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "電圧 [V]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "R", description: "抵抗 [Ω]")
            ],
            conditions: "オーム性導体（線形素子）で成立する。",
            subcategory: "電流と回路"
        )

        let joule = Formula(
            title: "ジュール熱",
            latex: "Q = I^2Rt",
            summary: "電流が抵抗を流れるときに発生する熱量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "発熱量 [J]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "R", description: "抵抗 [Ω]"),
                FormulaSymbol(symbol: "t", description: "時間 [s]")
            ],
            conditions: "抵抗が一定のとき成立する。",
            relatedFormulaIDs: [ohm.id],
            subcategory: "電流と回路"
        )

        let capacitance = Formula(
            title: "コンデンサーの電荷",
            latex: "Q = CV",
            summary: "コンデンサーに蓄えられる電荷は電気容量と電圧の積。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "電荷 [C]"),
                FormulaSymbol(symbol: "C", description: "電気容量（静電容量） [F]"),
                FormulaSymbol(symbol: "V", description: "電圧 [V]")
            ],
            conditions: "平行板コンデンサーで近似的に成立する。",
            subcategory: "静電気"
        )

        let lorentz = Formula(
            title: "ローレンツ力",
            latex: "F = qvB\\sin\\theta",
            summary: "磁場中を運動する荷電粒子に働く力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "ローレンツ力 [N]"),
                FormulaSymbol(symbol: "q", description: "電荷 [C]"),
                FormulaSymbol(symbol: "v", description: "速さ [m/s]"),
                FormulaSymbol(symbol: "B", description: "磁束密度 [T]"),
                FormulaSymbol(symbol: "\\theta", description: "速度と磁場のなす角 [rad]")
            ],
            conditions: "粒子の速度と磁場が垂直（θ=90°）のとき F = qvB となる。",
            subcategory: "磁気"
        )

        let faraday = Formula(
            title: "ファラデーの電磁誘導の法則",
            latex: "\\varepsilon = -\\frac{\\Delta\\Phi}{\\Delta t}",
            summary: "コイルを貫く磁束の変化率に比例した起電力が誘導される。",
            symbols: [
                FormulaSymbol(symbol: "\\varepsilon", description: "誘導起電力 [V]"),
                FormulaSymbol(symbol: "\\Delta\\Phi", description: "磁束の変化量 [Wb]"),
                FormulaSymbol(symbol: "\\Delta t", description: "時間の変化量 [s]")
            ],
            conditions: "負符号はレンツの法則（誘導起電力が磁束変化を妨げる向き）を表す。",
            relatedFormulaIDs: [lorentz.id],
            subcategory: "磁気"
        )

        return FormulaCategory(
            name: "電磁気学",
            icon: "bolt.circle",
            formulas: [coulomb, ohm, joule, capacitance, lorentz, faraday]
        )
    }()

    // MARK: - 熱力学
    static let sampleThermodynamics: FormulaCategory = {
        let idealGas = Formula(
            title: "理想気体の状態方程式",
            latex: "PV = nRT",
            summary: "理想気体の圧力・体積・温度・物質量の関係式。",
            symbols: [
                FormulaSymbol(symbol: "P", description: "圧力 [Pa]"),
                FormulaSymbol(symbol: "V", description: "体積 [m³]"),
                FormulaSymbol(symbol: "n", description: "物質量 [mol]"),
                FormulaSymbol(symbol: "R", description: "気体定数 ≈ 8.314 [J/(mol·K)]"),
                FormulaSymbol(symbol: "T", description: "絶対温度 [K]")
            ],
            conditions: "気体を理想気体として扱える低圧・高温で成立する。",
            subcategory: "気体の法則"
        )

        let boyle = Formula(
            title: "ボイルの法則",
            latex: "P_1V_1 = P_2V_2",
            summary: "温度一定のとき、気体の圧力と体積の積は一定。",
            symbols: [
                FormulaSymbol(symbol: "P_1, P_2", description: "変化前後の圧力 [Pa]"),
                FormulaSymbol(symbol: "V_1, V_2", description: "変化前後の体積 [m³]")
            ],
            conditions: "温度（等温）が一定の条件で成立する。",
            relatedFormulaIDs: [idealGas.id],
            subcategory: "気体の法則"
        )

        let charlesLaw = Formula(
            title: "シャルルの法則",
            latex: "\\frac{V_1}{T_1} = \\frac{V_2}{T_2}",
            summary: "圧力一定のとき、気体の体積は絶対温度に比例する。",
            symbols: [
                FormulaSymbol(symbol: "V_1, V_2", description: "変化前後の体積 [m³]"),
                FormulaSymbol(symbol: "T_1, T_2", description: "変化前後の絶対温度 [K]")
            ],
            conditions: "圧力（等圧）が一定の条件で成立する。",
            relatedFormulaIDs: [idealGas.id],
            subcategory: "気体の法則"
        )

        let firstLaw = Formula(
            title: "熱力学第一法則",
            latex: "\\Delta U = Q - W",
            summary: "内部エネルギーの変化は吸収した熱量と外部にした仕事の差に等しい。",
            symbols: [
                FormulaSymbol(symbol: "\\Delta U", description: "内部エネルギーの変化 [J]"),
                FormulaSymbol(symbol: "Q", description: "吸収した熱量 [J]"),
                FormulaSymbol(symbol: "W", description: "外部にした仕事 [J]")
            ],
            conditions: "閉じた系に適用される。符号の慣習に注意（W は系が外部にした仕事）。",
            subcategory: "熱と仕事"
        )

        let internalEnergy = Formula(
            title: "単原子理想気体の内部エネルギー",
            latex: "U = \\frac{3}{2}nRT",
            summary: "単原子理想気体の全内部エネルギーは物質量と絶対温度に比例する。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "内部エネルギー [J]"),
                FormulaSymbol(symbol: "n", description: "物質量 [mol]"),
                FormulaSymbol(symbol: "R", description: "気体定数 [J/(mol·K)]"),
                FormulaSymbol(symbol: "T", description: "絶対温度 [K]")
            ],
            conditions: "単原子分子理想気体（He, Ar など）に限られる。",
            relatedFormulaIDs: [idealGas.id, firstLaw.id],
            subcategory: "熱と仕事"
        )

        return FormulaCategory(
            name: "熱力学",
            icon: "thermometer.medium",
            formulas: [idealGas, boyle, charlesLaw, firstLaw, internalEnergy]
        )
    }()

    // MARK: - 波動
    static let sampleWaves: FormulaCategory = {
        let waveEquation = Formula(
            title: "波の基本式",
            latex: "v = f\\lambda",
            summary: "波の速さは振動数と波長の積に等しい。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "波の速さ [m/s]"),
                FormulaSymbol(symbol: "f", description: "振動数 [Hz]"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "あらゆる波（音波・光波・水面波）に普遍的に成立する。",
            subcategory: "波の性質"
        )

        let period = Formula(
            title: "周期と振動数",
            latex: "T = \\frac{1}{f}",
            summary: "周期は振動数の逆数。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "f", description: "振動数 [Hz]")
            ],
            conditions: "単振動・周期的な波動すべてに成立する。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "波の性質"
        )

        let snell = Formula(
            title: "スネルの法則（屈折の法則）",
            latex: "n_1\\sin\\theta_1 = n_2\\sin\\theta_2",
            summary: "光が媒質の境界で屈折するとき、入射角と屈折角の正弦の比は屈折率の逆比に等しい。",
            symbols: [
                FormulaSymbol(symbol: "n_1, n_2", description: "各媒質の屈折率（無次元）"),
                FormulaSymbol(symbol: "\\theta_1", description: "入射角 [rad]"),
                FormulaSymbol(symbol: "\\theta_2", description: "屈折角 [rad]")
            ],
            conditions: "光が均質な等方性媒質の平面境界を通過するとき成立する。",
            subcategory: "光の性質"
        )

        let doppler = Formula(
            title: "ドップラー効果",
            latex: "f' = f\\frac{V + v_o}{V - v_s}",
            summary: "音源や観測者が運動するとき、観測される振動数が変化する。",
            symbols: [
                FormulaSymbol(symbol: "f'", description: "観測される振動数 [Hz]"),
                FormulaSymbol(symbol: "f", description: "音源の振動数 [Hz]"),
                FormulaSymbol(symbol: "V", description: "音速 [m/s]"),
                FormulaSymbol(symbol: "v_o", description: "観測者の速さ（音源に近づく向きを正） [m/s]"),
                FormulaSymbol(symbol: "v_s", description: "音源の速さ（観測者に近づく向きを正） [m/s]")
            ],
            conditions: "音源・観測者ともに音速より遅い（非超音速）場合に適用。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "音波"
        )

        let standingWave = Formula(
            title: "弦の固有振動数",
            latex: "f_n = \\frac{n}{2L}\\sqrt{\\frac{T}{\\mu}}",
            summary: "両端固定の弦の n 次固有振動数。",
            symbols: [
                FormulaSymbol(symbol: "f_n", description: "n 次固有振動数 [Hz]"),
                FormulaSymbol(symbol: "n", description: "倍音次数（1, 2, 3, …）"),
                FormulaSymbol(symbol: "L", description: "弦の長さ [m]"),
                FormulaSymbol(symbol: "T", description: "弦の張力 [N]"),
                FormulaSymbol(symbol: "\\mu", description: "弦の線密度 [kg/m]")
            ],
            conditions: "両端が固定された均一な弦で成立する。",
            relatedFormulaIDs: [waveEquation.id, period.id],
            subcategory: "音波"
        )

        let lightSpeed = Formula(
            title: "媒質中の光速",
            latex: "v = \\frac{c}{n}",
            summary: "媒質中の光速は真空中の光速を屈折率で割った値。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "媒質中の光速 [m/s]"),
                FormulaSymbol(symbol: "c", description: "真空中の光速 ≈ 3×10⁸ [m/s]"),
                FormulaSymbol(symbol: "n", description: "媒質の屈折率（無次元、≥1）")
            ],
            conditions: "光学的に均質な媒質において成立する。",
            relatedFormulaIDs: [snell.id],
            subcategory: "光の性質"
        )

        return FormulaCategory(
            name: "波動",
            icon: "waveform",
            formulas: [waveEquation, period, snell, doppler, standingWave, lightSpeed]
        )
    }()

    // MARK: - 原子物理
    static let sampleAtomicPhysics: FormulaCategory = {
        let photoelectric = Formula(
            title: "光電効果",
            latex: "E = hf - W",
            summary: "光電子の最大運動エネルギーは光子のエネルギーから仕事関数を引いた値。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "光電子の最大運動エネルギー [J]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "f", description: "光の振動数 [Hz]"),
                FormulaSymbol(symbol: "W", description: "仕事関数 [J]")
            ],
            conditions: "入射光の振動数が限界振動数を超えるとき光電子が放出される。",
            subcategory: "光と電子"
        )

        let deBroglie = Formula(
            title: "ド・ブロイ波長",
            latex: "\\lambda = \\frac{h}{mv}",
            summary: "運動量をもつ粒子には運動量に反比例する波長が対応する。",
            symbols: [
                FormulaSymbol(symbol: "\\lambda", description: "ド・ブロイ波長 [m]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "m", description: "粒子の質量 [kg]"),
                FormulaSymbol(symbol: "v", description: "粒子の速さ [m/s]")
            ],
            conditions: "非相対論的な速度では p = mv として扱える。",
            relatedFormulaIDs: [photoelectric.id],
            subcategory: "光と電子"
        )

        let bohrRadius = Formula(
            title: "ボーア半径",
            latex: "r_n = n^2 a_0",
            summary: "水素原子の n 番目の軌道半径は主量子数の二乗に比例する。",
            symbols: [
                FormulaSymbol(symbol: "r_n", description: "n 番目の軌道半径 [m]"),
                FormulaSymbol(symbol: "n", description: "主量子数（1, 2, 3, …）"),
                FormulaSymbol(symbol: "a_0", description: "ボーア半径 ≈ 5.29×10⁻¹¹ [m]")
            ],
            conditions: "水素原子のボーア模型で成立する。",
            subcategory: "原子模型"
        )

        let energyLevel = Formula(
            title: "水素原子のエネルギー準位",
            latex: "E_n = -\\frac{13.6}{n^2}\\ \\mathrm{eV}",
            summary: "水素原子の束縛状態のエネルギーは主量子数の二乗に反比例する。",
            symbols: [
                FormulaSymbol(symbol: "E_n", description: "n 番目のエネルギー準位 [eV]"),
                FormulaSymbol(symbol: "n", description: "主量子数（1, 2, 3, …）")
            ],
            conditions: "水素原子、または水素に近い一電子系の近似で使う。",
            relatedFormulaIDs: [bohrRadius.id],
            subcategory: "原子模型"
        )

        let radioactiveDecay = Formula(
            title: "放射性崩壊",
            latex: "N = N_0 \\left(\\frac{1}{2}\\right)^{t/T}",
            summary: "放射性原子核の数は半減期ごとに半分になる。",
            symbols: [
                FormulaSymbol(symbol: "N", description: "時刻 t の原子核数"),
                FormulaSymbol(symbol: "N_0", description: "初めの原子核数"),
                FormulaSymbol(symbol: "t", description: "経過時間 [s]"),
                FormulaSymbol(symbol: "T", description: "半減期 [s]")
            ],
            conditions: "多数の原子核について統計的に成立する。",
            subcategory: "原子核"
        )

        let massEnergy = Formula(
            title: "質量とエネルギー",
            latex: "E = mc^2",
            summary: "質量 m は光速の二乗を比例定数としてエネルギーに換算できる。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "エネルギー [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "c", description: "真空中の光速 ≈ 3×10⁸ [m/s]")
            ],
            conditions: "相対論的な質量エネルギー等価性を表す。",
            relatedFormulaIDs: [radioactiveDecay.id],
            subcategory: "原子核"
        )

        return FormulaCategory(
            name: "原子物理",
            icon: "atom",
            formulas: [photoelectric, deBroglie, bohrRadius, energyLevel, radioactiveDecay, massEnergy]
        )
    }()
}

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

        let displacementKinematics = Formula(
            title: "等加速度運動の変位",
            latex: "x = x_0 + v_0t + \\frac{1}{2}at^2",
            summary: "初期位置 x₀ から初速度 v₀、加速度 a で時間 t 後の位置。",
            symbols: [
                FormulaSymbol(symbol: "x", description: "時刻 t の位置 [m]"),
                FormulaSymbol(symbol: "x_0", description: "初期位置 [m]"),
                FormulaSymbol(symbol: "v_0", description: "初速度 [m/s]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]"),
                FormulaSymbol(symbol: "t", description: "時間 [s]")
            ],
            conditions: "加速度が一定のとき成立する。",
            relatedFormulaIDs: [velocityKinematics.id],
            subcategory: "力と運動"
        )

        let velocityDisplacement = Formula(
            title: "速度と変位の関係",
            latex: "v^2 - v_0^2 = 2a(x - x_0)",
            summary: "時間 t を含めずに、速度・加速度・変位の関係を表す式。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "速度 [m/s]"),
                FormulaSymbol(symbol: "v_0", description: "初速度 [m/s]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]"),
                FormulaSymbol(symbol: "x - x_0", description: "変位 [m]")
            ],
            conditions: "加速度が一定の直線運動で成立する。",
            relatedFormulaIDs: [velocityKinematics.id, displacementKinematics.id],
            subcategory: "力と運動"
        )

        let work = Formula(
            title: "仕事",
            latex: "W = Fd\\cos\\theta",
            summary: "力の向きと移動方向がなす角を考慮した仕事の大きさ。",
            symbols: [
                FormulaSymbol(symbol: "W", description: "仕事 [J]"),
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "d", description: "移動距離 [m]"),
                FormulaSymbol(symbol: "\\theta", description: "力と移動方向のなす角 [rad]")
            ],
            conditions: "力が一定で、物体が直線的に移動するときに使う。",
            relatedFormulaIDs: [newton.id, energy.id],
            subcategory: "仕事とエネルギー"
        )

        let gravitationalPotentialEnergy = Formula(
            title: "重力による位置エネルギー",
            latex: "U = mgh",
            summary: "基準面から高さ h にある質量 m の物体がもつ位置エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "位置エネルギー [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "g", description: "重力加速度 [m/s²]"),
                FormulaSymbol(symbol: "h", description: "基準面からの高さ [m]")
            ],
            conditions: "地表付近で重力加速度を一定とみなせる範囲で成立する。",
            relatedFormulaIDs: [energy.id],
            subcategory: "仕事とエネルギー"
        )

        let centripetalForce = Formula(
            title: "向心力",
            latex: "F = \\frac{mv^2}{r}",
            summary: "半径 r の円運動をする物体に中心向きに働く力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "向心力 [N]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "v", description: "速さ [m/s]"),
                FormulaSymbol(symbol: "r", description: "円運動の半径 [m]")
            ],
            conditions: "等速円運動で速さが一定のときに使う。",
            relatedFormulaIDs: [newton.id],
            subcategory: "円運動・単振動"
        )

        let springPeriod = Formula(
            title: "ばね振り子の周期",
            latex: "T = 2\\pi\\sqrt{\\frac{m}{k}}",
            summary: "ばね定数 k のばねにつながれた質量 m の物体の単振動周期。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "k", description: "ばね定数 [N/m]")
            ],
            conditions: "ばねがフックの法則に従い、振幅が十分小さいときに成立する。",
            subcategory: "円運動・単振動"
        )

        return FormulaCategory(
            name: "力学",
            icon: "arrow.up.right.circle",
            formulas: [
                newton,
                momentum,
                velocityKinematics,
                displacementKinematics,
                velocityDisplacement,
                work,
                energy,
                kineticEnergy,
                gravitationalPotentialEnergy,
                centripetalForce,
                springPeriod
            ]
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

        let electricField = Formula(
            title: "電場の定義",
            latex: "E = \\frac{F}{q}",
            summary: "単位電荷あたりに働く静電気力として電場を定義する。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "電場 [N/C]"),
                FormulaSymbol(symbol: "F", description: "電荷に働く力 [N]"),
                FormulaSymbol(symbol: "q", description: "電荷 [C]")
            ],
            conditions: "試験電荷が十分小さく、周囲の電場を乱さないとみなせるときに使う。",
            relatedFormulaIDs: [coulomb.id],
            subcategory: "静電気"
        )

        let electricPotential = Formula(
            title: "点電荷による電位",
            latex: "V = k\\frac{Q}{r}",
            summary: "点電荷 Q から距離 r の位置における電位。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "電位 [V]"),
                FormulaSymbol(symbol: "k", description: "クーロン定数 [N·m²/C²]"),
                FormulaSymbol(symbol: "Q", description: "点電荷 [C]"),
                FormulaSymbol(symbol: "r", description: "点電荷からの距離 [m]")
            ],
            conditions: "無限遠を電位の基準とする点電荷の電場で成立する。",
            relatedFormulaIDs: [coulomb.id, electricField.id],
            subcategory: "静電気"
        )

        let seriesResistance = Formula(
            title: "抵抗の直列接続",
            latex: "R = R_1 + R_2 + \\cdots",
            summary: "直列につないだ抵抗の合成抵抗は各抵抗の和になる。",
            symbols: [
                FormulaSymbol(symbol: "R", description: "合成抵抗 [Ω]"),
                FormulaSymbol(symbol: "R_1, R_2", description: "各抵抗 [Ω]")
            ],
            conditions: "各抵抗に同じ電流が流れる直列回路で成立する。",
            relatedFormulaIDs: [ohm.id],
            subcategory: "電流と回路"
        )

        let parallelResistance = Formula(
            title: "抵抗の並列接続",
            latex: "\\frac{1}{R} = \\frac{1}{R_1} + \\frac{1}{R_2} + \\cdots",
            summary: "並列につないだ抵抗の合成抵抗の逆数は各抵抗の逆数の和になる。",
            symbols: [
                FormulaSymbol(symbol: "R", description: "合成抵抗 [Ω]"),
                FormulaSymbol(symbol: "R_1, R_2", description: "各抵抗 [Ω]")
            ],
            conditions: "各抵抗に同じ電圧がかかる並列回路で成立する。",
            relatedFormulaIDs: [ohm.id, seriesResistance.id],
            subcategory: "電流と回路"
        )

        let electricPower = Formula(
            title: "電力",
            latex: "P = IV",
            summary: "電流 I が電圧 V のもとで単位時間あたりに消費するエネルギー。",
            symbols: [
                FormulaSymbol(symbol: "P", description: "電力 [W]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "V", description: "電圧 [V]")
            ],
            conditions: "直流回路や瞬時値として扱える交流回路で使う。",
            relatedFormulaIDs: [ohm.id, joule.id],
            subcategory: "電流と回路"
        )

        let conductorForce = Formula(
            title: "磁場中の電流が受ける力",
            latex: "F = IBL\\sin\\theta",
            summary: "磁場中の導線に電流が流れるとき、導線が受ける力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "導線が受ける力 [N]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "B", description: "磁束密度 [T]"),
                FormulaSymbol(symbol: "L", description: "磁場中にある導線の長さ [m]"),
                FormulaSymbol(symbol: "\\theta", description: "電流と磁場のなす角 [rad]")
            ],
            conditions: "一様な磁場中に直線導線が置かれているときに使う。",
            relatedFormulaIDs: [lorentz.id],
            subcategory: "磁気"
        )

        let capacitorEnergy = Formula(
            title: "コンデンサーの静電エネルギー",
            latex: "U = \\frac{1}{2}CV^2",
            summary: "コンデンサーに蓄えられる電場のエネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "静電エネルギー [J]"),
                FormulaSymbol(symbol: "C", description: "電気容量 [F]"),
                FormulaSymbol(symbol: "V", description: "電圧 [V]")
            ],
            conditions: "電気容量 C が一定のコンデンサーで成立する。",
            relatedFormulaIDs: [capacitance.id],
            subcategory: "静電気"
        )

        return FormulaCategory(
            name: "電磁気学",
            icon: "bolt.circle",
            formulas: [
                coulomb,
                electricField,
                electricPotential,
                capacitance,
                capacitorEnergy,
                ohm,
                seriesResistance,
                parallelResistance,
                electricPower,
                joule,
                lorentz,
                conductorForce,
                faraday
            ]
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

        let amountOfSubstance = Formula(
            title: "物質量と粒子数",
            latex: "N = nN_A",
            summary: "物質量 n mol に含まれる粒子数は、アボガドロ定数との積で表される。",
            symbols: [
                FormulaSymbol(symbol: "N", description: "粒子数"),
                FormulaSymbol(symbol: "n", description: "物質量 [mol]"),
                FormulaSymbol(symbol: "N_A", description: "アボガドロ定数 [mol⁻¹]")
            ],
            conditions: "原子・分子・イオンなど、数える対象を1種類にそろえて扱う。",
            relatedFormulaIDs: [idealGas.id],
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

        let heatCapacityEquation = Formula(
            title: "温度変化に必要な熱量",
            latex: "Q = mc\\Delta T",
            summary: "質量 m の物体の温度を ΔT だけ変えるのに必要な熱量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "熱量 [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "c", description: "比熱 [J/(kg·K)]"),
                FormulaSymbol(symbol: "\\Delta T", description: "温度変化 [K]")
            ],
            conditions: "相変化がなく、比熱を一定とみなせる範囲で成立する。",
            relatedFormulaIDs: [firstLaw.id],
            subcategory: "熱と仕事"
        )

        let latentHeat = Formula(
            title: "潜熱",
            latex: "Q = mL",
            summary: "物質が相変化するときに出入りする熱量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "潜熱として出入りする熱量 [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "L", description: "融解熱・蒸発熱などの潜熱 [J/kg]")
            ],
            conditions: "温度が一定のまま相変化が進む過程で使う。",
            relatedFormulaIDs: [heatCapacityEquation.id],
            subcategory: "熱と仕事"
        )

        let isobaricWork = Formula(
            title: "気体がする仕事",
            latex: "W = P\\Delta V",
            summary: "圧力 P が一定のとき、気体が体積変化で外部にする仕事。",
            symbols: [
                FormulaSymbol(symbol: "W", description: "気体がした仕事 [J]"),
                FormulaSymbol(symbol: "P", description: "圧力 [Pa]"),
                FormulaSymbol(symbol: "\\Delta V", description: "体積変化 [m³]")
            ],
            conditions: "等圧変化で成立する。膨張では W > 0、圧縮では W < 0 と扱う。",
            relatedFormulaIDs: [firstLaw.id],
            subcategory: "熱と仕事"
        )

        let heatEfficiency = Formula(
            title: "熱機関の熱効率",
            latex: "\\eta = \\frac{W}{Q_h}",
            summary: "高温熱源から受け取った熱量のうち、仕事に変換できた割合。",
            symbols: [
                FormulaSymbol(symbol: "\\eta", description: "熱効率"),
                FormulaSymbol(symbol: "W", description: "外部へした仕事 [J]"),
                FormulaSymbol(symbol: "Q_h", description: "高温熱源から受け取った熱量 [J]")
            ],
            conditions: "1周期で元の状態に戻る熱機関について定義される。",
            relatedFormulaIDs: [firstLaw.id, isobaricWork.id],
            subcategory: "熱と仕事"
        )

        let molecularKineticEnergy = Formula(
            title: "分子の平均運動エネルギー",
            latex: "\\frac{1}{2}m\\overline{v^2} = \\frac{3}{2}kT",
            summary: "単原子理想気体の分子1個あたりの平均並進運動エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "m", description: "分子1個の質量 [kg]"),
                FormulaSymbol(symbol: "\\overline{v^2}", description: "速さの二乗平均 [m²/s²]"),
                FormulaSymbol(symbol: "k", description: "ボルツマン定数 [J/K]"),
                FormulaSymbol(symbol: "T", description: "絶対温度 [K]")
            ],
            conditions: "単原子理想気体を分子運動論で扱うときに成立する。",
            relatedFormulaIDs: [idealGas.id, internalEnergy.id],
            subcategory: "気体の法則"
        )

        let molarHeat = Formula(
            title: "モル比熱による熱量",
            latex: "Q = nC\\Delta T",
            summary: "物質量 n の気体や物質を温度変化させるときの熱量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "熱量 [J]"),
                FormulaSymbol(symbol: "n", description: "物質量 [mol]"),
                FormulaSymbol(symbol: "C", description: "モル比熱 [J/(mol·K)]"),
                FormulaSymbol(symbol: "\\Delta T", description: "温度変化 [K]")
            ],
            conditions: "相変化がなく、モル比熱 C を一定とみなせるときに使う。",
            relatedFormulaIDs: [heatCapacityEquation.id],
            subcategory: "熱と仕事"
        )

        return FormulaCategory(
            name: "熱力学",
            icon: "thermometer.medium",
            formulas: [
                idealGas,
                amountOfSubstance,
                boyle,
                charlesLaw,
                molecularKineticEnergy,
                firstLaw,
                internalEnergy,
                heatCapacityEquation,
                latentHeat,
                isobaricWork,
                heatEfficiency,
                molarHeat
            ]
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

        let waveFunction = Formula(
            title: "正弦波の式",
            latex: "y = A\\sin 2\\pi\\left(\\frac{t}{T} - \\frac{x}{\\lambda}\\right)",
            summary: "右向きに進む正弦波の変位 y を表す式。",
            symbols: [
                FormulaSymbol(symbol: "y", description: "媒質の変位 [m]"),
                FormulaSymbol(symbol: "A", description: "振幅 [m]"),
                FormulaSymbol(symbol: "t", description: "時刻 [s]"),
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "x", description: "位置 [m]"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "位相の基準を y = 0 から正方向へ進む形に取った右向き進行波で使う。",
            relatedFormulaIDs: [waveEquation.id, period.id],
            subcategory: "波の性質"
        )

        let constructiveInterference = Formula(
            title: "強め合う干渉条件",
            latex: "\\Delta L = m\\lambda",
            summary: "2つの波の経路差が波長の整数倍のとき、波は強め合う。",
            symbols: [
                FormulaSymbol(symbol: "\\Delta L", description: "経路差 [m]"),
                FormulaSymbol(symbol: "m", description: "整数（0, 1, 2, …）"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "同位相の2つの波が重ね合わさるときの条件。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "波の性質"
        )

        let destructiveInterference = Formula(
            title: "弱め合う干渉条件",
            latex: "\\Delta L = \\left(m + \\frac{1}{2}\\right)\\lambda",
            summary: "2つの波の経路差が半波長ずれたとき、波は弱め合う。",
            symbols: [
                FormulaSymbol(symbol: "\\Delta L", description: "経路差 [m]"),
                FormulaSymbol(symbol: "m", description: "整数（0, 1, 2, …）"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "同位相の2つの波が重ね合わさるときの条件。",
            relatedFormulaIDs: [constructiveInterference.id],
            subcategory: "波の性質"
        )

        let lensEquation = Formula(
            title: "薄レンズの公式",
            latex: "\\frac{1}{a} + \\frac{1}{b} = \\frac{1}{f}",
            summary: "物体距離・像距離・焦点距離の関係を表す式。",
            symbols: [
                FormulaSymbol(symbol: "a", description: "物体距離 [m]"),
                FormulaSymbol(symbol: "b", description: "像距離 [m]"),
                FormulaSymbol(symbol: "f", description: "焦点距離 [m]")
            ],
            conditions: "薄い凸レンズ・凹レンズを近軸光線で扱うときに使う。",
            relatedFormulaIDs: [snell.id],
            subcategory: "光の性質"
        )

        let diffractionGrating = Formula(
            title: "回折格子の明線条件",
            latex: "d\\sin\\theta = m\\lambda",
            summary: "回折格子で明線が現れる角度を決める条件。",
            symbols: [
                FormulaSymbol(symbol: "d", description: "格子間隔 [m]"),
                FormulaSymbol(symbol: "\\theta", description: "回折角 [rad]"),
                FormulaSymbol(symbol: "m", description: "明線の次数（0, 1, 2, …）"),
                FormulaSymbol(symbol: "\\lambda", description: "光の波長 [m]")
            ],
            conditions: "隣り合うすき間から出た光の経路差が波長の整数倍になるときに成立する。",
            relatedFormulaIDs: [constructiveInterference.id],
            subcategory: "光の性質"
        )

        let soundSpeed = Formula(
            title: "気温による音速",
            latex: "v = 331.5 + 0.6t",
            summary: "気温 t ℃ の空気中を伝わる音の速さの近似式。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "音速 [m/s]"),
                FormulaSymbol(symbol: "t", description: "気温 [℃]")
            ],
            conditions: "乾燥空気中での近似式として使う。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "音波"
        )

        return FormulaCategory(
            name: "波動",
            icon: "waveform",
            formulas: [
                waveEquation,
                period,
                waveFunction,
                constructiveInterference,
                destructiveInterference,
                snell,
                lightSpeed,
                lensEquation,
                diffractionGrating,
                doppler,
                standingWave,
                soundSpeed
            ]
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

        let photonEnergy = Formula(
            title: "光子のエネルギー",
            latex: "E = hf",
            summary: "振動数 f の光子1個がもつエネルギー。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "光子のエネルギー [J]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "f", description: "光の振動数 [Hz]")
            ],
            conditions: "光を光子として扱う量子論的な関係式。",
            relatedFormulaIDs: [photoelectric.id],
            subcategory: "光と電子"
        )

        let photonMomentum = Formula(
            title: "光子の運動量",
            latex: "p = \\frac{h}{\\lambda}",
            summary: "波長 λ の光子がもつ運動量。",
            symbols: [
                FormulaSymbol(symbol: "p", description: "光子の運動量 [kg·m/s]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "\\lambda", description: "光の波長 [m]")
            ],
            conditions: "真空中の光子や、光の粒子性を扱う場面で使う。",
            relatedFormulaIDs: [photonEnergy.id, deBroglie.id],
            subcategory: "光と電子"
        )

        let rydbergFormula = Formula(
            title: "水素原子のスペクトル",
            latex: "\\frac{1}{\\lambda} = R\\left(\\frac{1}{m^2} - \\frac{1}{n^2}\\right)",
            summary: "水素原子が放出・吸収する光の波長を与えるリュードベリの式。",
            symbols: [
                FormulaSymbol(symbol: "\\lambda", description: "光の波長 [m]"),
                FormulaSymbol(symbol: "R", description: "リュードベリ定数 [1/m]"),
                FormulaSymbol(symbol: "m, n", description: "整数の量子数（n > m）")
            ],
            conditions: "水素原子の電子が n から m の準位へ遷移するときに使う。",
            relatedFormulaIDs: [energyLevel.id, photonEnergy.id],
            subcategory: "原子模型"
        )

        let exponentialDecay = Formula(
            title: "放射性崩壊の指数法則",
            latex: "N = N_0 e^{-\\lambda t}",
            summary: "放射性原子核の数が時間とともに指数関数的に減少することを表す。",
            symbols: [
                FormulaSymbol(symbol: "N", description: "時刻 t の原子核数"),
                FormulaSymbol(symbol: "N_0", description: "初めの原子核数"),
                FormulaSymbol(symbol: "\\lambda", description: "崩壊定数 [1/s]"),
                FormulaSymbol(symbol: "t", description: "経過時間 [s]")
            ],
            conditions: "多数の原子核について統計的に成立する。",
            relatedFormulaIDs: [radioactiveDecay.id],
            subcategory: "原子核"
        )

        let halfLife = Formula(
            title: "半減期と崩壊定数",
            latex: "T = \\frac{\\ln 2}{\\lambda}",
            summary: "半減期 T と崩壊定数 λ の関係。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "半減期 [s]"),
                FormulaSymbol(symbol: "\\lambda", description: "崩壊定数 [1/s]")
            ],
            conditions: "放射性崩壊が指数法則に従うときに成立する。",
            relatedFormulaIDs: [radioactiveDecay.id, exponentialDecay.id],
            subcategory: "原子核"
        )

        let nuclearEnergy = Formula(
            title: "核反応のエネルギー",
            latex: "Q = \\Delta mc^2",
            summary: "核反応で失われた質量がエネルギーとして放出される量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "放出または吸収されるエネルギー [J]"),
                FormulaSymbol(symbol: "\\Delta m", description: "反応前後の質量差 [kg]"),
                FormulaSymbol(symbol: "c", description: "真空中の光速 [m/s]")
            ],
            conditions: "質量欠損をエネルギーに換算するときに使う。",
            relatedFormulaIDs: [massEnergy.id],
            subcategory: "原子核"
        )

        return FormulaCategory(
            name: "原子物理",
            icon: "atom",
            formulas: [
                photoelectric,
                photonEnergy,
                photonMomentum,
                deBroglie,
                bohrRadius,
                energyLevel,
                rydbergFormula,
                radioactiveDecay,
                exponentialDecay,
                halfLife,
                massEnergy,
                nuclearEnergy
            ]
        )
    }()
}

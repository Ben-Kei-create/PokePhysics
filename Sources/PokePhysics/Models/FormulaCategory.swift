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

// MARK: - 力学
extension FormulaCategory {
    static let sampleMechanics: FormulaCategory = {
        // 運動の法則
        let newton = Formula(
            title: "ニュートンの運動方程式",
            latex: "F = ma",
            summary: "物体に働く合力 F は、質量 m と加速度 a の積に等しい。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "合力 [N]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]")
            ],
            conditions: "慣性系で成立する。",
            subcategory: "運動の法則",
            examTag: .common,
            example: "質量 3 kg に 12 N を加えたときの加速度は？→ a = 12/3 = 4 m/s²"
        )
        let hooke = Formula(
            title: "フックの法則",
            latex: "F = kx",
            summary: "ばねの弾性力は変形量に比例する。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "弾性力 [N]"),
                FormulaSymbol(symbol: "k", description: "ばね定数 [N/m]"),
                FormulaSymbol(symbol: "x", description: "変形量 [m]")
            ],
            conditions: "弾性限界内で成立する。",
            subcategory: "運動の法則",
            examTag: .common,
            example: "k = 200 N/m のばねを 5 cm 伸ばした弾性力は？→ F = 200×0.05 = 10 N"
        )
        let friction = Formula(
            title: "摩擦力",
            latex: "F = \\mu N",
            summary: "摩擦力は垂直抗力と摩擦係数の積。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "摩擦力 [N]"),
                FormulaSymbol(symbol: "\\mu", description: "摩擦係数（無次元）"),
                FormulaSymbol(symbol: "N", description: "垂直抗力 [N]")
            ],
            conditions: "静止摩擦係数と動摩擦係数で値が異なる。",
            subcategory: "運動の法則",
            examTag: .common,
            example: "質量 5 kg（g=10）、μ=0.30 の動摩擦力は？→ F = 0.30×50 = 15 N"
        )
        // 力と運動
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
            subcategory: "力と運動",
            examTag: .common,
            example: "v₀=4 m/s、a=2 m/s²。3 s 後の速度は？→ v = 4+2×3 = 10 m/s"
        )
        let displacement = Formula(
            title: "等加速度運動の変位",
            latex: "x = v_0 t + \\frac{1}{2}at^2",
            summary: "初速度 v₀、加速度 a での時間 t 間の変位。",
            symbols: [
                FormulaSymbol(symbol: "x", description: "変位 [m]"),
                FormulaSymbol(symbol: "v_0", description: "初速度 [m/s]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]"),
                FormulaSymbol(symbol: "t", description: "時間 [s]")
            ],
            conditions: "加速度一定。",
            relatedFormulaIDs: [velocityKinematics.id],
            subcategory: "力と運動",
            examTag: .common,
            example: "v₀=0、a=3 m/s²。4 s 後の変位は？→ x = ½×3×16 = 24 m"
        )
        let momentum = Formula(
            title: "運動量保存則",
            latex: "m_1 v_1 + m_2 v_2 = m_1 v_1' + m_2 v_2'",
            summary: "外力が働かない系では全運動量は保存される。",
            symbols: [
                FormulaSymbol(symbol: "m_1, m_2", description: "各物体の質量 [kg]"),
                FormulaSymbol(symbol: "v_1, v_2", description: "衝突前の速度 [m/s]"),
                FormulaSymbol(symbol: "v_1', v_2'", description: "衝突後の速度 [m/s]")
            ],
            conditions: "外力が働かない孤立した系で成立する。",
            relatedFormulaIDs: [newton.id],
            subcategory: "力と運動",
            examTag: .common,
            example: "2 kg（3 m/s）と 3 kg（静止）が完全非弾性衝突。衝突後の速度は？→ v' = 1.2 m/s"
        )
        let centripetal = Formula(
            title: "向心力",
            latex: "F = mr\\omega^2 = \\frac{mv^2}{r}",
            summary: "円運動する物体に働く中心方向の力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "向心力 [N]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "r", description: "半径 [m]"),
                FormulaSymbol(symbol: "\\omega", description: "角速度 [rad/s]"),
                FormulaSymbol(symbol: "v", description: "速さ [m/s]")
            ],
            conditions: "等速円運動のとき成立する。",
            relatedFormulaIDs: [newton.id],
            subcategory: "力と運動",
            examTag: .common,
            example: "0.5 kg、r=2 m、v=4 m/s の円運動。向心力は？→ F = 0.5×16/2 = 4 N"
        )
        let pressure = Formula(
            title: "圧力",
            latex: "P = \\frac{F}{S}",
            summary: "単位面積あたりに垂直に働く力。",
            symbols: [
                FormulaSymbol(symbol: "P", description: "圧力 [Pa]"),
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "S", description: "面積 [m²]")
            ],
            conditions: "力が面に垂直に一様にかかるとき。",
            subcategory: "力と運動",
            examTag: .common,
            example: "面積 0.02 m² に 400 N。圧力は？→ P = 400/0.02 = 2×10⁴ Pa"
        )
        let velocitySquared = Formula(
            title: "等加速度運動（v²の公式）",
            latex: "v^2 - v_0^2 = 2ax",
            summary: "時間 t を消去した等加速度運動の関係式。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "速度 [m/s]"),
                FormulaSymbol(symbol: "v_0", description: "初速度 [m/s]"),
                FormulaSymbol(symbol: "a", description: "加速度 [m/s²]"),
                FormulaSymbol(symbol: "x", description: "変位 [m]")
            ],
            conditions: "加速度が一定のとき成立する。",
            relatedFormulaIDs: [velocityKinematics.id, displacement.id],
            subcategory: "力と運動",
            examTag: .common,
            example: "v₀=0、a=5 m/s²、x=20 m。速度は？→ v = √200 ≈ 14.1 m/s"
        )
        let angularVelocity = Formula(
            title: "角速度と速さ",
            latex: "v = r\\omega",
            summary: "円運動する物体の速さは半径と角速度の積。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "速さ [m/s]"),
                FormulaSymbol(symbol: "r", description: "半径 [m]"),
                FormulaSymbol(symbol: "\\omega", description: "角速度 [rad/s]")
            ],
            conditions: "等速円運動のとき成立する。",
            relatedFormulaIDs: [centripetal.id],
            subcategory: "力と運動",
            examTag: .common,
            example: "r=0.4 m、ω=5 rad/s。速さは？→ v = 0.4×5 = 2.0 m/s"
        )
        let restitution = Formula(
            title: "反発係数（はね返り係数）",
            latex: "e = -\\frac{v_1' - v_2'}{v_1 - v_2}",
            summary: "衝突前後の相対速度の比。e=1 が弾性衝突、e=0 が完全非弾性衝突。",
            symbols: [
                FormulaSymbol(symbol: "e", description: "反発係数（無次元、0 ≤ e ≤ 1）"),
                FormulaSymbol(symbol: "v_1, v_2", description: "衝突前の速度 [m/s]"),
                FormulaSymbol(symbol: "v_1', v_2'", description: "衝突後の速度 [m/s]")
            ],
            conditions: "一直線上の衝突で成立する。",
            relatedFormulaIDs: [momentum.id],
            subcategory: "力と運動",
            examTag: .advanced,
            example: "v₁=4 m/s, v₂=0 → v₁'=1, v₂'=3 m/s。反発係数は？→ e = (3−1)/(4−0) = 0.5"
        )
        let hydropressure = Formula(
            title: "水圧",
            latex: "p = p_0 + \\rho h g",
            summary: "深さ h での圧力は大気圧に液体の圧力を加えた値。",
            symbols: [
                FormulaSymbol(symbol: "p", description: "深さ h での圧力 [Pa]"),
                FormulaSymbol(symbol: "p_0", description: "大気圧 [Pa]"),
                FormulaSymbol(symbol: "\\rho", description: "液体の密度 [kg/m³]"),
                FormulaSymbol(symbol: "h", description: "深さ [m]"),
                FormulaSymbol(symbol: "g", description: "重力加速度 [m/s²]")
            ],
            conditions: "静止した液体中で成立する。",
            subcategory: "力と運動",
            examTag: .common,
            example: "水中 3 m（大気圧 1.0×10⁵ Pa、ρ=1000、g=10）。圧力は？→ p = 1.3×10⁵ Pa"
        )
        let buoyancy = Formula(
            title: "浮力（アルキメデスの原理）",
            latex: "F = \\rho V g",
            summary: "流体中の物体が受ける上向きの力は、排除した流体の重さに等しい。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "浮力 [N]"),
                FormulaSymbol(symbol: "\\rho", description: "流体の密度 [kg/m³]"),
                FormulaSymbol(symbol: "V", description: "排除した流体の体積 [m³]"),
                FormulaSymbol(symbol: "g", description: "重力加速度 ≈ 9.8 [m/s²]")
            ],
            conditions: "静止した流体中の物体に成立する。",
            subcategory: "力と運動",
            examTag: .common,
            example: "V=2×10⁻³ m³、ρ=1000 kg/m³（g=10）。浮力は？→ F = 20 N"
        )
        let gravitation = Formula(
            title: "万有引力の法則",
            latex: "F = G\\frac{m_1 m_2}{r^2}",
            summary: "二つの質量の間に働く引力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "引力 [N]"),
                FormulaSymbol(symbol: "G", description: "万有引力定数 ≈ 6.67×10⁻¹¹ [N·m²/kg²]"),
                FormulaSymbol(symbol: "m_1, m_2", description: "各質量 [kg]"),
                FormulaSymbol(symbol: "r", description: "質量間の距離 [m]")
            ],
            conditions: "質点同士、または球対称な物体間で成立する。",
            subcategory: "力と運動",
            examTag: .common,
            example: "M=6×10²⁴ kg、m=1 kg、r=6.4×10⁶ m。引力は？→ F ≈ 9.8 N（= mg）"
        )
        let firstCosmicVelocity = Formula(
            title: "第1宇宙速度",
            latex: "v = \\sqrt{gR}",
            summary: "地表すれすれに人工衛星を周回させるために必要な最小速度。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "第1宇宙速度 [m/s]"),
                FormulaSymbol(symbol: "g", description: "重力加速度 ≈ 9.8 [m/s²]"),
                FormulaSymbol(symbol: "R", description: "地球の半径 ≈ 6.4×10⁶ [m]")
            ],
            conditions: "地球を均質な球体と仮定したとき成立する。",
            relatedFormulaIDs: [gravitation.id, centripetal.id],
            subcategory: "力と運動",
            examTag: .advanced,
            example: "g=9.8 m/s²、R=6.4×10⁶ m。第 1 宇宙速度は？→ v = √(9.8×6.4×10⁶) ≈ 7.9×10³ m/s"
        )
        let kepler = Formula(
            title: "ケプラーの第3法則",
            latex: "T^2 = \\frac{4\\pi^2}{GM}r^3",
            summary: "惑星・衛星の公転周期の2乗は軌道半径の3乗に比例する。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "公転周期 [s]"),
                FormulaSymbol(symbol: "G", description: "万有引力定数 ≈ 6.67×10⁻¹¹ [N·m²/kg²]"),
                FormulaSymbol(symbol: "M", description: "中心天体の質量 [kg]"),
                FormulaSymbol(symbol: "r", description: "軌道半径 [m]")
            ],
            conditions: "円軌道の場合に厳密に成立する。楕円軌道では r を半長軸とする。",
            relatedFormulaIDs: [gravitation.id, centripetal.id],
            subcategory: "力と運動",
            examTag: .common,
            example: "地球（GM=4.0×10¹⁴）の周りを r=4×10⁷ m で周回する衛星の周期は？→ T = 2π√(r³/GM) ≈ 3.6×10⁴ s"
        )
        // 仕事とエネルギー
        let work = Formula(
            title: "仕事",
            latex: "W = Fs\\cos\\theta",
            summary: "力の変位方向成分と変位の積。",
            symbols: [
                FormulaSymbol(symbol: "W", description: "仕事 [J]"),
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "s", description: "変位 [m]"),
                FormulaSymbol(symbol: "\\theta", description: "力と変位のなす角 [rad]")
            ],
            conditions: "力が一定のとき成立する。",
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "F=10 N、s=5 m、θ=60°。仕事は？→ W = 10×5×cos60° = 25 J"
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
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "m=4 kg、v=10 m/s。運動エネルギーは？→ K = ½×4×100 = 200 J"
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
            relatedFormulaIDs: [kineticEnergy.id, momentum.id],
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "h=20 m から静止して落下（g=10）。地面直前の速さは？→ mgh=½mv² → v = 20 m/s"
        )
        let gravitationalPE = Formula(
            title: "重力による位置エネルギー",
            latex: "U = mgh",
            summary: "高さ h にある質量 m の物体が持つ重力による位置エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "位置エネルギー [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "g", description: "重力加速度 ≈ 9.8 [m/s²]"),
                FormulaSymbol(symbol: "h", description: "基準点からの高さ [m]")
            ],
            conditions: "重力加速度が一定とみなせる範囲で成立する。",
            relatedFormulaIDs: [kineticEnergy.id],
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "m=2 kg、h=5 m（g=9.8）。位置エネルギーは？→ U = 2×9.8×5 = 98 J"
        )
        let elasticPE = Formula(
            title: "弾性位置エネルギー",
            latex: "U = \\frac{1}{2}kx^2",
            summary: "変形量 x のばねに蓄えられる弾性エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "弾性位置エネルギー [J]"),
                FormulaSymbol(symbol: "k", description: "ばね定数 [N/m]"),
                FormulaSymbol(symbol: "x", description: "変形量 [m]")
            ],
            conditions: "弾性限界内（フックの法則が成立する範囲）で成立する。",
            relatedFormulaIDs: [hooke.id, kineticEnergy.id],
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "k=400 N/m、x=0.10 m。弾性エネルギーは？→ U = ½×400×0.01 = 2 J"
        )
        let gravitationalPEU = Formula(
            title: "万有引力による位置エネルギー",
            latex: "U = -G\\frac{Mm}{r}",
            summary: "無限遠を基準としたときの万有引力による位置エネルギー（負の値）。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "位置エネルギー [J]"),
                FormulaSymbol(symbol: "G", description: "万有引力定数 [N·m²/kg²]"),
                FormulaSymbol(symbol: "M", description: "中心天体の質量 [kg]"),
                FormulaSymbol(symbol: "m", description: "物体の質量 [kg]"),
                FormulaSymbol(symbol: "r", description: "中心からの距離 [m]")
            ],
            conditions: "無限遠で U=0 となる基準で成立する。",
            relatedFormulaIDs: [gravitation.id],
            subcategory: "仕事とエネルギー",
            examTag: .advanced,
            example: "G=6.67×10⁻¹¹、M=6×10²⁴ kg、m=1 kg、r=6.4×10⁶ m。U は？→ U = −GMm/r ≈ −6.3×10⁷ J"
        )
        let mechanicalPower = Formula(
            title: "仕事率（パワー）",
            latex: "P = Fv",
            summary: "単位時間あたりの仕事。力と速度の積で表される。",
            symbols: [
                FormulaSymbol(symbol: "P", description: "仕事率 [W]"),
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "v", description: "速さ [m/s]")
            ],
            conditions: "力と速度が同方向のとき成立する。",
            relatedFormulaIDs: [work.id],
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "F=50 N、v=2 m/s。仕事率は？→ P = 50×2 = 100 W"
        )
        let moment = Formula(
            title: "力のモーメント",
            latex: "M = Fl",
            summary: "力の大きさと腕の長さの積。回転効果を表す。",
            symbols: [
                FormulaSymbol(symbol: "M", description: "力のモーメント [N·m]"),
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "l", description: "腕の長さ（回転軸から力の作用線までの距離） [m]")
            ],
            conditions: "剛体の回転を考えるとき使う。",
            subcategory: "仕事とエネルギー",
            examTag: .common,
            example: "力 20 N、腕の長さ 0.5 m。力のモーメントは？→ M = 20×0.5 = 10 N·m"
        )
        // ばね・振動
        let springSerial = Formula(
            title: "直列ばねの合成",
            latex: "\\frac{1}{K} = \\frac{1}{k_1} + \\frac{1}{k_2}",
            summary: "直列につないだばね全体のばね定数。",
            symbols: [
                FormulaSymbol(symbol: "K", description: "合成ばね定数 [N/m]"),
                FormulaSymbol(symbol: "k_1, k_2", description: "各ばね定数 [N/m]")
            ],
            conditions: "ばねの質量を無視するとき成立する。",
            relatedFormulaIDs: [hooke.id],
            subcategory: "ばね・振動",
            examTag: .advanced,
            example: "k₁=100 N/m、k₂=400 N/m の直列合成は？→ 1/K = 1/100+1/400=5/400 → K = 80 N/m"
        )
        let springParallel = Formula(
            title: "並列ばねの合成",
            latex: "K = k_1 + k_2",
            summary: "並列につないだばね全体のばね定数。",
            symbols: [
                FormulaSymbol(symbol: "K", description: "合成ばね定数 [N/m]"),
                FormulaSymbol(symbol: "k_1, k_2", description: "各ばね定数 [N/m]")
            ],
            conditions: "ばねの質量を無視するとき成立する。",
            relatedFormulaIDs: [hooke.id],
            subcategory: "ばね・振動",
            examTag: .advanced,
            example: "k₁=100 N/m、k₂=400 N/m の並列合成は？→ K = 100+400 = 500 N/m"
        )
        let springPendulum = Formula(
            title: "ばね振り子の周期",
            latex: "T = 2\\pi\\sqrt{\\frac{m}{k}}",
            summary: "質量 m のおもりがばね定数 k のばねで振動するときの周期。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "k", description: "ばね定数 [N/m]")
            ],
            conditions: "単振動（振幅が小さい）のとき成立する。",
            relatedFormulaIDs: [hooke.id],
            subcategory: "ばね・振動",
            examTag: .common,
            example: "m=1 kg、k=π² N/m のばね振り子の周期は？→ T = 2π√(1/π²) = 2 s"
        )
        let shm = Formula(
            title: "単振動の変位",
            latex: "x = A\\sin(\\omega t + \\phi_0)",
            summary: "単振動（SHM）での物体の変位を時刻 t の関数として表す式。",
            symbols: [
                FormulaSymbol(symbol: "x", description: "変位 [m]"),
                FormulaSymbol(symbol: "A", description: "振幅 [m]"),
                FormulaSymbol(symbol: "\\omega", description: "角振動数 [rad/s]"),
                FormulaSymbol(symbol: "t", description: "時刻 [s]"),
                FormulaSymbol(symbol: "\\phi_0", description: "初期位相 [rad]")
            ],
            conditions: "復元力が変位に比例する系（フックの法則等）で成立する。",
            relatedFormulaIDs: [springPendulum.id],
            subcategory: "ばね・振動",
            examTag: .advanced,
            example: "A=0.1 m、ω=2π rad/s。t=0.25 s での変位は？→ x = 0.1×sin(π/2) = 0.10 m"
        )
        let pendulum = Formula(
            title: "単振り子の周期",
            latex: "T = 2\\pi\\sqrt{\\frac{l}{g}}",
            summary: "長さ l の糸に吊るしたおもりの振動周期。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "l", description: "糸の長さ [m]"),
                FormulaSymbol(symbol: "g", description: "重力加速度 ≈ 9.8 [m/s²]")
            ],
            conditions: "振幅が小さい（sin θ ≈ θ）とき成立する。",
            relatedFormulaIDs: [springPendulum.id],
            subcategory: "ばね・振動",
            examTag: .common,
            example: "l=1 m（g=9.8 m/s²）の単振り子の周期は？→ T = 2π√(1/9.8) ≈ 2.0 s"
        )

        return FormulaCategory(
            name: "力学",
            icon: "arrow.up.right.circle",
            formulas: [
                newton, hooke, friction,
                velocityKinematics, displacement, velocitySquared,
                momentum, restitution, centripetal, angularVelocity,
                pressure, hydropressure, buoyancy, gravitation, firstCosmicVelocity, kepler,
                work, gravitationalPE, elasticPE, gravitationalPEU, mechanicalPower, kineticEnergy, energy, moment,
                springSerial, springParallel, springPendulum, shm, pendulum
            ]
        )
    }()
}

// MARK: - 電磁気学
extension FormulaCategory {
    static let sampleElectromagnetism: FormulaCategory = {
        // 静電気
        let coulomb = Formula(
            title: "クーロンの法則",
            latex: "F = k\\frac{q_1 q_2}{r^2}",
            summary: "二つの点電荷の間に働く静電気力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "静電気力 [N]"),
                FormulaSymbol(symbol: "k", description: "クーロン定数 ≈ 9×10⁹ [N·m²/C²]"),
                FormulaSymbol(symbol: "q_1, q_2", description: "各電荷 [C]"),
                FormulaSymbol(symbol: "r", description: "距離 [m]")
            ],
            conditions: "真空中の点電荷間で成立する。",
            subcategory: "静電気",
            examTag: .common,
            example: "q₁=q₂=1×10⁻⁶ C、r=0.30 m。静電気力は？→ F = 9×10⁹×10⁻¹²/0.09 = 0.10 N"
        )
        let electricField = Formula(
            title: "点電荷による電場",
            latex: "E = k\\frac{q}{r^2}",
            summary: "点電荷 q から距離 r の位置の電場の強さ。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "電場の強さ [N/C]"),
                FormulaSymbol(symbol: "k", description: "クーロン定数 [N·m²/C²]"),
                FormulaSymbol(symbol: "q", description: "点電荷 [C]"),
                FormulaSymbol(symbol: "r", description: "距離 [m]")
            ],
            conditions: "真空中で成立する。",
            relatedFormulaIDs: [coulomb.id],
            subcategory: "静電気",
            examTag: .common,
            example: "q=2×10⁻⁶ C、r=0.30 m。電場の強さは？→ E = 9×10⁹×2×10⁻⁶/0.09 = 2×10⁵ N/C"
        )
        let electricPotential = Formula(
            title: "点電荷による電位",
            latex: "V = k\\frac{q}{r}",
            summary: "点電荷 q から距離 r の位置の電位。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "電位 [V]"),
                FormulaSymbol(symbol: "k", description: "クーロン定数 [N·m²/C²]"),
                FormulaSymbol(symbol: "q", description: "点電荷 [C]"),
                FormulaSymbol(symbol: "r", description: "距離 [m]")
            ],
            conditions: "真空中で成立する。",
            relatedFormulaIDs: [electricField.id],
            subcategory: "静電気",
            examTag: .advanced,
            example: "q=3×10⁻⁶ C、r=0.90 m。電位は？→ V = 9×10⁹×3×10⁻⁶/0.9 = 3×10⁴ V"
        )
        let capacitance = Formula(
            title: "コンデンサーの電荷",
            latex: "Q = CV",
            summary: "コンデンサーに蓄えられる電荷。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "電荷 [C]"),
                FormulaSymbol(symbol: "C", description: "電気容量 [F]"),
                FormulaSymbol(symbol: "V", description: "電圧 [V]")
            ],
            conditions: "平行板コンデンサーで近似的に成立する。",
            subcategory: "静電気",
            examTag: .common,
            example: "C=10 μF、V=100 V。蓄えられる電荷は？→ Q = 10⁻⁵×100 = 1.0×10⁻³ C"
        )
        let capacitorEnergy = Formula(
            title: "コンデンサーの静電エネルギー",
            latex: "U = \\frac{1}{2}CV^2 = \\frac{Q^2}{2C}",
            summary: "コンデンサーに蓄えられるエネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "静電エネルギー [J]"),
                FormulaSymbol(symbol: "C", description: "電気容量 [F]"),
                FormulaSymbol(symbol: "V", description: "電圧 [V]"),
                FormulaSymbol(symbol: "Q", description: "電荷 [C]")
            ],
            conditions: "理想コンデンサーで成立する。",
            relatedFormulaIDs: [capacitance.id],
            subcategory: "静電気",
            examTag: .advanced,
            example: "C=10 μF、V=100 V。静電エネルギーは？→ U = ½×10⁻⁵×10⁴ = 0.05 J"
        )
        let parallelPlateC = Formula(
            title: "平行板コンデンサーの電気容量",
            latex: "C = \\varepsilon_0\\frac{S}{d}",
            summary: "向かい合う2枚の板の面積と間隔で決まる電気容量。",
            symbols: [
                FormulaSymbol(symbol: "C", description: "電気容量 [F]"),
                FormulaSymbol(symbol: "\\varepsilon_0", description: "真空の誘電率 ≈ 8.85×10⁻¹² [F/m]"),
                FormulaSymbol(symbol: "S", description: "極板の面積 [m²]"),
                FormulaSymbol(symbol: "d", description: "極板間の距離 [m]")
            ],
            conditions: "極板間隔 d が極板の大きさに比べて十分小さいとき成立する。誘電体を挟む場合は ε₀ → ε₀εᵣ。",
            relatedFormulaIDs: [capacitance.id],
            subcategory: "静電気",
            examTag: .common,
            example: "S=1×10⁻² m²、d=1×10⁻³ m。電気容量は？→ C = 8.85×10⁻¹²×0.01/0.001 = 88.5 pF"
        )
        // 電流と回路
        let current = Formula(
            title: "電流",
            latex: "I = \\frac{q}{t}",
            summary: "単位時間あたりに通過する電荷量。",
            symbols: [
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "q", description: "電荷 [C]"),
                FormulaSymbol(symbol: "t", description: "時間 [s]")
            ],
            conditions: "定常電流のとき成立する。",
            subcategory: "電流と回路",
            examTag: .common,
            example: "10 s 間に 20 C の電荷が流れた。電流は？→ I = 20/10 = 2 A"
        )
        let ohm = Formula(
            title: "オームの法則",
            latex: "V = RI",
            summary: "導体の両端の電圧は電流と抵抗の積に等しい。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "電圧 [V]"),
                FormulaSymbol(symbol: "R", description: "抵抗 [Ω]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]")
            ],
            conditions: "オーム性導体（線形素子）で成立する。",
            relatedFormulaIDs: [current.id],
            subcategory: "電流と回路",
            examTag: .common,
            example: "R=50 Ω、I=0.4 A。電圧は？→ V = 50×0.4 = 20 V"
        )
        let resistivity = Formula(
            title: "抵抗率",
            latex: "R = \\rho\\frac{l}{S}",
            summary: "導体の抵抗は長さに比例し断面積に反比例する。",
            symbols: [
                FormulaSymbol(symbol: "R", description: "抵抗 [Ω]"),
                FormulaSymbol(symbol: "\\rho", description: "抵抗率 [Ω·m]"),
                FormulaSymbol(symbol: "l", description: "長さ [m]"),
                FormulaSymbol(symbol: "S", description: "断面積 [m²]")
            ],
            conditions: "均一な導体で成立する。",
            subcategory: "電流と回路",
            examTag: .common,
            example: "ρ=1.7×10⁻⁸ Ω·m、l=2 m、S=1×10⁻⁶ m²。抵抗は？→ R = 0.034 Ω"
        )
        let power = Formula(
            title: "電力",
            latex: "P = IV = I^2R = \\frac{V^2}{R}",
            summary: "単位時間あたりに消費される電気エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "P", description: "電力 [W]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "V", description: "電圧 [V]"),
                FormulaSymbol(symbol: "R", description: "抵抗 [Ω]")
            ],
            conditions: "オーム性負荷で成立する。",
            relatedFormulaIDs: [ohm.id],
            subcategory: "電流と回路",
            examTag: .common,
            example: "I=3 A、V=100 V。電力は？→ P = 300 W"
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
            relatedFormulaIDs: [ohm.id, power.id],
            subcategory: "電流と回路",
            examTag: .common,
            example: "I=2 A、R=5 Ω、t=10 s。発熱量は？→ Q = 4×5×10 = 200 J"
        )
        let emf = Formula(
            title: "起電力と内部抵抗",
            latex: "V = E - rI",
            summary: "電池の端子電圧は起電力から内部抵抗での電圧降下を引いた値。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "端子電圧 [V]"),
                FormulaSymbol(symbol: "E", description: "起電力 [V]"),
                FormulaSymbol(symbol: "r", description: "内部抵抗 [Ω]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]")
            ],
            conditions: "電流が流れているとき成立する。",
            relatedFormulaIDs: [ohm.id],
            subcategory: "電流と回路",
            examTag: .common,
            example: "起電力 9 V、内部抵抗 1 Ω、I=2 A。端子電圧は？→ V = 9−1×2 = 7 V"
        )
        let kirchhoff = Formula(
            title: "キルヒホッフの法則",
            latex: "\\sum I = 0 \\quad;\\quad \\sum\\mathcal{E} = \\sum RI",
            summary: "第1法則：接続点での電流の和はゼロ。第2法則：閉回路での起電力の和は電圧降下の和に等しい。",
            symbols: [
                FormulaSymbol(symbol: "\\sum I", description: "接続点に流入・流出する電流の代数和"),
                FormulaSymbol(symbol: "\\sum\\mathcal{E}", description: "閉回路内の起電力の和 [V]"),
                FormulaSymbol(symbol: "\\sum RI", description: "閉回路内の電圧降下の和 [V]")
            ],
            conditions: "定常電流の回路に成立する。電流の向きと一致する場合を正とする。",
            relatedFormulaIDs: [ohm.id, emf.id],
            subcategory: "電流と回路",
            examTag: .common,
            example: "起電力 E₁=12 V、E₂=6 V、抵抗 R₁=2 Ω、R₂=4 Ω の直列回路。電流は？→ I = (12−6)/(2+4) = 1 A"
        )
        // 磁気
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
            conditions: "v⊥B のとき F = qvB となる。",
            subcategory: "磁気",
            examTag: .common,
            example: "q=1.6×10⁻¹⁹ C、v=5×10⁶ m/s、B=0.2 T（垂直）。ローレンツ力は？→ F = 1.6×10⁻¹³ N"
        )
        let cyclotron = Formula(
            title: "磁場中の荷電粒子の円運動半径",
            latex: "r = \\frac{mv}{qB}",
            summary: "磁場に垂直に入射した荷電粒子はローレンツ力を向心力として等速円運動する。",
            symbols: [
                FormulaSymbol(symbol: "r", description: "円運動の半径 [m]"),
                FormulaSymbol(symbol: "m", description: "粒子の質量 [kg]"),
                FormulaSymbol(symbol: "v", description: "粒子の速さ [m/s]"),
                FormulaSymbol(symbol: "q", description: "粒子の電荷 [C]"),
                FormulaSymbol(symbol: "B", description: "磁束密度 [T]")
            ],
            conditions: "v⊥B のとき成立する。電場なし、粒子の速さは変化しない。",
            relatedFormulaIDs: [lorentz.id],
            subcategory: "磁気",
            examTag: .common,
            example: "電子（m=9.1×10⁻³¹ kg、q=1.6×10⁻¹⁹ C）が v=2×10⁷ m/s、B=0.1 T 中で円運動。r は？→ r = 9.1×10⁻³¹×2×10⁷/(1.6×10⁻¹⁹×0.1) ≈ 1.1 mm"
        )
        let wireForce = Formula(
            title: "電流が磁場から受ける力",
            latex: "F = BIl\\sin\\theta",
            summary: "磁場中の電流に働く力。",
            symbols: [
                FormulaSymbol(symbol: "F", description: "力 [N]"),
                FormulaSymbol(symbol: "B", description: "磁束密度 [T]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]"),
                FormulaSymbol(symbol: "l", description: "導線の長さ [m]"),
                FormulaSymbol(symbol: "\\theta", description: "電流と磁場のなす角 [rad]")
            ],
            conditions: "I⊥B のとき F = BIl となる。",
            relatedFormulaIDs: [lorentz.id],
            subcategory: "磁気",
            examTag: .common,
            example: "B=0.5 T、I=3 A、l=0.2 m（垂直）。力は？→ F = 0.5×3×0.2 = 0.30 N"
        )
        let faraday = Formula(
            title: "ファラデーの電磁誘導の法則",
            latex: "V = -N\\frac{\\Delta\\Phi}{\\Delta t}",
            summary: "コイルを貫く磁束の変化率に比例した起電力が誘導される。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "誘導起電力 [V]"),
                FormulaSymbol(symbol: "N", description: "巻き数"),
                FormulaSymbol(symbol: "\\Delta\\Phi", description: "磁束の変化量 [Wb]"),
                FormulaSymbol(symbol: "\\Delta t", description: "時間の変化量 [s]")
            ],
            conditions: "負符号はレンツの法則を表す。",
            relatedFormulaIDs: [lorentz.id],
            subcategory: "磁気",
            examTag: .common,
            example: "N=100 巻、ΔΦ=0.02 Wb、Δt=0.1 s。誘導起電力は？→ |V| = 100×0.02/0.1 = 20 V"
        )
        let selfInduction = Formula(
            title: "自己誘導",
            latex: "V = -L\\frac{\\Delta I}{\\Delta t}",
            summary: "コイル自身の電流変化によって生じる誘導起電力。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "誘導起電力 [V]"),
                FormulaSymbol(symbol: "L", description: "自己インダクタンス [H]"),
                FormulaSymbol(symbol: "\\Delta I", description: "電流の変化量 [A]"),
                FormulaSymbol(symbol: "\\Delta t", description: "時間の変化量 [s]")
            ],
            conditions: "インダクタンスが一定のとき成立する。",
            relatedFormulaIDs: [faraday.id],
            subcategory: "磁気",
            examTag: .advanced,
            example: "L=0.2 H、ΔI=4 A、Δt=0.1 s。誘導起電力は？→ |V| = 0.2×4/0.1 = 8 V"
        )
        let motionalEMF = Formula(
            title: "導線が動くことで生じる誘導起電力",
            latex: "V = vBl",
            summary: "磁場 B 中を速さ v で動く長さ l の導線に生じる誘導起電力。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "誘導起電力 [V]"),
                FormulaSymbol(symbol: "v", description: "導線の速さ [m/s]"),
                FormulaSymbol(symbol: "B", description: "磁束密度 [T]"),
                FormulaSymbol(symbol: "l", description: "有効な導線の長さ [m]")
            ],
            conditions: "v、B、l がすべて互いに垂直のとき最大値となる。",
            relatedFormulaIDs: [faraday.id, lorentz.id],
            subcategory: "磁気",
            examTag: .common,
            example: "v=5 m/s、B=0.4 T、l=0.5 m。誘導起電力は？→ V = 5×0.4×0.5 = 1.0 V"
        )
        let coilEnergy = Formula(
            title: "コイルのエネルギー",
            latex: "U = \\frac{1}{2}LI^2",
            summary: "コイルに蓄えられる磁気エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "磁気エネルギー [J]"),
                FormulaSymbol(symbol: "L", description: "自己インダクタンス [H]"),
                FormulaSymbol(symbol: "I", description: "電流 [A]")
            ],
            conditions: "インダクタンスが一定のとき成立する。",
            relatedFormulaIDs: [selfInduction.id],
            subcategory: "磁気",
            examTag: .advanced,
            example: "L=0.5 H、I=4 A。磁気エネルギーは？→ U = ½×0.5×16 = 4 J"
        )
        // 交流
        let reactanceL = Formula(
            title: "コイルの誘導リアクタンス",
            latex: "X_L = \\omega L",
            summary: "コイルが交流に対して示す抵抗的な効果。",
            symbols: [
                FormulaSymbol(symbol: "X_L", description: "誘導リアクタンス [Ω]"),
                FormulaSymbol(symbol: "\\omega", description: "角周波数 [rad/s]"),
                FormulaSymbol(symbol: "L", description: "自己インダクタンス [H]")
            ],
            conditions: "正弦波交流で成立する。",
            subcategory: "交流",
            examTag: .advanced,
            example: "L=0.1 H、f=50 Hz（ω=100π rad/s）。誘導リアクタンスは？→ XL = 100π×0.1 ≈ 31.4 Ω"
        )
        let reactanceC = Formula(
            title: "コンデンサーの容量リアクタンス",
            latex: "X_C = \\frac{1}{\\omega C}",
            summary: "コンデンサーが交流に対して示す抵抗的な効果。",
            symbols: [
                FormulaSymbol(symbol: "X_C", description: "容量リアクタンス [Ω]"),
                FormulaSymbol(symbol: "\\omega", description: "角周波数 [rad/s]"),
                FormulaSymbol(symbol: "C", description: "電気容量 [F]")
            ],
            conditions: "正弦波交流で成立する。",
            subcategory: "交流",
            examTag: .advanced,
            example: "C=100 μF、f=50 Hz（ω=100π）。容量リアクタンスは？→ XC = 1/(100π×10⁻⁴) ≈ 31.8 Ω"
        )
        let impedance = Formula(
            title: "インピーダンス",
            latex: "Z = \\sqrt{R^2 + (X_L - X_C)^2}",
            summary: "RLC回路の交流に対する合成抵抗。",
            symbols: [
                FormulaSymbol(symbol: "Z", description: "インピーダンス [Ω]"),
                FormulaSymbol(symbol: "R", description: "抵抗 [Ω]"),
                FormulaSymbol(symbol: "X_L", description: "誘導リアクタンス [Ω]"),
                FormulaSymbol(symbol: "X_C", description: "容量リアクタンス [Ω]")
            ],
            conditions: "直列RLC回路で成立する。",
            relatedFormulaIDs: [reactanceL.id, reactanceC.id],
            subcategory: "交流",
            examTag: .advanced,
            example: "R=30 Ω、XL=40 Ω、XC=0。インピーダンスは？→ Z = √(900+1600) = 50 Ω"
        )
        let resonance = Formula(
            title: "共振周波数",
            latex: "f_0 = \\frac{1}{2\\pi\\sqrt{LC}}",
            summary: "RLC回路が共振するときの周波数。",
            symbols: [
                FormulaSymbol(symbol: "f_0", description: "共振周波数 [Hz]"),
                FormulaSymbol(symbol: "L", description: "自己インダクタンス [H]"),
                FormulaSymbol(symbol: "C", description: "電気容量 [F]")
            ],
            conditions: "X_L = X_C となる周波数。",
            relatedFormulaIDs: [impedance.id],
            subcategory: "交流",
            examTag: .advanced,
            example: "L=0.1 H、C=10 μF。共振周波数は？→ f₀ = 1/(2π√10⁻⁶) ≈ 159 Hz"
        )
        let acEffective = Formula(
            title: "交流の実効値",
            latex: "V_e = \\frac{V_0}{\\sqrt{2}},\\quad I_e = \\frac{I_0}{\\sqrt{2}}",
            summary: "正弦波交流の実効値は最大値を √2 で割った値。",
            symbols: [
                FormulaSymbol(symbol: "V_e", description: "電圧の実効値 [V]"),
                FormulaSymbol(symbol: "V_0", description: "電圧の最大値（振幅） [V]"),
                FormulaSymbol(symbol: "I_e", description: "電流の実効値 [A]"),
                FormulaSymbol(symbol: "I_0", description: "電流の最大値（振幅） [A]")
            ],
            conditions: "正弦波交流のみに成立する。",
            subcategory: "交流",
            examTag: .common,
            example: "交流電圧の最大値が 141 V。実効値は？→ Ve = 141/√2 ≈ 100 V"
        )
        let transformer = Formula(
            title: "変圧器",
            latex: "\\frac{V_1}{V_2} = \\frac{N_1}{N_2}",
            summary: "一次側と二次側の電圧比は巻き数比に等しい。",
            symbols: [
                FormulaSymbol(symbol: "V_1, V_2", description: "一次・二次側の電圧 [V]"),
                FormulaSymbol(symbol: "N_1, N_2", description: "一次・二次側の巻き数")
            ],
            conditions: "理想変圧器（損失なし）で成立する。",
            relatedFormulaIDs: [faraday.id],
            subcategory: "交流",
            examTag: .common,
            example: "N₁=100 巻、N₂=500 巻、V₁=100 V。二次側電圧は？→ V₂ = 500 V"
        )

        return FormulaCategory(
            name: "電磁気学",
            icon: "bolt.circle",
            formulas: [
                coulomb, electricField, electricPotential, capacitance, parallelPlateC, capacitorEnergy,
                current, ohm, resistivity, power, joule, emf, kirchhoff,
                lorentz, cyclotron, wireForce, faraday, motionalEMF, selfInduction, coilEnergy,
                reactanceL, reactanceC, impedance, resonance, acEffective, transformer
            ]
        )
    }()
}

// MARK: - 熱力学
extension FormulaCategory {
    static let sampleThermodynamics: FormulaCategory = {
        // 熱と温度
        let specificHeat = Formula(
            title: "熱量と比熱",
            latex: "Q = mc\\Delta T",
            summary: "物質の温度を変化させるのに必要な熱量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "熱量 [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "c", description: "比熱 [J/(kg·K)]"),
                FormulaSymbol(symbol: "\\Delta T", description: "温度変化 [K]")
            ],
            conditions: "相変化がない範囲で成立する。",
            subcategory: "熱と温度",
            examTag: .common,
            example: "m=2 kg、c=4200 J/(kg·K)、ΔT=5 K。熱量は？→ Q = 2×4200×5 = 42000 J"
        )
        let heatCapacity = Formula(
            title: "熱容量",
            latex: "Q = C\\Delta T",
            summary: "熱容量 C の物体の温度を ΔT 変化させるのに必要な熱量。",
            symbols: [
                FormulaSymbol(symbol: "Q", description: "熱量 [J]"),
                FormulaSymbol(symbol: "C", description: "熱容量 [J/K]"),
                FormulaSymbol(symbol: "\\Delta T", description: "温度変化 [K]")
            ],
            conditions: "熱容量 C = mc（質量×比熱）。相変化がない範囲で成立する。",
            relatedFormulaIDs: [specificHeat.id],
            subcategory: "熱と温度",
            examTag: .common,
            example: "C=840 J/K、ΔT=10 K。熱量は？→ Q = 840×10 = 8400 J"
        )
        // 気体の法則
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
            subcategory: "気体の法則",
            examTag: .common,
            example: "n=2 mol、T=300 K、V=0.02 m³。圧力は？→ P = 2×8.314×300/0.02 ≈ 2.5×10⁵ Pa"
        )
        let boyleCharles = Formula(
            title: "ボイル・シャルルの法則",
            latex: "\\frac{PV}{T} = \\mathrm{const.}",
            summary: "物質量が一定のとき PV/T は一定。",
            symbols: [
                FormulaSymbol(symbol: "P", description: "圧力 [Pa]"),
                FormulaSymbol(symbol: "V", description: "体積 [m³]"),
                FormulaSymbol(symbol: "T", description: "絶対温度 [K]")
            ],
            conditions: "物質量が一定の理想気体で成立する。",
            relatedFormulaIDs: [idealGas.id],
            subcategory: "気体の法則",
            examTag: .common,
            example: "P₁=1×10⁵ Pa、V₁=2 L、T₁=300 K → T₂=600 K、P₂=2×10⁵ Pa。V₂ は？→ 2 L"
        )
        let boyle = Formula(
            title: "ボイルの法則",
            latex: "P_1 V_1 = P_2 V_2",
            summary: "温度一定のとき、気体の圧力と体積の積は一定。",
            symbols: [
                FormulaSymbol(symbol: "P_1, P_2", description: "変化前後の圧力 [Pa]"),
                FormulaSymbol(symbol: "V_1, V_2", description: "変化前後の体積 [m³]")
            ],
            conditions: "温度一定（等温変化）で成立する。",
            relatedFormulaIDs: [boyleCharles.id],
            subcategory: "気体の法則",
            examTag: .common,
            example: "P₁=1×10⁵ Pa、V₁=4 L、T 一定。P₂=2×10⁵ Pa のとき V₂ は？→ V₂ = 2 L"
        )
        let charles = Formula(
            title: "シャルルの法則",
            latex: "\\frac{V_1}{T_1} = \\frac{V_2}{T_2}",
            summary: "圧力一定のとき、体積は絶対温度に比例する。",
            symbols: [
                FormulaSymbol(symbol: "V_1, V_2", description: "変化前後の体積 [m³]"),
                FormulaSymbol(symbol: "T_1, T_2", description: "変化前後の絶対温度 [K]")
            ],
            conditions: "圧力一定（等圧変化）で成立する。",
            relatedFormulaIDs: [boyleCharles.id],
            subcategory: "気体の法則",
            examTag: .common,
            example: "V₁=3 L、T₁=300 K、P 一定。T₂=400 K のとき V₂ は？→ V₂ = 4 L"
        )
        // 気体分子運動論
        let kineticTheory = Formula(
            title: "気体分子の平均運動エネルギー",
            latex: "\\frac{1}{2}m\\overline{v^2} = \\frac{3}{2}kT",
            summary: "気体分子1個の平均運動エネルギーは絶対温度に比例する。",
            symbols: [
                FormulaSymbol(symbol: "m", description: "分子の質量 [kg]"),
                FormulaSymbol(symbol: "\\overline{v^2}", description: "速度の2乗平均 [m²/s²]"),
                FormulaSymbol(symbol: "k", description: "ボルツマン定数 ≈ 1.38×10⁻²³ [J/K]"),
                FormulaSymbol(symbol: "T", description: "絶対温度 [K]")
            ],
            conditions: "理想気体で成立する。",
            relatedFormulaIDs: [idealGas.id],
            subcategory: "気体分子運動論",
            examTag: .advanced,
            example: "T=300 K の理想気体分子 1 個の平均運動エネルギーは？→ ½mv² = 3/2×1.38×10⁻²³×300 ≈ 6.2×10⁻²¹ J"
        )
        let internalEnergy = Formula(
            title: "単原子理想気体の内部エネルギー",
            latex: "U = \\frac{3}{2}nRT",
            summary: "単原子理想気体の全内部エネルギー。",
            symbols: [
                FormulaSymbol(symbol: "U", description: "内部エネルギー [J]"),
                FormulaSymbol(symbol: "n", description: "物質量 [mol]"),
                FormulaSymbol(symbol: "R", description: "気体定数 [J/(mol·K)]"),
                FormulaSymbol(symbol: "T", description: "絶対温度 [K]")
            ],
            conditions: "単原子分子理想気体（He, Ar など）に限られる。",
            relatedFormulaIDs: [idealGas.id, kineticTheory.id],
            subcategory: "気体分子運動論",
            examTag: .advanced,
            example: "単原子理想気体 n=1 mol、T=400 K。内部エネルギーは？→ U = 3/2×8.314×400 ≈ 4990 J"
        )
        // 熱力学の法則
        let firstLaw = Formula(
            title: "熱力学第一法則",
            latex: "\\Delta U = Q - W",
            summary: "内部エネルギーの変化は吸収した熱量と外部にした仕事の差に等しい。",
            symbols: [
                FormulaSymbol(symbol: "\\Delta U", description: "内部エネルギーの変化 [J]"),
                FormulaSymbol(symbol: "Q", description: "吸収した熱量 [J]"),
                FormulaSymbol(symbol: "W", description: "外部にした仕事 [J]")
            ],
            conditions: "閉じた系に適用される。",
            relatedFormulaIDs: [internalEnergy.id],
            subcategory: "熱力学の法則",
            examTag: .common,
            example: "気体が Q=500 J 吸収し W=200 J の仕事をした。内部エネルギーの変化は？→ ΔU = 300 J"
        )
        let workByGas = Formula(
            title: "気体がする仕事",
            latex: "W = P\\Delta V",
            summary: "圧力一定のとき気体が膨張してする仕事。",
            symbols: [
                FormulaSymbol(symbol: "W", description: "仕事 [J]"),
                FormulaSymbol(symbol: "P", description: "圧力 [Pa]"),
                FormulaSymbol(symbol: "\\Delta V", description: "体積変化 [m³]")
            ],
            conditions: "等圧変化のとき成立する。",
            relatedFormulaIDs: [firstLaw.id],
            subcategory: "熱力学の法則",
            examTag: .common,
            example: "P=2×10⁵ Pa、ΔV=3×10⁻³ m³。気体がした仕事は？→ W = 600 J"
        )
        let molarHeatCv = Formula(
            title: "定積モル比熱（単原子分子）",
            latex: "C_V = \\frac{3}{2}R",
            summary: "体積一定のとき1molを1K上昇させるのに必要な熱量。",
            symbols: [
                FormulaSymbol(symbol: "C_V", description: "定積モル比熱 ≈ 12.5 [J/(mol·K)]"),
                FormulaSymbol(symbol: "R", description: "気体定数 [J/(mol·K)]")
            ],
            conditions: "単原子理想気体に限られる。",
            relatedFormulaIDs: [internalEnergy.id],
            subcategory: "熱力学の法則",
            examTag: .advanced,
            example: "単原子理想気体 n=1 mol を等積で ΔT=100 K 加熱。熱量は？→ Q = 3/2×8.314×100 ≈ 1247 J"
        )
        let molarHeatCp = Formula(
            title: "定圧モル比熱（単原子分子）",
            latex: "C_P = \\frac{5}{2}R",
            summary: "圧力一定のとき1molを1K上昇させるのに必要な熱量。",
            symbols: [
                FormulaSymbol(symbol: "C_P", description: "定圧モル比熱 ≈ 20.8 [J/(mol·K)]"),
                FormulaSymbol(symbol: "R", description: "気体定数 [J/(mol·K)]")
            ],
            conditions: "単原子理想気体に限られる。",
            relatedFormulaIDs: [molarHeatCv.id],
            subcategory: "熱力学の法則",
            examTag: .advanced,
            example: "単原子理想気体 n=1 mol を等圧で ΔT=100 K 加熱。熱量は？→ Q = 5/2×8.314×100 ≈ 2079 J"
        )
        let mayer = Formula(
            title: "マイヤーの関係式",
            latex: "C_P = C_V + R",
            summary: "定圧モル比熱と定積モル比熱の差は気体定数に等しい。",
            symbols: [
                FormulaSymbol(symbol: "C_P", description: "定圧モル比熱 [J/(mol·K)]"),
                FormulaSymbol(symbol: "C_V", description: "定積モル比熱 [J/(mol·K)]"),
                FormulaSymbol(symbol: "R", description: "気体定数 [J/(mol·K)]")
            ],
            conditions: "理想気体で成立する。",
            relatedFormulaIDs: [molarHeatCv.id, molarHeatCp.id],
            subcategory: "熱力学の法則",
            examTag: .advanced,
            example: "単原子理想気体の CP と CV の差は？→ CP − CV = R = 8.314 J/(mol·K)"
        )
        let heatRatio = Formula(
            title: "比熱比",
            latex: "\\gamma = \\frac{C_P}{C_V}",
            summary: "定圧モル比熱と定積モル比熱の比。断熱変化の計算に使う。",
            symbols: [
                FormulaSymbol(symbol: "\\gamma", description: "比熱比（無次元）"),
                FormulaSymbol(symbol: "C_P", description: "定圧モル比熱 [J/(mol·K)]"),
                FormulaSymbol(symbol: "C_V", description: "定積モル比熱 [J/(mol·K)]")
            ],
            conditions: "単原子理想気体では γ = 5/3 ≈ 1.67。",
            relatedFormulaIDs: [molarHeatCv.id, molarHeatCp.id, mayer.id],
            subcategory: "熱力学の法則",
            examTag: .advanced,
            example: "単原子理想気体の CP=5/2R、CV=3/2R。比熱比は？→ γ = 5/3 ≈ 1.67"
        )
        let heatEfficiency = Formula(
            title: "熱効率",
            latex: "e = \\frac{W}{Q_1} = \\frac{Q_1 - Q_2}{Q_1}",
            summary: "熱機関が吸収した熱量のうち仕事として取り出せる割合。",
            symbols: [
                FormulaSymbol(symbol: "e", description: "熱効率（無次元）"),
                FormulaSymbol(symbol: "W", description: "取り出した仕事 [J]"),
                FormulaSymbol(symbol: "Q_1", description: "吸収した熱量 [J]"),
                FormulaSymbol(symbol: "Q_2", description: "放出した熱量 [J]")
            ],
            conditions: "熱力学第二法則より e < 1 である。",
            relatedFormulaIDs: [firstLaw.id],
            subcategory: "熱力学の法則",
            examTag: .common,
            example: "Q₁=1000 J 吸収、Q₂=600 J 放出。熱効率は？→ e = (1000−600)/1000 = 0.40（40%）"
        )

        return FormulaCategory(
            name: "熱力学",
            icon: "thermometer.medium",
            formulas: [
                specificHeat, heatCapacity,
                idealGas, boyleCharles, boyle, charles,
                kineticTheory, internalEnergy,
                firstLaw, workByGas, molarHeatCv, molarHeatCp, mayer, heatRatio, heatEfficiency
            ]
        )
    }()
}

// MARK: - 波動
extension FormulaCategory {
    static let sampleWaves: FormulaCategory = {
        // 波の性質
        let waveEquation = Formula(
            title: "波の基本式",
            latex: "v = f\\lambda",
            summary: "波の速さは振動数と波長の積に等しい。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "波の速さ [m/s]"),
                FormulaSymbol(symbol: "f", description: "振動数 [Hz]"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "あらゆる波に普遍的に成立する。",
            subcategory: "波の性質",
            examTag: .common,
            example: "f=440 Hz、v=340 m/s の音波の波長は？→ λ = 340/440 ≈ 0.77 m"
        )
        let period = Formula(
            title: "周期と振動数",
            latex: "T = \\frac{1}{f}",
            summary: "周期は振動数の逆数。",
            symbols: [
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "f", description: "振動数 [Hz]")
            ],
            conditions: "周期的な波動すべてに成立する。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "波の性質",
            examTag: .common,
            example: "f=50 Hz の交流の周期は？→ T = 1/50 = 0.020 s"
        )
        let sineWave = Formula(
            title: "正弦波の式",
            latex: "y = A\\sin\\frac{2\\pi}{T}(t - \\frac{x}{v})",
            summary: "x 方向に伝わる正弦波の変位を表す式。",
            symbols: [
                FormulaSymbol(symbol: "y", description: "変位 [m]"),
                FormulaSymbol(symbol: "A", description: "振幅 [m]"),
                FormulaSymbol(symbol: "T", description: "周期 [s]"),
                FormulaSymbol(symbol: "t", description: "時刻 [s]"),
                FormulaSymbol(symbol: "x", description: "位置 [m]"),
                FormulaSymbol(symbol: "v", description: "波速 [m/s]")
            ],
            conditions: "単純な正弦波（平面波）で成立する。",
            relatedFormulaIDs: [waveEquation.id, period.id],
            subcategory: "波の性質",
            examTag: .advanced,
            example: "A=0.05 m、T=2 s、v=4 m/s。x=2 m、t=1 s での変位は？→ y = 0.05×sin(π×0.5) = 0.05 m"
        )
        // 干渉
        let interferenceStrong = Formula(
            title: "波の干渉（強め合い）",
            latex: "|l_1 - l_2| = m\\lambda",
            summary: "2つの波源からの経路差が波長の整数倍のとき強め合う。",
            symbols: [
                FormulaSymbol(symbol: "l_1, l_2", description: "各波源からの距離 [m]"),
                FormulaSymbol(symbol: "m", description: "整数 (0, 1, 2, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "2波源が同位相で振動するとき。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "干渉と回折",
            examTag: .common,
            example: "λ=500 nm の光。経路差 1000 nm は強め合う？→ 1000 nm = 2λ → ✓ 強め合う"
        )
        let interferenceWeak = Formula(
            title: "波の干渉（弱め合い）",
            latex: "|l_1 - l_2| = (m + \\frac{1}{2})\\lambda",
            summary: "経路差が波長の半整数倍のとき弱め合う。",
            symbols: [
                FormulaSymbol(symbol: "l_1, l_2", description: "各波源からの距離 [m]"),
                FormulaSymbol(symbol: "m", description: "整数 (0, 1, 2, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "2波源が同位相で振動するとき。",
            relatedFormulaIDs: [interferenceStrong.id],
            subcategory: "干渉と回折",
            examTag: .common,
            example: "λ=500 nm。経路差 750 nm は弱め合う？→ 750 nm = 1.5λ = (1+½)λ → ✓ 弱め合う"
        )
        let newtonRings = Formula(
            title: "ニュートンリング（明環の条件）",
            latex: "r^2 = \\left(m + \\frac{1}{2}\\right)\\lambda R",
            summary: "平凸レンズと平面ガラスの間の薄膜干渉で生じる明るい環の半径。",
            symbols: [
                FormulaSymbol(symbol: "r", description: "明環の半径 [m]"),
                FormulaSymbol(symbol: "m", description: "整数 (0, 1, 2, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "光の波長 [m]"),
                FormulaSymbol(symbol: "R", description: "レンズの曲率半径 [m]")
            ],
            conditions: "空気層の厚さが波長に比べて十分薄いとき成立する。",
            relatedFormulaIDs: [interferenceStrong.id],
            subcategory: "干渉と回折",
            examTag: .advanced,
            example: "λ=600 nm、R=1 m。m=5 の明環の半径は？→ r = √(5.5×600×10⁻⁹×1) ≈ 1.8 mm"
        )
        let youngBright = Formula(
            title: "ヤングの干渉実験（明線）",
            latex: "\\frac{dx}{l} = m\\lambda",
            summary: "二重スリットによる光の明線の条件。",
            symbols: [
                FormulaSymbol(symbol: "d", description: "スリット間隔 [m]"),
                FormulaSymbol(symbol: "x", description: "中央からの明線の距離 [m]"),
                FormulaSymbol(symbol: "l", description: "スリットからスクリーンまでの距離 [m]"),
                FormulaSymbol(symbol: "m", description: "次数 (0, 1, 2, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "d ≪ l のとき成立する近似式。",
            relatedFormulaIDs: [interferenceStrong.id],
            subcategory: "干渉と回折",
            examTag: .advanced,
            example: "d=0.5 mm、l=2 m、λ=500 nm。1 次明線の位置は？→ x = 1×500×10⁻⁹×2/5×10⁻⁴ = 2.0 mm"
        )
        let diffractionGrating = Formula(
            title: "回折格子の条件",
            latex: "d\\sin\\theta = m\\lambda",
            summary: "回折格子で明線が現れる条件。",
            symbols: [
                FormulaSymbol(symbol: "d", description: "格子間隔 [m]"),
                FormulaSymbol(symbol: "\\theta", description: "回折角 [rad]"),
                FormulaSymbol(symbol: "m", description: "回折次数 (0, 1, 2, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "回折格子の溝が等間隔のとき成立する。",
            relatedFormulaIDs: [interferenceStrong.id],
            subcategory: "干渉と回折",
            examTag: .advanced,
            example: "d=2×10⁻⁶ m、λ=500 nm。1 次回折角は？→ sinθ = 0.25 → θ ≈ 14.5°"
        )
        // 光の性質
        let snell = Formula(
            title: "スネルの法則（屈折の法則）",
            latex: "n_1\\sin\\theta_1 = n_2\\sin\\theta_2",
            summary: "光が媒質の境界で屈折するときの関係式。",
            symbols: [
                FormulaSymbol(symbol: "n_1, n_2", description: "各媒質の屈折率（無次元）"),
                FormulaSymbol(symbol: "\\theta_1", description: "入射角 [rad]"),
                FormulaSymbol(symbol: "\\theta_2", description: "屈折角 [rad]")
            ],
            conditions: "均質な等方性媒質の平面境界で成立する。",
            subcategory: "光の性質",
            examTag: .common,
            example: "n₁=1.0、θ₁=30°、n₂=1.5。屈折角は？→ sinθ₂ = sin30°/1.5 = 1/3 → θ₂ ≈ 19.5°"
        )
        let lightSpeed = Formula(
            title: "媒質中の光速",
            latex: "v = \\frac{c}{n}",
            summary: "媒質中の光速は屈折率に反比例する。",
            symbols: [
                FormulaSymbol(symbol: "v", description: "媒質中の光速 [m/s]"),
                FormulaSymbol(symbol: "c", description: "真空中の光速 ≈ 3×10⁸ [m/s]"),
                FormulaSymbol(symbol: "n", description: "屈折率（無次元、≥1）")
            ],
            conditions: "光学的に均質な媒質で成立する。",
            relatedFormulaIDs: [snell.id],
            subcategory: "光の性質",
            examTag: .common,
            example: "屈折率 n=1.5 のガラス中の光速は？→ v = 3×10⁸/1.5 = 2×10⁸ m/s"
        )
        let criticalAngle = Formula(
            title: "全反射の臨界角",
            latex: "\\sin\\theta_c = \\frac{n_2}{n_1}",
            summary: "密な媒質から疎な媒質へ光が入射するとき、全反射が起きる最小角度。",
            symbols: [
                FormulaSymbol(symbol: "\\theta_c", description: "臨界角 [rad]"),
                FormulaSymbol(symbol: "n_1", description: "入射側媒質の屈折率（大きい方）"),
                FormulaSymbol(symbol: "n_2", description: "透過側媒質の屈折率（小さい方）")
            ],
            conditions: "n₁ > n₂ のとき成立する。θ ≥ θc で全反射が起きる。",
            relatedFormulaIDs: [snell.id],
            subcategory: "光の性質",
            examTag: .common,
            example: "n₁=1.5（ガラス）→ 空気（n₂=1.0）。臨界角は？→ sinθc = 1/1.5 = 2/3 → θc ≈ 41.8°"
        )
        let lensFormula = Formula(
            title: "レンズの公式",
            latex: "\\frac{1}{a} + \\frac{1}{b} = \\frac{1}{f}",
            summary: "物体距離 a と像距離 b の逆数の和は焦点距離 f の逆数に等しい。",
            symbols: [
                FormulaSymbol(symbol: "a", description: "物体距離（レンズから物体まで） [m]"),
                FormulaSymbol(symbol: "b", description: "像距離（レンズから像まで） [m]"),
                FormulaSymbol(symbol: "f", description: "焦点距離 [m]")
            ],
            conditions: "薄いレンズ近似で成立する。実像のとき b > 0。",
            relatedFormulaIDs: [snell.id],
            subcategory: "光の性質",
            examTag: .common,
            example: "f=20 cm、物体距離 a=30 cm。像距離は？→ 1/b = 1/20−1/30 = 1/60 → b = 60 cm（実像）"
        )
        let thinFilm = Formula(
            title: "薄膜干渉（明るい条件）",
            latex: "2nd\\cos\\theta = (m + \\frac{1}{2})\\lambda",
            summary: "薄膜の表面と裏面で反射した光が強め合う条件。",
            symbols: [
                FormulaSymbol(symbol: "n", description: "薄膜の屈折率"),
                FormulaSymbol(symbol: "d", description: "膜の厚さ [m]"),
                FormulaSymbol(symbol: "\\theta", description: "屈折角 [rad]"),
                FormulaSymbol(symbol: "m", description: "整数 (0, 1, 2, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "真空中の波長 [m]")
            ],
            conditions: "薄膜が空気より屈折率が大きいとき（両面で位相反転）。",
            relatedFormulaIDs: [snell.id, interferenceStrong.id],
            subcategory: "光の性質",
            examTag: .advanced,
            example: "n=1.5、λ=600 nm、垂直入射。最薄の明条件膜厚は？→ 2×1.5×d = ½×600 nm → d = 100 nm"
        )
        // 音波
        let doppler = Formula(
            title: "ドップラー効果",
            latex: "f = \\frac{V - v_o}{V - v_s}f_0",
            summary: "音源や観測者が運動するとき観測される振動数が変化する。",
            symbols: [
                FormulaSymbol(symbol: "f", description: "観測される振動数 [Hz]"),
                FormulaSymbol(symbol: "f_0", description: "音源の振動数 [Hz]"),
                FormulaSymbol(symbol: "V", description: "音速 [m/s]"),
                FormulaSymbol(symbol: "v_o", description: "観測者の速さ（音源に近づく向き正） [m/s]"),
                FormulaSymbol(symbol: "v_s", description: "音源の速さ（観測者に近づく向き正） [m/s]")
            ],
            conditions: "音源・観測者ともに音速未満のとき成立する。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "音波",
            examTag: .common,
            example: "V=340 m/s、音源が近づく v_s=40 m/s、f₀=500 Hz。観測振動数は？→ f = 340/300×500 ≈ 567 Hz"
        )
        let beat = Formula(
            title: "うなりの振動数",
            latex: "f = |f_1 - f_2|",
            summary: "振動数が近い2音が重なるとき生じるうなりの回数。",
            symbols: [
                FormulaSymbol(symbol: "f", description: "うなりの振動数 [Hz]"),
                FormulaSymbol(symbol: "f_1, f_2", description: "2つの音の振動数 [Hz]")
            ],
            conditions: "2音の振動数差が小さいとき聞こえる。",
            relatedFormulaIDs: [doppler.id],
            subcategory: "音波",
            examTag: .common,
            example: "440 Hz と 444 Hz が重なった。うなりの回数は？→ f = |444−440| = 4 回/s"
        )
        let closedPipe = Formula(
            title: "閉管の固有振動数",
            latex: "f_n = \\frac{2n-1}{4l}V",
            summary: "一端閉管の n 次固有振動（奇数次倍音のみ）。",
            symbols: [
                FormulaSymbol(symbol: "f_n", description: "n 次固有振動数 [Hz]"),
                FormulaSymbol(symbol: "n", description: "倍音次数 (1, 2, 3, …)"),
                FormulaSymbol(symbol: "l", description: "管の長さ [m]"),
                FormulaSymbol(symbol: "V", description: "音速 [m/s]")
            ],
            conditions: "一端が閉じた管（閉管）で成立する。",
            relatedFormulaIDs: [waveEquation.id],
            subcategory: "音波",
            examTag: .common,
            example: "閉管 l=0.85 m（V=340 m/s）。基本振動数は？→ f₁ = 340/(4×0.85) = 100 Hz"
        )
        let openPipe = Formula(
            title: "開管の固有振動数",
            latex: "f_n = \\frac{n}{2l}V",
            summary: "両端開管の n 次固有振動（全倍音）。",
            symbols: [
                FormulaSymbol(symbol: "f_n", description: "n 次固有振動数 [Hz]"),
                FormulaSymbol(symbol: "n", description: "倍音次数 (1, 2, 3, …)"),
                FormulaSymbol(symbol: "l", description: "管の長さ [m]"),
                FormulaSymbol(symbol: "V", description: "音速 [m/s]")
            ],
            conditions: "両端が開いた管（開管）で成立する。",
            relatedFormulaIDs: [closedPipe.id],
            subcategory: "音波",
            examTag: .common,
            example: "開管 l=0.85 m（V=340 m/s）。2 次固有振動数は？→ f₂ = 2×340/(2×0.85) = 400 Hz"
        )
        let airSound = Formula(
            title: "空気中の音速",
            latex: "V = 331.5 + 0.6t",
            summary: "温度 t ℃ における空気中の音速の近似式。",
            symbols: [
                FormulaSymbol(symbol: "V", description: "音速 [m/s]"),
                FormulaSymbol(symbol: "t", description: "温度 [℃]")
            ],
            conditions: "0℃付近の近似式。0℃で331.5 m/s。",
            subcategory: "音波",
            examTag: .common,
            example: "20 ℃ での空気中の音速は？→ V = 331.5+0.6×20 = 343.5 m/s"
        )

        return FormulaCategory(
            name: "波動",
            icon: "waveform",
            formulas: [
                waveEquation, period, sineWave,
                newtonRings, interferenceStrong, interferenceWeak, youngBright, diffractionGrating,
                snell, lightSpeed, criticalAngle, lensFormula, thinFilm,
                doppler, beat, closedPipe, openPipe, airSound
            ]
        )
    }()
}

// MARK: - 原子物理
extension FormulaCategory {
    static let sampleAtomicPhysics: FormulaCategory = {
        // 光子
        let photonEnergy = Formula(
            title: "光子のエネルギー",
            latex: "E = h\\nu = \\frac{hc}{\\lambda}",
            summary: "光子1個のエネルギーはプランク定数と振動数の積。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "光子のエネルギー [J]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 ≈ 6.63×10⁻³⁴ [J·s]"),
                FormulaSymbol(symbol: "\\nu", description: "振動数 [Hz]"),
                FormulaSymbol(symbol: "c", description: "光速 ≈ 3×10⁸ [m/s]"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "光の粒子性（量子論）に基づく。",
            subcategory: "光と光子",
            examTag: .common,
            example: "λ=500 nm の光子のエネルギーは？→ E = hc/λ = 6.63×10⁻³⁴×3×10⁸/500×10⁻⁹ ≈ 3.98×10⁻¹⁹ J"
        )
        let photoelectric = Formula(
            title: "光電効果のエネルギー保存則",
            latex: "h\\nu = \\frac{1}{2}mv^2 + W",
            summary: "光子のエネルギーは電子の運動エネルギーと仕事関数の和。",
            symbols: [
                FormulaSymbol(symbol: "h\\nu", description: "光子のエネルギー [J]"),
                FormulaSymbol(symbol: "\\frac{1}{2}mv^2", description: "飛び出した電子の運動エネルギー [J]"),
                FormulaSymbol(symbol: "W", description: "仕事関数（金属から電子を取り出すのに必要なエネルギー） [J]")
            ],
            conditions: "光の振動数が限界振動数より大きいとき電子が飛び出す。",
            relatedFormulaIDs: [photonEnergy.id],
            subcategory: "光と光子",
            examTag: .common,
            example: "hν=5 eV、仕事関数 W=3 eV。飛び出す電子の運動エネルギーは？→ ½mv² = 5−3 = 2 eV"
        )
        let photonMomentum = Formula(
            title: "光子の運動量",
            latex: "p = \\frac{h\\nu}{c} = \\frac{h}{\\lambda}",
            summary: "光子は質量ゼロでも運動量を持つ。",
            symbols: [
                FormulaSymbol(symbol: "p", description: "光子の運動量 [kg·m/s]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "\\nu", description: "振動数 [Hz]"),
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]")
            ],
            conditions: "光子（電磁波の量子）に成立する。",
            relatedFormulaIDs: [photonEnergy.id],
            subcategory: "光と光子",
            examTag: .advanced,
            example: "λ=400 nm の光子の運動量は？→ p = 6.63×10⁻³⁴/(400×10⁻⁹) ≈ 1.66×10⁻²⁷ kg·m/s"
        )
        // X線
        let xrayMinWavelength = Formula(
            title: "X線の最短波長",
            latex: "\\lambda_0 = \\frac{hc}{eV}",
            summary: "加速電圧 V で加速された電子が全エネルギーをX線に変換したときの最短波長。",
            symbols: [
                FormulaSymbol(symbol: "\\lambda_0", description: "最短波長 [m]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "c", description: "光速 [m/s]"),
                FormulaSymbol(symbol: "e", description: "電子電荷 ≈ 1.6×10⁻¹⁹ [C]"),
                FormulaSymbol(symbol: "V", description: "加速電圧 [V]")
            ],
            conditions: "電子の全運動エネルギーが1つのX線光子になるとき。",
            relatedFormulaIDs: [photonEnergy.id],
            subcategory: "X線・物質波",
            examTag: .advanced,
            example: "V=50 kV で加速した電子が出すX線の最短波長は？→ λ₀ = hc/(eV) ≈ 2.5×10⁻¹¹ m"
        )
        let bragg = Formula(
            title: "ブラッグの条件",
            latex: "2d\\sin\\theta = n\\lambda",
            summary: "結晶によるX線の回折（反射）が強め合う条件。",
            symbols: [
                FormulaSymbol(symbol: "d", description: "結晶の格子間隔 [m]"),
                FormulaSymbol(symbol: "\\theta", description: "X線の入射角 [rad]"),
                FormulaSymbol(symbol: "n", description: "回折次数 (1, 2, 3, …)"),
                FormulaSymbol(symbol: "\\lambda", description: "X線の波長 [m]")
            ],
            conditions: "結晶が均一な格子構造を持つとき成立する。",
            subcategory: "X線・物質波",
            examTag: .advanced,
            example: "d=2×10⁻¹⁰ m、θ=30°、n=1。X線の波長は？→ λ = 2×2×10⁻¹⁰×sin30° = 2×10⁻¹⁰ m"
        )
        let deBroglie = Formula(
            title: "ド・ブロイ波（物質波）",
            latex: "\\lambda = \\frac{h}{p} = \\frac{h}{mv}",
            summary: "運動する粒子は波長 λ の波としての性質を示す。",
            symbols: [
                FormulaSymbol(symbol: "\\lambda", description: "ド・ブロイ波長 [m]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "p", description: "運動量 [kg·m/s]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "v", description: "速さ [m/s]")
            ],
            conditions: "あらゆる粒子に成立する（巨視的物体では波長が非常に短い）。",
            relatedFormulaIDs: [photonMomentum.id],
            subcategory: "X線・物質波",
            examTag: .advanced,
            example: "m=9.1×10⁻³¹ kg、v=1×10⁶ m/s の電子のド・ブロイ波長は？→ λ = h/mv ≈ 7.3×10⁻¹⁰ m"
        )
        let compton = Formula(
            title: "コンプトン効果（波長の伸び）",
            latex: "\\Delta\\lambda = \\frac{h}{mc}(1 - \\cos\\phi)",
            summary: "X線が電子に散乱されるとき波長が伸びる。",
            symbols: [
                FormulaSymbol(symbol: "\\Delta\\lambda", description: "波長の伸び [m]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "m", description: "電子の質量 [kg]"),
                FormulaSymbol(symbol: "c", description: "光速 [m/s]"),
                FormulaSymbol(symbol: "\\phi", description: "散乱角 [rad]")
            ],
            conditions: "X線が自由電子に弾性散乱されるとき成立する。",
            relatedFormulaIDs: [photonMomentum.id],
            subcategory: "X線・物質波",
            examTag: .advanced,
            example: "散乱角 φ=90°。波長の伸びは？→ Δλ = h/mc×(1−cos90°) = h/mc ≈ 2.43×10⁻¹² m"
        )
        // 水素原子
        let bohrQuantum = Formula(
            title: "ボーアの量子条件",
            latex: "mvr = n\\frac{h}{2\\pi}",
            summary: "電子の軌道角運動量はプランク定数の整数倍。",
            symbols: [
                FormulaSymbol(symbol: "m", description: "電子の質量 [kg]"),
                FormulaSymbol(symbol: "v", description: "電子の速さ [m/s]"),
                FormulaSymbol(symbol: "r", description: "軌道半径 [m]"),
                FormulaSymbol(symbol: "n", description: "主量子数 (1, 2, 3, …)"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]")
            ],
            conditions: "ボーアの水素原子モデルで成立する。",
            subcategory: "水素原子",
            examTag: .advanced,
            example: "n=1 の水素電子の軌道角運動量は？→ mvr = 1×h/(2π) = ℏ ≈ 1.05×10⁻³⁴ J·s"
        )
        let bohrFrequency = Formula(
            title: "ボーアの振動数条件",
            latex: "E_n - E_{n'} = h\\nu",
            summary: "電子がエネルギー準位間を遷移するとき光を吸収・放出する。",
            symbols: [
                FormulaSymbol(symbol: "E_n, E_{n'}", description: "各エネルギー準位 [J]"),
                FormulaSymbol(symbol: "h", description: "プランク定数 [J·s]"),
                FormulaSymbol(symbol: "\\nu", description: "放出（吸収）する光の振動数 [Hz]")
            ],
            conditions: "ボーアの水素原子モデルで成立する。",
            relatedFormulaIDs: [bohrQuantum.id, photonEnergy.id],
            subcategory: "水素原子",
            examTag: .common,
            example: "電子が n=3→n=2 に遷移。放出光子のエネルギーは？→ hν = E₃−E₂ = (−1.51)−(−3.40) = 1.89 eV"
        )
        let energyLevel = Formula(
            title: "水素原子のエネルギー準位",
            latex: "E_n = -\\frac{13.6}{n^2}\\ \\mathrm{eV}",
            summary: "水素原子の電子のエネルギーは主量子数の2乗に反比例する。",
            symbols: [
                FormulaSymbol(symbol: "E_n", description: "n 番目のエネルギー準位 [eV]"),
                FormulaSymbol(symbol: "n", description: "主量子数 (1, 2, 3, …)")
            ],
            conditions: "基底状態 (n=1) で E₁ = −13.6 eV。",
            relatedFormulaIDs: [bohrQuantum.id],
            subcategory: "水素原子",
            examTag: .common,
            example: "n=2 の水素原子のエネルギー準位は？→ E₂ = −13.6/4 = −3.4 eV"
        )
        let rydberg = Formula(
            title: "水素スペクトル（リュードベリの式）",
            latex: "\\frac{1}{\\lambda} = R(\\frac{1}{n'^2} - \\frac{1}{n^2})",
            summary: "水素原子が放出する光の波長を与える式。",
            symbols: [
                FormulaSymbol(symbol: "\\lambda", description: "波長 [m]"),
                FormulaSymbol(symbol: "R", description: "リュードベリ定数 ≈ 1.097×10⁷ [m⁻¹]"),
                FormulaSymbol(symbol: "n'", description: "低いエネルギー準位 (1, 2, …)"),
                FormulaSymbol(symbol: "n", description: "高いエネルギー準位 (n > n')")
            ],
            conditions: "n' = 1: ライマン系列（紫外線）、n' = 2: バルマー系列（可視光）",
            relatedFormulaIDs: [energyLevel.id, bohrFrequency.id],
            subcategory: "水素原子",
            examTag: .advanced,
            example: "水素 n=3→n=2 の放出光の波長は？→ 1/λ = R(1/4−1/9) = 5R/36 → λ ≈ 656 nm（赤）"
        )
        // 放射性崩壊
        let halfLife = Formula(
            title: "放射性崩壊（半減期）",
            latex: "N = N_0\\left(\\frac{1}{2}\\right)^{t/T}",
            summary: "放射性核種の原子核数は半減期 T ごとに半分になる。",
            symbols: [
                FormulaSymbol(symbol: "N", description: "時刻 t での原子核数"),
                FormulaSymbol(symbol: "N_0", description: "初期の原子核数"),
                FormulaSymbol(symbol: "T", description: "半減期 [s]"),
                FormulaSymbol(symbol: "t", description: "経過時間 [s]")
            ],
            conditions: "放射性崩壊は確率的な過程であり大量の核に成立する。",
            subcategory: "放射線と原子核",
            examTag: .common,
            example: "半減期 T=8 日。24 日後に残る割合は？→ (1/2)^(24/8) = (1/2)³ = 1/8"
        )
        let massDeffect = Formula(
            title: "質量欠損と結合エネルギー",
            latex: "\\Delta M = Zm_p + (A-Z)m_n - M",
            summary: "原子核の質量は構成粒子の質量の和より小さい（質量欠損）。",
            symbols: [
                FormulaSymbol(symbol: "\\Delta M", description: "質量欠損 [kg]"),
                FormulaSymbol(symbol: "Z", description: "陽子数"),
                FormulaSymbol(symbol: "A", description: "質量数"),
                FormulaSymbol(symbol: "m_p", description: "陽子の質量 [kg]"),
                FormulaSymbol(symbol: "m_n", description: "中性子の質量 [kg]"),
                FormulaSymbol(symbol: "M", description: "原子核の質量 [kg]")
            ],
            conditions: "核反応のエネルギー計算に使う。",
            subcategory: "放射線と原子核",
            examTag: .advanced,
            example: "陽子 2 個・中性子 2 個の He 核。質量欠損 ΔM から結合エネルギーを求める → ΔE = ΔMc²"
        )
        let emc2 = Formula(
            title: "質量とエネルギーの等価性",
            latex: "E = mc^2",
            summary: "質量はエネルギーの一形態であり、光速の二乗を乗じた値がエネルギーに等しい。",
            symbols: [
                FormulaSymbol(symbol: "E", description: "エネルギー [J]"),
                FormulaSymbol(symbol: "m", description: "質量 [kg]"),
                FormulaSymbol(symbol: "c", description: "光速 ≈ 3×10⁸ [m/s]")
            ],
            conditions: "特殊相対性理論から導かれる。核反応のエネルギー計算に使う。",
            relatedFormulaIDs: [massDeffect.id],
            subcategory: "放射線と原子核",
            examTag: .common,
            example: "質量欠損 Δm=4.8×10⁻³⁰ kg から生じるエネルギーは？→ E = 4.8×10⁻³⁰×(3×10⁸)² ≈ 4.3×10⁻¹³ J"
        )

        return FormulaCategory(
            name: "原子物理",
            icon: "atom",
            formulas: [
                photonEnergy, photoelectric, photonMomentum,
                xrayMinWavelength, bragg, deBroglie, compton,
                bohrQuantum, bohrFrequency, energyLevel, rydberg,
                halfLife, massDeffect, emc2
            ]
        )
    }()
}

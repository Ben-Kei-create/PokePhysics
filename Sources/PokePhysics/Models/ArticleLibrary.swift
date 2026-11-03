import Foundation

enum ArticleLibrary {
    static let allArticles: [Article] = mechanics + electromagnetism + thermodynamics + waves + atomic + relativity + math

    static func articles(for category: ArticleCategory) -> [Article] {
        allArticles.filter { $0.category == category }
    }

    static func article(id: String) -> Article? {
        allArticles.first { $0.id == id }
    }

    static func article(title: String) -> Article? {
        allArticles.first { $0.title.lowercased() == title.lowercased() }
    }

    static func relatedArticles(for article: Article) -> [Article] {
        let targets = extractWikiTargets(from: article.content)
        return targets.compactMap { self.article(title: $0) }
    }

    // 教科書記事に関連する公式（同カテゴリの公式 + 本文中に登場するタイトル）
    static func relatedFormulas(for article: Article) -> [Formula] {
        let formulaCategory = FormulaLibrary.allCategories.first { cat in
            FormulaLibrary.articleCategory(for: cat) == article.category
        }
        guard let cat = formulaCategory else { return [] }
        let candidates = cat.formulas
        let scored = candidates.map { formula -> (Formula, Int) in
            var score = 0
            if article.content.contains(formula.title) { score += 2 }
            if !formula.subcategory.isEmpty && article.title.contains(formula.subcategory) { score += 1 }
            return (formula, score)
        }
        return scored.filter { $0.1 > 0 }.sorted { $0.1 > $1.1 }.prefix(4).map(\.0)
    }

    private static func extractWikiTargets(from content: String) -> [String] {
        let pattern = #"\[\[([^\]|]+)(?:\|[^\]]+)?\]\]"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(content.startIndex..., in: content)
        return regex.matches(in: content, range: range).compactMap { match in
            guard let r = Range(match.range(at: 1), in: content) else { return nil }
            return String(content[r])
        }
    }
}

// MARK: - 力学

private extension ArticleLibrary {
    static let mechanics: [Article] = [
        Article(id: "mech-velocity", title: "速度と加速度", category: .mechanics,
                chapter: "第1章 運動の記述", order: 1,
                content: """
                ## 変位と速度

                物体の位置の変化量を**変位** $\\Delta x$ という。時間 $\\Delta t$ の間の**平均速度**は次の式で定義される。

                $$\\bar{v} = \\frac{\\Delta x}{\\Delta t}$$

                $\\Delta t \\to 0$ の極限をとったものが**瞬間速度** $v$ であり、位置 $x$ の時間微分として表される。

                $$v = \\frac{dx}{dt} = \\dot{x}$$

                ## 加速度

                速度の時間変化率を**加速度** $a$ という。

                $$a = \\frac{dv}{dt} = \\frac{d^2x}{dt^2}$$

                加速度が一定（等加速度運動）のとき、以下の3つの公式が成り立つ。

                $$v = v_0 + at$$
                $$x = v_0 t + \\frac{1}{2}at^2$$
                $$v^2 - v_0^2 = 2ax$$

                これらを「[[ニュートンの運動法則]]」と組み合わせることで、多くの力学問題が解ける。

                ## 自由落下

                地表付近で空気抵抗を無視すると、物体は鉛直下向きに加速度 $g \\approx 9.8\\,\\mathrm{m/s^2}$ で落下する（**自由落下**）。

                :::figure 落下の様子
                t=0s: 静止 -> t=1s: 9.8m/s -> t=2s: 19.6m/s
                caption: 速度は一定の割合で増加する
                :::
                """,
                date: Date(timeIntervalSince1970: 1700000000)),

        Article(id: "mech-newton", title: "ニュートンの運動法則", category: .mechanics,
                chapter: "第1章 運動の記述", order: 2,
                content: """
                ## 慣性の法則（第1法則）

                外力がゼロのとき、静止している物体は静止し続け、運動している物体は等速直線運動を続ける。これを**慣性の法則**という。

                ## 運動方程式（第2法則）

                物体に力 $F$ が働くとき、加速度 $a$ は力に比例し質量 $m$ に反比例する。

                $$F = ma$$

                複数の力が働くときは合力を使う。$x$, $y$ 成分に分けて解くと便利だ。

                $$F_x = ma_x, \\quad F_y = ma_y$$

                ## 作用・反作用の法則（第3法則）

                物体Aが物体Bに力 $\\vec{F}$ を加えるとき、BはAに **大きさが等しく逆向きの力** $-\\vec{F}$ を加える。

                $$\\vec{F}_{AB} = -\\vec{F}_{BA}$$

                > 注意: 作用・反作用は**別の物体**に働く。同一物体への力のつり合いと混同しないこと。

                [[速度と加速度]] で学んだ等加速度公式とこの運動方程式を組み合わせれば、あらゆる力学問題の基礎が解ける。
                """,
                date: Date(timeIntervalSince1970: 1700086400)),

        Article(id: "mech-energy", title: "仕事とエネルギー", category: .mechanics,
                chapter: "第1章 運動の記述", order: 3,
                content: """
                ## 仕事の定義

                力 $F$ の方向に物体が変位 $d$ だけ動いたとき、力がした**仕事** $W$ は

                $$W = Fd\\cos\\theta$$

                ここで $\\theta$ は力と変位のなす角。力と変位が同じ向きなら $\\theta=0$ で $W=Fd$。

                ## 運動エネルギー

                質量 $m$、速度 $v$ の物体がもつ**運動エネルギー** $K$ は

                $$K = \\frac{1}{2}mv^2$$

                **仕事・エネルギー定理**：合力がした仕事はそのまま運動エネルギーの変化になる。

                $$W_{\\text{合}} = \\Delta K = \\frac{1}{2}mv^2 - \\frac{1}{2}mv_0^2$$

                ## 位置エネルギー

                保存力（重力・弾性力など）に対しては**位置エネルギー** $U$ が定義できる。

                - 重力位置エネルギー: $U = mgh$
                - 弾性位置エネルギー: $U = \\dfrac{1}{2}kx^2$

                **力学的エネルギー保存則**：保存力だけが働くとき

                $$K + U = \\text{const.}$$
                """,
                date: Date(timeIntervalSince1970: 1700172800)),

        Article(id: "mech-circular", title: "円運動と単振動", category: .mechanics,
                chapter: "第2章 力学の応用", order: 1,
                content: """
                ## 等速円運動

                半径 $r$ の円周上を一定の速さ $v$ で回る運動を**等速円運動**という。速さは変わらないが向きが変わるため加速度が生じる。

                $$a = \\frac{v^2}{r} = r\\omega^2$$

                この加速度は円の中心に向かう（**向心加速度**）。周期 $T$、角速度 $\\omega = 2\\pi/T$。

                **向心力**: $F = \\dfrac{mv^2}{r} = mr\\omega^2$

                ## 単振動

                ばね定数 $k$ のばねに質量 $m$ の物体をつなぐと、つり合い位置からの変位 $x$ について

                $$F = -kx, \\quad \\therefore a = -\\frac{k}{m}x$$

                これを**単振動**という。角振動数と周期は

                $$\\omega = \\sqrt{\\frac{k}{m}}, \\quad T = 2\\pi\\sqrt{\\frac{m}{k}}$$

                変位の時間変化: $x = A\\cos(\\omega t + \\phi)$

                ## 単振り子

                振れ角が小さいとき、振り子の周期は

                $$T = 2\\pi\\sqrt{\\frac{l}{g}}$$

                ここで $l$ は糸の長さ。質量 $m$ や振れ幅に依存しないことに注意（**等時性**）。
                """,
                date: Date(timeIntervalSince1970: 1700259200)),

        Article(id: "mech-gravity", title: "万有引力とケプラーの法則", category: .mechanics,
                chapter: "第2章 力学の応用", order: 2,
                content: """
                ## 万有引力の法則

                質量 $M$, $m$ の2物体が距離 $r$ だけ離れているとき、互いに引き合う引力（**万有引力**）の大きさは

                $$F = G\\frac{Mm}{r^2}$$

                $G = 6.67 \\times 10^{-11}\\,\\mathrm{N\\cdot m^2/kg^2}$ は万有引力定数。

                ## ケプラーの法則

                **第1法則（楕円軌道）**: 惑星は太陽を1つの焦点とする楕円軌道を描く。

                **第2法則（面積速度一定）**: 惑星と太陽を結ぶ線分が単位時間に掃く面積は一定。

                **第3法則（周期の法則）**: 公転周期 $T$ と軌道半長軸 $r$ の間には

                $$T^2 = \\frac{4\\pi^2}{GM}r^3$$

                ## 人工衛星の速度

                地球半径 $R$、質量 $M$ として、地表すれすれを周回する衛星の**第一宇宙速度**は

                $$v_1 = \\sqrt{\\frac{GM}{R}} \\approx 7.9\\,\\mathrm{km/s}$$

                [[円運動と単振動]] で学んだ向心力の式に万有引力を代入すると導ける。
                """,
                date: Date(timeIntervalSince1970: 1700345600)),

        Article(id: "mech-momentum", title: "運動量と衝突", category: .mechanics,
                chapter: "第2章 力学の応用", order: 3,
                content: """
                ## 運動量と力積

                質量 $m$、速度 $v$ の物体の**運動量** $p$ は

                $$p = mv$$

                力 $F$ が時間 $\\Delta t$ だけ働いたときの**力積**は $F\\Delta t$ であり、運動量の変化に等しい。

                $$F\\Delta t = \\Delta p = mv - mv_0$$

                ## 運動量保存則

                外力の合計がゼロの系（孤立系）では、系全体の運動量は保存される。

                $$m_1v_1 + m_2v_2 = m_1v_1' + m_2v_2'$$

                ## 衝突の種類

                **弾性衝突**（完全弾性衝突）: 運動量保存 + 運動エネルギー保存の両方が成立。

                $$e = 1, \\quad e = -\\frac{v_1' - v_2'}{v_1 - v_2}$$

                **非弾性衝突**: 運動量は保存されるが、運動エネルギーは失われる（$e < 1$）。

                **完全非弾性衝突**: 2物体がくっついて一体となる（$e = 0$）。

                $$v' = \\frac{m_1 v_1 + m_2 v_2}{m_1 + m_2}$$
                """,
                date: Date(timeIntervalSince1970: 1700432000)),
    ]
}

// MARK: - 電磁気学

private extension ArticleLibrary {
    static let electromagnetism: [Article] = [
        Article(id: "em-coulomb", title: "クーロンの法則と電場", category: .electromagnetism,
                chapter: "第1章 電場と電位", order: 1,
                content: """
                ## クーロンの法則

                電荷 $q_1$, $q_2$ をもつ2点電荷が距離 $r$ にあるとき、互いに働く力の大きさは

                $$F = k_e \\frac{q_1 q_2}{r^2}, \\quad k_e = \\frac{1}{4\\pi\\varepsilon_0} \\approx 9.0 \\times 10^9\\,\\mathrm{N\\cdot m^2/C^2}$$

                同符号の電荷は**反発**し、異符号は**引き合う**。

                ## 電場の定義

                電荷 $Q$ が周囲に作る**電場** $E$ は、試験電荷 $q$ が受ける力 $F$ を $q$ で割ったもの。

                $$\\vec{E} = \\frac{\\vec{F}}{q} = \\frac{kQ}{r^2}\\hat{r}$$

                ## 電気力線

                電場の様子を可視化するのが**電気力線**。正電荷から出て負電荷に入る。

                :::figure 点電荷の電気力線
                (+Q) -> 放射状に広がる電気力線 -> 無限遠
                caption: 点電荷の周りの電場は球対称
                :::

                電場の重ね合わせ: 複数の電荷が作る電場は各電場のベクトル和。

                $$\\vec{E}_{\\text{合}} = \\vec{E}_1 + \\vec{E}_2 + \\cdots$$
                """,
                date: Date(timeIntervalSince1970: 1700518400)),

        Article(id: "em-potential", title: "電位とガウスの法則", category: .electromagnetism,
                chapter: "第1章 電場と電位", order: 2,
                content: """
                ## 電位

                無限遠を基準とした、点電荷 $Q$ から距離 $r$ における**電位** $V$ は

                $$V = \\frac{kQ}{r}$$

                電位は**スカラー量**で重ね合わせが容易。電荷 $q$ の位置エネルギーは $U = qV$。

                電場と電位の関係:

                $$E = -\\frac{dV}{dr}$$

                等電位面（$V$ = 一定）は電気力線と常に垂直に交わる。

                ## ガウスの法則

                任意の閉曲面を通る電気力線の総本数（電気フラックス）は、内部の電荷の総量 $Q_\\text{enc}$ に比例する。

                $$\\oint \\vec{E} \\cdot d\\vec{A} = \\frac{Q_\\text{enc}}{\\varepsilon_0}$$

                対称性の高い問題（球・円柱・平板）ではガウスの法則を使うと電場が素早く求まる。

                [[クーロンの法則と電場]] で学んだ点電荷の電場は、ガウスの法則から自然に導かれる。
                """,
                date: Date(timeIntervalSince1970: 1700604800)),

        Article(id: "em-circuit", title: "電流と回路", category: .electromagnetism,
                chapter: "第2章 電流と回路", order: 1,
                content: """
                ## 電流とオームの法則

                単位時間に断面を通過する電荷量を**電流** $I$ という。

                $$I = \\frac{Q}{t} = nqv_d A$$

                抵抗 $R$ の導体に電圧 $V$ をかけたとき流れる電流 $I$ は、**オームの法則**に従う。

                $$V = IR$$

                ## 直列・並列接続

                **直列**: $R = R_1 + R_2 + \\cdots$（電流が共通）

                **並列**: $\\dfrac{1}{R} = \\dfrac{1}{R_1} + \\dfrac{1}{R_2} + \\cdots$（電圧が共通）

                ## キルヒホッフの法則

                複雑な回路でも以下の2法則で解ける。

                **KCL（電流則）**: 任意の節点での電流の和はゼロ。$\\sum I = 0$

                **KVL（電圧則）**: 任意のループの電圧降下の和はゼロ。$\\sum E = \\sum IR$

                ## 電力

                抵抗が消費する電力:

                $$P = VI = I^2R = \\frac{V^2}{R}$$
                """,
                date: Date(timeIntervalSince1970: 1700691200)),

        Article(id: "em-capacitor", title: "コンデンサーと静電エネルギー", category: .electromagnetism,
                chapter: "第2章 電流と回路", order: 2,
                content: """
                ## 電気容量

                2枚の導体板（極板面積 $S$、間隔 $d$）からなる**平行板コンデンサー**の電気容量 $C$ は

                $$C = \\varepsilon_0 \\frac{S}{d}$$

                電荷 $Q$、電圧 $V$、電気容量 $C$ の関係:

                $$Q = CV$$

                ## 静電エネルギー

                充電されたコンデンサーが蓄えるエネルギー:

                $$U = \\frac{Q^2}{2C} = \\frac{1}{2}CV^2 = \\frac{QV}{2}$$

                ## 誘電体

                極板間に比誘電率 $\\varepsilon_r$ の誘電体を挿入すると電気容量が増加する。

                $$C = \\varepsilon_r \\varepsilon_0 \\frac{S}{d}$$

                ## 接続の合成

                **直列**: $\\dfrac{1}{C} = \\dfrac{1}{C_1} + \\dfrac{1}{C_2}$

                **並列**: $C = C_1 + C_2$

                これは抵抗の直列・並列とは逆の関係になる点に注意しよう。[[電流と回路]] も参照。
                """,
                date: Date(timeIntervalSince1970: 1700777600)),

        Article(id: "em-magnetic", title: "磁場とローレンツ力", category: .electromagnetism,
                chapter: "第3章 磁気と電磁誘導", order: 1,
                content: """
                ## 磁場と磁束密度

                磁場の強さを表す量が**磁束密度** $B$（単位: T = テスラ）。電場と同様、磁場も向きと大きさをもつベクトル量。

                ## ローレンツ力

                磁束密度 $B$ の磁場中を速度 $v$ で動く電荷 $q$ には**ローレンツ力**が働く。

                $$\\vec{F} = q\\vec{v} \\times \\vec{B}$$

                大きさ: $F = qvB\\sin\\theta$（$\\theta$ は $v$ と $B$ のなす角）

                ローレンツ力は速度と垂直なので**仕事をしない**。電荷は等速円運動を行う。

                **円運動の半径**:

                $$r = \\frac{mv}{qB}$$

                ## 電流が受ける力

                電流 $I$ が流れる長さ $l$ の導線が磁場 $B$ から受ける力:

                $$F = BIl\\sin\\theta$$

                2本の平行電流が互いに及ぼし合う力（アンペールの法則の応用）も重要。
                """,
                date: Date(timeIntervalSince1970: 1700864000)),

        Article(id: "em-induction", title: "電磁誘導とレンツの法則", category: .electromagnetism,
                chapter: "第3章 磁気と電磁誘導", order: 2,
                content: """
                ## 電磁誘導

                コイルを貫く**磁束** $\\Phi = BS\\cos\\theta$ が変化すると、コイルに**誘導起電力**が生じる。これを**電磁誘導**という。

                **ファラデーの法則**:

                $$\\mathcal{E} = -\\frac{d\\Phi}{dt}$$

                $N$ 巻きのコイルでは $\\mathcal{E} = -N\\dfrac{d\\Phi}{dt}$。

                ## レンツの法則

                誘導電流は、磁束の変化を**妨げる向き**に流れる。これが式中のマイナス符号の意味。

                ## 自己誘導と相互誘導

                コイル自身の電流変化が自分自身に起電力を誘導するのが**自己誘導**。

                $$\\mathcal{E}_L = -L\\frac{dI}{dt}$$

                $L$ はインダクタンス（単位: H = ヘンリー）。コイルが蓄えるエネルギーは

                $$U_L = \\frac{1}{2}LI^2$$

                [[コンデンサーと静電エネルギー]] のエネルギーと対比して理解しよう。
                """,
                date: Date(timeIntervalSince1970: 1700950400)),
    ]
}

// MARK: - 熱力学

private extension ArticleLibrary {
    static let thermodynamics: [Article] = [
        Article(id: "thermo-heat", title: "温度・熱量・比熱", category: .thermodynamics,
                chapter: "第1章 熱と温度", order: 1,
                content: """
                ## 温度と熱

                **温度**は物体の冷熱の程度を表し、摂氏 $t$ [°C] と絶対温度 $T$ [K] は

                $$T = t + 273.15$$

                **熱**は温度差によって移動するエネルギー。単位はジュール [J]（またはカロリー: 1 cal = 4.186 J）。

                ## 熱容量と比熱

                物体を1K上昇させるのに必要な熱量を**熱容量** $C$ という。質量 $m$、比熱 $c$ とすると

                $$C = mc$$

                温度 $\\Delta T$ だけ変化させるのに必要な熱量:

                $$Q = mc\\Delta T$$

                水の比熱: $c = 4.18\\,\\mathrm{J/(g\\cdot K)}$（物質中でほぼ最大）

                ## 熱量保存則

                断熱容器内で高温物体と低温物体を混合したとき、熱量の総和は保存される。

                $$m_1 c_1 (T_1 - T) = m_2 c_2 (T - T_2)$$
                """,
                date: Date(timeIntervalSince1970: 1701036800)),

        Article(id: "thermo-idealgas", title: "理想気体の状態方程式", category: .thermodynamics,
                chapter: "第1章 熱と温度", order: 2,
                content: """
                ## ボイル・シャルルの法則

                一定温度: $pV = \\text{const.}$（**ボイルの法則**）

                一定圧力: $V/T = \\text{const.}$（**シャルルの法則**）

                これらをまとめると

                $$\\frac{p_1 V_1}{T_1} = \\frac{p_2 V_2}{T_2}$$

                ## 理想気体の状態方程式

                物質量 $n$ [mol]、気体定数 $R = 8.314\\,\\mathrm{J/(mol\\cdot K)}$ として

                $$pV = nRT$$

                これが**理想気体の状態方程式**。分子間力と分子自身の体積を無視した近似だが、高温低圧では実在気体によく当てはまる。

                ## 分子運動論

                理想気体の圧力は分子の運動エネルギーから導かれる。

                $$p = \\frac{1}{3}nm_0\\overline{v^2}$$

                1分子の平均運動エネルギー:

                $$\\overline{E_k} = \\frac{1}{2}m_0\\overline{v^2} = \\frac{3}{2}k_B T$$

                $k_B = 1.38 \\times 10^{-23}\\,\\mathrm{J/K}$ はボルツマン定数。温度は分子の平均運動エネルギーそのもの。
                """,
                date: Date(timeIntervalSince1970: 1701123200)),

        Article(id: "thermo-firstlaw", title: "熱力学第一法則", category: .thermodynamics,
                chapter: "第2章 熱力学の法則", order: 1,
                content: """
                ## エネルギー保存と内部エネルギー

                気体が外部から受け取る熱量 $Q$、外部から受ける仕事 $W$、内部エネルギーの変化 $\\Delta U$ について

                $$\\Delta U = Q + W$$

                これを**熱力学第一法則**という。$W = -p\\Delta V$（気体が膨張するとき仕事をする）とすると

                $$\\Delta U = Q - p\\Delta V$$

                ## 各種変化での適用

                | 変化 | 条件 | 関係 |
                |---|---|---|
                | 等積変化 | $\\Delta V=0$ | $\\Delta U = Q$ |
                | 等圧変化 | $p=$ const. | $Q = \\Delta U + p\\Delta V$ |
                | 等温変化 | $T=$ const. | $\\Delta U=0$, $Q = -W$ |
                | 断熱変化 | $Q=0$ | $\\Delta U = W$ |

                単原子理想気体では $\\Delta U = \\dfrac{3}{2}nR\\Delta T$。

                ## 熱効率

                熱機関がもらった熱量 $Q_H$ のうち、仕事 $W$ に変換できる割合を**熱効率** $e$ という。

                $$e = \\frac{W}{Q_H} = 1 - \\frac{Q_C}{Q_H}$$

                **カルノーサイクル**は同じ温度差で動く熱機関の中で最高効率。$e_\\text{Carnot} = 1 - T_C/T_H$
                """,
                date: Date(timeIntervalSince1970: 1701209600)),

        Article(id: "thermo-entropy", title: "エントロピーと熱力学第二法則", category: .thermodynamics,
                chapter: "第2章 熱力学の法則", order: 2,
                content: """
                ## 熱力学第二法則

                熱は自然には高温から低温にしか移動しない。これを**熱力学第二法則**という。言い換えると：

                - 低温から高温へ自然には熱が移動しない（クラウジウスの表現）
                - 1種の熱源から熱をとって全て仕事にする機関は存在しない（ケルビンの表現）

                ## エントロピー

                系が準静的に温度 $T$ で熱量 $dQ$ を受け取るとき、**エントロピー** $S$ の変化は

                $$dS = \\frac{dQ_{\\text{rev}}}{T}$$

                孤立系でのエントロピーは増大するか一定（**エントロピー増大則**）。

                $$\\Delta S_{\\text{系}} \\geq 0$$

                ## 統計力学的解釈

                エントロピーは系の**乱雑さ（確率的重み）** $W$ と次の関係にある（ボルツマンの関係式）。

                $$S = k_B \\ln W$$

                自然現象が「散らかる」方向に進むのは、エントロピーが増大する方が圧倒的に確率が高いから。[[理想気体の状態方程式]] と合わせて熱統計力学の基礎となる。
                """,
                date: Date(timeIntervalSince1970: 1701296000)),
    ]
}

// MARK: - 波動

private extension ArticleLibrary {
    static let waves: [Article] = [
        Article(id: "wave-basic", title: "波の基本性質", category: .waves,
                chapter: "第1章 波の基礎", order: 1,
                content: """
                ## 波とは何か

                波は**媒質の振動が空間を伝わる現象**。媒質自体は移動せず、エネルギーだけが伝わる。

                :::figure 波の伝播
                ○→○→○→○→○
                caption: 隣接する媒質が順番に振動する
                :::

                ## 波の基本量

                - **振幅** $A$: 振動の最大変位
                - **波長** $\\lambda$: 同位相の点の間隔
                - **周期** $T$: 1回の振動にかかる時間
                - **振動数** $f = 1/T$: 単位時間の振動回数

                **波の速さ**:

                $$v = f\\lambda = \\frac{\\lambda}{T}$$

                ## 波の式

                $x$ 方向に伝わる波の変位 $y$ は

                $$y = A\\sin\\left(2\\pi\\left(\\frac{t}{T} - \\frac{x}{\\lambda}\\right)\\right) = A\\sin(\\omega t - kx)$$

                ここで $\\omega = 2\\pi f$（角振動数）、$k = 2\\pi/\\lambda$（波数）。

                ## 重ね合わせと干渉

                2つ以上の波が重なるとき、変位は**線形に重ね合わさる**。同位相で重なれば強め合い（**強め合い**）、逆位相で重なれば弱め合う（**弱め合い**）。
                """,
                date: Date(timeIntervalSince1970: 1701382400)),

        Article(id: "wave-sound", title: "音波と共鳴", category: .waves,
                chapter: "第1章 波の基礎", order: 2,
                content: """
                ## 音波の性質

                音は空気（媒質）の疎密波（縦波）。常温での音速は

                $$v \\approx 331 + 0.6\\,t\\,\\mathrm{[m/s]}$$

                ($t$ は摂氏温度)。20°Cでは約 340 m/s。

                ## ドップラー効果

                音源または観測者が動くと観測される振動数が変化する（**ドップラー効果**）。

                $$f' = f \\cdot \\frac{V \\pm v_0}{V \\mp v_s}$$

                符号: 観測者が近づくとき $+$、遠ざかるとき $-$（分子）。音源が近づくとき $-$、遠ざかるとき $+$（分母）。

                ## 定常波と共鳴

                振幅・周期が等しく逆向きの2つの波が重なると**定常波**が生じる。節（振動しない点）と腹（最大振動）が固定される。

                開管（両端開放）の基本振動数:

                $$f_1 = \\frac{v}{2L}$$

                閉管（一端閉）の基本振動数:

                $$f_1 = \\frac{v}{4L}$$

                固有振動数に等しい振動数の音を当てると**共鳴**が起こり、音が増幅される。
                """,
                date: Date(timeIntervalSince1970: 1701468800)),

        Article(id: "wave-light", title: "光と干渉・回折", category: .waves,
                chapter: "第1章 波の基礎", order: 3,
                content: """
                ## 光の性質

                光は電磁波（横波）。真空中の速さ $c = 3.0 \\times 10^8\\,\\mathrm{m/s}$。屈折率 $n$ の媒質中では $v = c/n$。

                ## 反射・屈折

                **スネルの法則**（屈折の法則）:

                $$n_1 \\sin\\theta_1 = n_2 \\sin\\theta_2$$

                入射角が**臨界角**を超えると**全反射**が起こる。$\\sin\\theta_c = n_2/n_1$（$n_1 > n_2$）。

                ## ヤングの実験（光の干渉）

                スリット間隔 $d$、スリットからスクリーンまでの距離 $L$ として、明線（強め合い）の位置:

                $$\\Delta = d\\sin\\theta = m\\lambda \\quad (m = 0, \\pm1, \\pm2, \\ldots)$$

                明線の間隔: $\\Delta y = \\dfrac{L\\lambda}{d}$

                ## 薄膜干渉

                薄膜（厚さ $t$、屈折率 $n$）で光が干渉する。反射時の位相変化（固定端反射: $\\pi$ シフト）を考慮して

                強め合い: $2nt = \\left(m + \\dfrac{1}{2}\\right)\\lambda$（$m = 0, 1, 2,\\ldots$）
                """,
                date: Date(timeIntervalSince1970: 1701555200)),
    ]
}

// MARK: - 原子物理

private extension ArticleLibrary {
    static let atomic: [Article] = [
        Article(id: "atom-photoelectric", title: "光の量子性と光電効果", category: .atomic,
                chapter: "第1章 量子の世界", order: 1,
                content: """
                ## 古典物理の限界

                19世紀末、黒体輻射やコンプトン散乱などの現象は古典電磁気学では説明できなかった。そこで**光の量子論**が生まれた。

                ## 光子のエネルギー

                プランクが提唱し、アインシュタインが確立した光量子仮説: 光はエネルギー $E$ の粒子（**光子/フォトン**）として振る舞う。

                $$E = hf = \\frac{hc}{\\lambda}$$

                $h = 6.63 \\times 10^{-34}\\,\\mathrm{J\\cdot s}$ はプランク定数。

                ## 光電効果

                金属に光を当てると電子が飛び出す現象。**振動数**が仕事関数 $W$ に対応する閾値以上でないと電子は出ない（光の強さによらず）。

                飛び出した電子（光電子）の最大運動エネルギー:

                $$E_k = hf - W$$

                これは光の波動論では説明できず、光の粒子性を示す直接証拠となった。

                ## コンプトン散乱

                X線が電子に散乱されると波長が長くなる（**コンプトン効果**）。

                $$\\Delta\\lambda = \\frac{h}{m_e c}(1 - \\cos\\phi) \\approx 0.00243\\,(1 - \\cos\\phi)\\,\\mathrm{nm}$$

                [[ド・ブロイ波と電子の波動性]] と合わせて、量子力学の基礎を形成する。
                """,
                date: Date(timeIntervalSince1970: 1701641600)),

        Article(id: "atom-bohr", title: "原子モデルとボーアの量子条件", category: .atomic,
                chapter: "第1章 量子の世界", order: 2,
                content: """
                ## ラザフォードの原子モデル

                ラザフォードの散乱実験から、原子は中心に**正の核**（原子核）があり、周囲を電子が回っていることがわかった。しかし古典論では電子は核に落ちてしまうはずで、矛盾があった。

                ## ボーアの量子条件

                ボーアは「電子の軌道には量子条件がある」と仮定した。水素原子で軌道の量子数を $n = 1, 2, 3, \\ldots$ とすると

                $$m_e v r_n = n\\hbar, \\quad \\hbar = \\frac{h}{2\\pi}$$

                これと[[クーロンの法則と電場]]の静電引力による円運動を組み合わせると

                **ボーア半径**: $r_n = n^2 a_0$（$a_0 = 0.529\\,\\mathrm{\\AA}$）

                ## エネルギー準位

                各軌道でのエネルギー:

                $$E_n = -\\frac{13.6}{n^2}\\,\\mathrm{eV}$$

                電子が $n_i \\to n_f$ に遷移するとき、光子が放出または吸収される。

                $$hf = E_{n_i} - E_{n_f}$$

                水素の輝線スペクトル（バルマー系列 $n_f = 2$）はこれで完全に説明される。
                """,
                date: Date(timeIntervalSince1970: 1701728000)),

        Article(id: "atom-nuclear", title: "核反応と放射線", category: .atomic,
                chapter: "第1章 量子の世界", order: 3,
                content: """
                ## 原子核の構成

                原子核は**陽子**（$p$, 電荷 $+e$）と**中性子**（$n$, 電荷 0）からなる。原子番号 $Z$（陽子数）、質量数 $A$（核子数）で核種を表す: ${}^A_Z X$。

                ## 放射線の種類

                | 種類 | 実体 | 電離能 | 透過力 |
                |---|---|---|---|
                | $\\alpha$ 線 | He 核 | 大 | 小 |
                | $\\beta$ 線 | 電子 | 中 | 中 |
                | $\\gamma$ 線 | 光子 | 小 | 大 |

                ## 放射性崩壊と半減期

                放射性核種の数 $N$ は指数的に減少する。**半減期** $T_{1/2}$ で半分になる。

                $$N(t) = N_0 \\left(\\frac{1}{2}\\right)^{t/T_{1/2}} = N_0 e^{-\\lambda t}$$

                $\\lambda = \\ln 2 / T_{1/2}$ は崩壊定数。

                ## 質量欠損とエネルギー

                核子がバラバラのときより、核を形成したときのほうが質量が小さい（**質量欠損** $\\Delta m$）。このエネルギーが**結合エネルギー**。

                $$E = \\Delta m \\cdot c^2$$

                核融合・核分裂ではこの質量エネルギーが解放される。[[特殊相対性理論の基礎]] の $E = mc^2$ が鍵。
                """,
                date: Date(timeIntervalSince1970: 1701814400)),
    ]
}

// MARK: - 相対論

private extension ArticleLibrary {
    static let relativity: [Article] = [
        Article(id: "rel-special", title: "特殊相対性理論の基礎", category: .relativity,
                chapter: "第1章 相対性理論入門", order: 1,
                content: """
                ## アインシュタインの2つの原理

                1905年、アインシュタインは2つの仮定から特殊相対性理論を構築した。

                1. **相対性原理**: すべての慣性系で物理法則は同じ形をもつ。
                2. **光速度不変の原理**: 光速 $c$ はどの慣性系でも同じ。

                古典力学の絶対時間・絶対空間の概念は放棄される。

                ## 時間の遅れ（時間膨張）

                速度 $v$ で動く系での固有時間 $\\tau$ と、静止系での時間 $t$ の関係:

                $$t = \\gamma \\tau, \\quad \\gamma = \\frac{1}{\\sqrt{1 - v^2/c^2}}$$

                $\\gamma \\geq 1$（ローレンツ因子）なので、動いている時計は遅れて見える。

                ## 長さの収縮

                速度 $v$ で動く物体の固有長 $L_0$ は、静止系では短く観測される。

                $$L = \\frac{L_0}{\\gamma}$$

                ## 質量とエネルギーの等価性

                最も有名な式の一つ。静止エネルギー $E_0$ は

                $$E_0 = m_0 c^2$$

                運動エネルギーを含む全エネルギー:

                $$E = \\gamma m_0 c^2 = \\frac{m_0 c^2}{\\sqrt{1 - v^2/c^2}}$$

                [[核反応と放射線]] での質量欠損がエネルギーに変換されるのはまさにこの関係による。
                """,
                date: Date(timeIntervalSince1970: 1701900800)),

        Article(id: "rel-spacetime", title: "時空図と相対論的効果", category: .relativity,
                chapter: "第1章 相対性理論入門", order: 2,
                content: """
                ## ミンコフスキー時空

                相対論では時間と空間を統合した**4次元時空**（ミンコフスキー空間）で考える。

                2点間の**時空間隔** $s$ は慣性系によらず不変（ローレンツ不変量）。

                $$s^2 = c^2t^2 - x^2 - y^2 - z^2$$

                ## ローレンツ変換

                慣性系 $S$ と $S'$（$v$ で等速移動）の間の時空座標の変換:

                $$x' = \\gamma(x - vt), \\quad t' = \\gamma\\left(t - \\frac{v}{c^2}x\\right)$$

                ## 相対論的速度の合成

                古典力学の速度合成 $w = u + v$ は相対論では

                $$w = \\frac{u + v}{1 + uv/c^2}$$

                どんな速度を合成しても $c$ を超えない。

                ## 双子のパラドックス

                宇宙旅行した双子と地球に残った双子では旅行した側が若い（時間膨張）。これは矛盾ではなく、加速度の非対称性で説明される。[[特殊相対性理論の基礎]] を先に読もう。
                """,
                date: Date(timeIntervalSince1970: 1701987200)),
    ]
}

// MARK: - 数学補講

private extension ArticleLibrary {
    static let math: [Article] = [
        Article(id: "math-vector", title: "ベクトルと座標系", category: .math,
                chapter: "第1章 物理の数学", order: 1,
                content: """
                ## ベクトルの基本

                大きさと向きをもつ量が**ベクトル**（矢印で表す）。大きさだけをもつ量が**スカラー**。

                2次元ベクトル: $\\vec{A} = (A_x, A_y)$

                大きさ: $|\\vec{A}| = \\sqrt{A_x^2 + A_y^2}$

                ## 内積（スカラー積）

                $$\\vec{A} \\cdot \\vec{B} = |A||B|\\cos\\theta = A_x B_x + A_y B_y + A_z B_z$$

                仕事 $W = \\vec{F} \\cdot \\vec{d}$ など、物理で頻出。

                ## 外積（ベクトル積）

                $$|\\vec{A} \\times \\vec{B}| = |A||B|\\sin\\theta$$

                方向は右手則。回転・角運動量・磁力など「向きが重要」な場面で使う。

                $$\\vec{F} = q\\vec{v} \\times \\vec{B}$$

                ## 極座標と円筒座標

                円運動や球対称問題では極座標が便利。

                $$x = r\\cos\\theta, \\quad y = r\\sin\\theta$$

                $$r = \\sqrt{x^2 + y^2}, \\quad \\theta = \\arctan(y/x)$$
                """,
                date: Date(timeIntervalSince1970: 1702073600)),

        Article(id: "math-calculus", title: "微分積分の物理への応用", category: .math,
                chapter: "第1章 物理の数学", order: 2,
                content: """
                ## 微分の物理的意味

                微分は「瞬間の変化率」。[[速度と加速度]] で見たように

                $$v = \\frac{dx}{dt}, \\quad a = \\frac{dv}{dt} = \\frac{d^2x}{dt^2}$$

                ## よく使う微分公式

                $$\\frac{d}{dt}(t^n) = nt^{n-1}, \\quad \\frac{d}{dt}(\\sin\\omega t) = \\omega\\cos\\omega t$$
                $$\\frac{d}{dt}(e^{\\alpha t}) = \\alpha e^{\\alpha t}$$

                ## 積分の物理的意味

                積分は「累積」「面積」。速度を積分すると変位、力を積分すると仕事。

                $$x(t) = \\int v\\,dt, \\quad W = \\int F\\,dx$$

                ## ガウス積分

                量子力学・熱統計力学で頻出の公式:

                $$\\int_{-\\infty}^{\\infty} e^{-ax^2}dx = \\sqrt{\\frac{\\pi}{a}}$$

                ## 微分方程式

                物理法則の多くは微分方程式として表現される。単振動の方程式

                $$\\frac{d^2x}{dt^2} = -\\omega^2 x$$

                の解 $x = A\\cos(\\omega t + \\phi)$ は[[円運動と単振動]] に対応する。
                """,
                date: Date(timeIntervalSince1970: 1702160000)),
    ]
}

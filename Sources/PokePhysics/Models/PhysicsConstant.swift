import Foundation

struct PhysicsConstant: Identifiable, Hashable {
    let id: String
    let name: String
    let symbolLatex: String
    let value: String
    let unit: String
    let summary: String
}

struct PhysicsConstantCategory: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let constants: [PhysicsConstant]
}

struct ConstantLibrary {
    static let allCategories: [PhysicsConstantCategory] = [
        PhysicsConstantCategory(
            id: "basic",
            name: "基本定数",
            icon: "sparkles",
            constants: [
                PhysicsConstant(
                    id: "speed-of-light",
                    name: "真空中の光速",
                    symbolLatex: "c",
                    value: "2.99792458 × 10⁸",
                    unit: "m/s",
                    summary: "電磁波が真空中を進む速さ。相対論や光波で使う。"
                ),
                PhysicsConstant(
                    id: "planck",
                    name: "プランク定数",
                    symbolLatex: "h",
                    value: "6.62607015 × 10⁻³⁴",
                    unit: "J·s",
                    summary: "光子のエネルギーや物質波を扱う量子定数。"
                ),
                PhysicsConstant(
                    id: "elementary-charge",
                    name: "電気素量",
                    symbolLatex: "e",
                    value: "1.602176634 × 10⁻¹⁹",
                    unit: "C",
                    summary: "陽子1個の電荷の大きさ。電子の電荷は -e。"
                ),
                PhysicsConstant(
                    id: "avogadro",
                    name: "アボガドロ定数",
                    symbolLatex: "N_A",
                    value: "6.02214076 × 10²³",
                    unit: "mol⁻¹",
                    summary: "1 mol あたりに含まれる粒子数。"
                )
            ]
        ),
        PhysicsConstantCategory(
            id: "mechanics",
            name: "力学",
            icon: "arrow.up.right.circle",
            constants: [
                PhysicsConstant(
                    id: "gravity",
                    name: "標準重力加速度",
                    symbolLatex: "g",
                    value: "9.80665",
                    unit: "m/s²",
                    summary: "地表付近では 9.8 m/s² と近似して使うことが多い。"
                ),
                PhysicsConstant(
                    id: "gravitational-constant",
                    name: "万有引力定数",
                    symbolLatex: "G",
                    value: "6.67430 × 10⁻¹¹",
                    unit: "N·m²/kg²",
                    summary: "万有引力の大きさを決める比例定数。"
                )
            ]
        ),
        PhysicsConstantCategory(
            id: "thermodynamics",
            name: "熱・気体",
            icon: "thermometer.medium",
            constants: [
                PhysicsConstant(
                    id: "gas-constant",
                    name: "気体定数",
                    symbolLatex: "R",
                    value: "8.314462618",
                    unit: "J/(mol·K)",
                    summary: "理想気体の状態方程式 PV = nRT で使う。"
                ),
                PhysicsConstant(
                    id: "boltzmann",
                    name: "ボルツマン定数",
                    symbolLatex: "k",
                    value: "1.380649 × 10⁻²³",
                    unit: "J/K",
                    summary: "温度と分子1個あたりのエネルギーを結びつける定数。"
                ),
                PhysicsConstant(
                    id: "standard-atmosphere",
                    name: "標準大気圧",
                    symbolLatex: "1\\ \\mathrm{atm}",
                    value: "1.01325 × 10⁵",
                    unit: "Pa",
                    summary: "1気圧を SI 単位で表した値。"
                )
            ]
        ),
        PhysicsConstantCategory(
            id: "electromagnetism",
            name: "電磁気",
            icon: "bolt.circle",
            constants: [
                PhysicsConstant(
                    id: "coulomb-constant",
                    name: "クーロン定数",
                    symbolLatex: "k",
                    value: "8.9875517923 × 10⁹",
                    unit: "N·m²/C²",
                    summary: "点電荷どうしに働く静電気力を決める定数。"
                ),
                PhysicsConstant(
                    id: "vacuum-permittivity",
                    name: "真空の誘電率",
                    symbolLatex: "\\varepsilon_0",
                    value: "8.8541878128 × 10⁻¹²",
                    unit: "F/m",
                    summary: "電場やコンデンサーの式に現れる真空の定数。"
                ),
                PhysicsConstant(
                    id: "vacuum-permeability",
                    name: "真空の透磁率",
                    symbolLatex: "\\mu_0",
                    value: "1.25663706212 × 10⁻⁶",
                    unit: "N/A²",
                    summary: "磁場や電磁波の式に現れる真空の定数。"
                ),
                PhysicsConstant(
                    id: "faraday",
                    name: "ファラデー定数",
                    symbolLatex: "F",
                    value: "9.648533212 × 10⁴",
                    unit: "C/mol",
                    summary: "電子1 mol 分の電気量。電気分解で使う。"
                )
            ]
        ),
        PhysicsConstantCategory(
            id: "atomic",
            name: "原子・核",
            icon: "atom",
            constants: [
                PhysicsConstant(
                    id: "electron-mass",
                    name: "電子の質量",
                    symbolLatex: "m_e",
                    value: "9.1093837 × 10⁻³¹",
                    unit: "kg",
                    summary: "電子1個の質量。"
                ),
                PhysicsConstant(
                    id: "proton-mass",
                    name: "陽子の質量",
                    symbolLatex: "m_p",
                    value: "1.6726219 × 10⁻²⁷",
                    unit: "kg",
                    summary: "陽子1個の質量。"
                ),
                PhysicsConstant(
                    id: "atomic-mass-unit",
                    name: "統一原子質量単位",
                    symbolLatex: "u",
                    value: "1.66053906660 × 10⁻²⁷",
                    unit: "kg",
                    summary: "原子や原子核の質量を表す単位。"
                ),
                PhysicsConstant(
                    id: "rydberg",
                    name: "リュードベリ定数",
                    symbolLatex: "R_\\infty",
                    value: "1.0973731568 × 10⁷",
                    unit: "m⁻¹",
                    summary: "水素原子のスペクトル計算で使う定数。"
                ),
                PhysicsConstant(
                    id: "electron-volt",
                    name: "電子ボルト",
                    symbolLatex: "1\\ \\mathrm{eV}",
                    value: "1.602176634 × 10⁻¹⁹",
                    unit: "J",
                    summary: "電子1個が1 V の電位差で得るエネルギー。"
                )
            ]
        )
    ]
}

import Foundation

// Central registry of all categories used across the app.
struct FormulaLibrary {
    static let allCategories: [FormulaCategory] = [
        .sampleMechanics,
        .sampleElectromagnetism,
        .sampleThermodynamics,
        .sampleWaves,
        .sampleAtomicPhysics
    ]

    static func formula(by id: UUID) -> Formula? {
        allCategories.flatMap(\.formulas).first { $0.id == id }
    }

    static func relatedFormulas(for formula: Formula) -> [Formula] {
        formula.relatedFormulaIDs.compactMap { Self.formula(by: $0) }
    }
}

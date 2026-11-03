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

    // 公式カテゴリ → 教科書 ArticleCategory の対応
    static func articleCategory(for formulaCategory: FormulaCategory) -> ArticleCategory? {
        switch formulaCategory.name {
        case "力学":        return .mechanics
        case "電磁気学":    return .electromagnetism
        case "熱力学":      return .thermodynamics
        case "波動":        return .waves
        case "原子物理":    return .atomic
        default:            return nil
        }
    }

    // 公式に関連する教科書記事を返す（同カテゴリ + サブカテゴリ名が含まれる記事）
    static func relatedArticles(for formula: Formula) -> [Article] {
        guard let cat = allCategories.first(where: { $0.formulas.contains(formula) }),
              let articleCat = articleCategory(for: cat) else { return [] }
        let candidates = ArticleLibrary.articles(for: articleCat)
        // サブカテゴリ名 or タイトルがマッチする記事を優先
        let scored = candidates.map { art -> (Article, Int) in
            var score = 0
            if !formula.subcategory.isEmpty && art.title.contains(formula.subcategory) { score += 2 }
            if art.content.contains(formula.title) { score += 1 }
            return (art, score)
        }
        let sorted = scored.sorted { $0.1 > $1.1 }.map(\.0)
        return Array(sorted.prefix(3))
    }
}

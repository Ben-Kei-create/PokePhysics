import Foundation

enum ExamTag: String, Codable, Hashable, CaseIterable {
    case common   = "共通テスト頻出"
    case advanced = "二次・私大"
    case none     = ""
}

struct Formula: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let latex: String
    let summary: String
    let symbols: [FormulaSymbol]
    let conditions: String
    let relatedFormulaIDs: [UUID]
    let subcategory: String
    let examTag: ExamTag
    let example: String?

    init(
        id: UUID = UUID(),
        title: String,
        latex: String,
        summary: String,
        symbols: [FormulaSymbol] = [],
        conditions: String = "",
        relatedFormulaIDs: [UUID] = [],
        subcategory: String = "",
        examTag: ExamTag = .none,
        example: String? = nil
    ) {
        self.id = id
        self.title = title
        self.latex = latex
        self.summary = summary
        self.symbols = symbols
        self.conditions = conditions
        self.relatedFormulaIDs = relatedFormulaIDs
        self.subcategory = subcategory
        self.examTag = examTag
        self.example = example
    }
}

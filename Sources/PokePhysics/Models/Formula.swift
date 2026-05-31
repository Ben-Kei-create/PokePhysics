import Foundation

struct Formula: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let latex: String
    let summary: String
    let symbols: [FormulaSymbol]
    let conditions: String
    let relatedFormulaIDs: [UUID]
    let subcategory: String

    init(
        id: UUID = UUID(),
        title: String,
        latex: String,
        summary: String,
        symbols: [FormulaSymbol] = [],
        conditions: String = "",
        relatedFormulaIDs: [UUID] = [],
        subcategory: String = ""
    ) {
        self.id = id
        self.title = title
        self.latex = latex
        self.summary = summary
        self.symbols = symbols
        self.conditions = conditions
        self.relatedFormulaIDs = relatedFormulaIDs
        self.subcategory = subcategory
    }
}

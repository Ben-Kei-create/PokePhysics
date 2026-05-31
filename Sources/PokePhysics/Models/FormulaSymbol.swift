import Foundation

struct FormulaSymbol: Identifiable, Codable, Hashable {
    let id: UUID
    let symbol: String
    let description: String

    init(id: UUID = UUID(), symbol: String, description: String) {
        self.id = id
        self.symbol = symbol
        self.description = description
    }
}

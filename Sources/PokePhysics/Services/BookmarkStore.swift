import Combine
import Foundation

final class BookmarkStore: ObservableObject {
    @Published private(set) var bookmarkedIDs: Set<UUID>

    private let defaultsKey = "bookmarkedFormulaIDs"

    init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let ids = try? JSONDecoder().decode([UUID].self, from: data) {
            bookmarkedIDs = Set(ids)
        } else {
            bookmarkedIDs = []
        }
    }

    func toggle(_ formula: Formula) {
        if bookmarkedIDs.contains(formula.id) {
            bookmarkedIDs.remove(formula.id)
        } else {
            bookmarkedIDs.insert(formula.id)
        }
        persist()
    }

    func isBookmarked(_ formula: Formula) -> Bool {
        bookmarkedIDs.contains(formula.id)
    }

    private func persist() {
        let ids = Array(bookmarkedIDs)
        if let data = try? JSONEncoder().encode(ids) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
}

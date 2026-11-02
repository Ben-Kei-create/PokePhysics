import Foundation

enum ArticleCategory: String, Codable, CaseIterable, Hashable {
    case mechanics       = "mechanics"
    case electromagnetism = "electromagnetism"
    case thermodynamics  = "thermodynamics"
    case waves           = "waves"
    case atomic          = "atomic"
    case relativity      = "relativity"
    case math            = "math"

    var localizedName: String {
        switch self {
        case .mechanics:        return "力学"
        case .electromagnetism: return "電磁気学"
        case .thermodynamics:   return "熱力学"
        case .waves:            return "波動"
        case .atomic:           return "原子物理"
        case .relativity:       return "相対論"
        case .math:             return "数学補講"
        }
    }

    var icon: String {
        switch self {
        case .mechanics:        return "arrow.up.right.circle"
        case .electromagnetism: return "bolt.circle"
        case .thermodynamics:   return "flame.circle"
        case .waves:            return "waveform"
        case .atomic:           return "atom"
        case .relativity:       return "infinity.circle"
        case .math:             return "function"
        }
    }

    var color: String { "navyAccent" }
}

struct Article: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let category: ArticleCategory
    let chapter: String
    let order: Int
    let content: String
    let date: Date

    var excerpt: String {
        let cleaned = content
            .replacingOccurrences(of: #"\$\$.*?\$\$"#, with: "〔数式〕", options: .regularExpression)
            .replacingOccurrences(of: #"\$.*?\$"#, with: "〔数式〕", options: .regularExpression)
            .replacingOccurrences(of: #"\[\[.*?\]\]"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"#{1,3} "#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\*\*|__|\*|_"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #":::.*?:::"#, with: "", options: [.regularExpression, .dotMatchesLineSeparators])
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let first = cleaned.components(separatedBy: "\n").first(where: { !$0.isEmpty }) ?? ""
        return String(first.prefix(100))
    }

    var sections: [ArticleSection] {
        ArticleSection.split(content: content)
    }
}

struct ArticleSection: Identifiable {
    let id: String
    let number: Int
    let title: String
    let markdown: String

    static func split(content: String) -> [ArticleSection] {
        let lines = content.components(separatedBy: "\n")
        var sections: [ArticleSection] = []
        var current: (title: String, lines: [String]) = ("導入", [])
        var sectionIndex = 0

        for line in lines {
            if line.hasPrefix("## ") {
                if sectionIndex > 0 || !current.lines.isEmpty {
                    sections.append(ArticleSection(
                        id: "section-\(sectionIndex)",
                        number: sectionIndex,
                        title: current.title,
                        markdown: current.lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                    ))
                }
                sectionIndex += 1
                current = (title: String(line.dropFirst(3)), lines: [])
            } else {
                current.lines.append(line)
            }
        }

        if !current.lines.joined().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !sections.isEmpty {
            sections.append(ArticleSection(
                id: "section-\(sectionIndex)",
                number: sectionIndex,
                title: current.title,
                markdown: current.lines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            ))
        }

        return sections.isEmpty ? [ArticleSection(id: "section-0", number: 0, title: "本文", markdown: content)] : sections
    }
}

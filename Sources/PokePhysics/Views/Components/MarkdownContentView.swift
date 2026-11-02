import SwiftUI

// MARK: - Block model

enum MDBlock: Equatable {
    case heading(level: Int, text: String)
    case paragraph(spans: [MDSpan])
    case displayMath(latex: String)
    case figure(title: String, lines: [String])
    case divider
}

enum MDSpan: Equatable {
    case text(String)
    case bold(String)
    case italic(String)
    case inlineMath(String)
    case wikiLink(target: String, display: String)
}

// MARK: - Parser

enum MDParser {
    static func parse(_ markdown: String) -> [MDBlock] {
        var blocks: [MDBlock] = []
        let lines = markdown.components(separatedBy: "\n")
        var i = 0

        while i < lines.count {
            let line = lines[i]

            // Figure block
            if line.trimmingCharacters(in: .whitespaces).hasPrefix(":::figure") {
                let title = String(line.trimmingCharacters(in: .whitespaces).dropFirst(":::figure".count)).trimmingCharacters(in: .whitespaces)
                var figLines: [String] = []
                i += 1
                while i < lines.count && !lines[i].trimmingCharacters(in: .whitespaces).hasPrefix(":::") {
                    let fl = lines[i].trimmingCharacters(in: .whitespaces)
                    if !fl.isEmpty { figLines.append(fl) }
                    i += 1
                }
                blocks.append(.figure(title: title, lines: figLines))
                i += 1
                continue
            }

            // Display math
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("$$") {
                var mathLines: [String] = [String(line.trimmingCharacters(in: .whitespaces).dropFirst(2))]
                i += 1
                while i < lines.count && !lines[i].trimmingCharacters(in: .whitespaces).hasPrefix("$$") {
                    mathLines.append(lines[i])
                    i += 1
                }
                // Drop trailing $$
                if i < lines.count { i += 1 }
                var latex = mathLines.joined(separator: " ").trimmingCharacters(in: .whitespaces)
                if latex.hasSuffix("$$") { latex = String(latex.dropLast(2)).trimmingCharacters(in: .whitespaces) }
                blocks.append(.displayMath(latex: latex))
                continue
            }

            // Heading
            if line.hasPrefix("### ") {
                blocks.append(.heading(level: 3, text: String(line.dropFirst(4))))
                i += 1; continue
            }
            if line.hasPrefix("## ") {
                blocks.append(.heading(level: 2, text: String(line.dropFirst(3))))
                i += 1; continue
            }
            if line.hasPrefix("# ") {
                blocks.append(.heading(level: 1, text: String(line.dropFirst(2))))
                i += 1; continue
            }

            // Divider
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("---") {
                blocks.append(.divider)
                i += 1; continue
            }

            // Empty line — collect paragraph lines until next blank
            if line.trimmingCharacters(in: .whitespaces).isEmpty {
                i += 1; continue
            }

            // Paragraph: collect non-empty, non-structural lines
            var paraLines: [String] = []
            while i < lines.count {
                let l = lines[i]
                if l.trimmingCharacters(in: .whitespaces).isEmpty { break }
                if l.hasPrefix("## ") || l.hasPrefix("### ") || l.hasPrefix("# ") { break }
                if l.trimmingCharacters(in: .whitespaces).hasPrefix("$$") { break }
                if l.trimmingCharacters(in: .whitespaces).hasPrefix(":::") { break }
                if l.trimmingCharacters(in: .whitespaces).hasPrefix("---") { break }
                paraLines.append(l)
                i += 1
            }
            if !paraLines.isEmpty {
                let combined = paraLines.joined(separator: " ")
                blocks.append(.paragraph(spans: parseInline(combined)))
            }
        }
        return blocks
    }

    // MARK: Inline parser

    static func parseInline(_ text: String) -> [MDSpan] {
        var spans: [MDSpan] = []
        var remaining = text[text.startIndex...]

        while !remaining.isEmpty {
            // Wiki link [[target|display]] or [[target]]
            if let wikiStart = remaining.range(of: "[[") {
                let before = String(remaining[remaining.startIndex..<wikiStart.lowerBound])
                if !before.isEmpty {
                    spans += parseSimpleInline(before)
                }
                let afterOpen = remaining[wikiStart.upperBound...]
                if let wikiEnd = afterOpen.range(of: "]]") {
                    let inner = String(afterOpen[afterOpen.startIndex..<wikiEnd.lowerBound])
                    let parts = inner.split(separator: "|", maxSplits: 1)
                    let target = String(parts[0])
                    let display = parts.count > 1 ? String(parts[1]) : target
                    spans.append(.wikiLink(target: target, display: display))
                    remaining = afterOpen[wikiEnd.upperBound...]
                } else {
                    spans += parseSimpleInline(String(remaining))
                    break
                }
            } else {
                spans += parseSimpleInline(String(remaining))
                break
            }
        }
        return spans
    }

    private static func parseSimpleInline(_ text: String) -> [MDSpan] {
        var spans: [MDSpan] = []
        var s = text[text.startIndex...]

        while !s.isEmpty {
            // Inline math $...$
            if let dollarRange = s.range(of: "$") {
                let before = String(s[s.startIndex..<dollarRange.lowerBound])
                if !before.isEmpty { spans += parseEmphasis(before) }
                let afterDollar = s[dollarRange.upperBound...]
                if let endDollar = afterDollar.range(of: "$") {
                    let math = String(afterDollar[afterDollar.startIndex..<endDollar.lowerBound])
                    spans.append(.inlineMath(math))
                    s = afterDollar[endDollar.upperBound...]
                } else {
                    spans += parseEmphasis(String(s))
                    break
                }
            } else {
                spans += parseEmphasis(String(s))
                break
            }
        }
        return spans
    }

    private static func parseEmphasis(_ text: String) -> [MDSpan] {
        // Handle **bold** and _italic_
        var spans: [MDSpan] = []
        var s = text[text.startIndex...]

        while !s.isEmpty {
            if let boldRange = s.range(of: "**") {
                let before = String(s[s.startIndex..<boldRange.lowerBound])
                if !before.isEmpty { spans.append(.text(before)) }
                let afterBold = s[boldRange.upperBound...]
                if let endBold = afterBold.range(of: "**") {
                    let bold = String(afterBold[afterBold.startIndex..<endBold.lowerBound])
                    spans.append(.bold(bold))
                    s = afterBold[endBold.upperBound...]
                } else {
                    spans.append(.text(String(s)))
                    break
                }
            } else {
                if !String(s).isEmpty { spans.append(.text(String(s))) }
                break
            }
        }
        return spans
    }
}

// MARK: - MarkdownContentView

struct MarkdownContentView: View {
    let markdown: String
    var onWikiLinkTap: ((String) -> Void)? = nil
    @Environment(\.colorScheme) private var scheme

    private var blocks: [MDBlock] { MDParser.parse(markdown) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(blocks.indices, id: \.self) { i in
                blockView(for: blocks[i])
                    .padding(.bottom, blockSpacing(blocks[i]))
            }
        }
    }

    private func blockSpacing(_ block: MDBlock) -> CGFloat {
        switch block {
        case .heading: return 10
        case .displayMath: return 16
        case .figure: return 16
        case .divider: return 16
        case .paragraph: return 12
        }
    }

    @ViewBuilder
    private func blockView(for block: MDBlock) -> some View {
        switch block {
        case .heading(let level, let text):
            headingView(level: level, text: text)

        case .paragraph(let spans):
            spanFlow(spans: spans)

        case .displayMath(let latex):
            LaTeXView(latex: latex, fontSize: 24, textColor: scheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .padding(.vertical, 8)

        case .figure(let title, let lines):
            FigureBlockView(title: title, lines: lines)

        case .divider:
            Divider().padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private func headingView(level: Int, text: String) -> some View {
        let (font, topPad): (Font, CGFloat) = {
            switch level {
            case 1: return (.title2.weight(.bold), 24)
            case 2: return (.title3.weight(.bold), 20)
            default: return (.headline, 12)
            }
        }()
        Text(text)
            .font(font)
            .foregroundColor(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, topPad)
    }

    private func spanFlow(spans: [MDSpan]) -> some View {
        FlowLayout(alignment: .center, horizontalSpacing: 2, verticalSpacing: 6) {
            ForEach(spans.indices, id: \.self) { i in
                spanView(for: spans[i])
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func spanView(for span: MDSpan) -> some View {
        switch span {
        case .text(let t):
            Text(t).font(.body).foregroundColor(.primary)
        case .bold(let t):
            Text(t).font(.body.bold()).foregroundColor(.primary)
        case .italic(let t):
            Text(t).font(.body.italic()).foregroundColor(.primary)
        case .inlineMath(let latex):
            LaTeXView(latex: latex, fontSize: 16, textColor: scheme == .dark ? .white : .black)
                .frame(height: 24)
                .fixedSize(horizontal: true, vertical: false)
        case .wikiLink(let target, let display):
            Button {
                onWikiLinkTap?(target)
            } label: {
                Text(display)
                    .font(.body)
                    .foregroundColor(.navyAccent)
                    .underline()
            }
            .buttonStyle(.plain)
        }
    }

}

// MARK: - Figure Block

private struct FigureBlockView: View {
    let title: String
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !title.isEmpty {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.navyAccent)
            }
            ForEach(lines.indices, id: \.self) { i in
                let line = lines[i]
                if line.hasPrefix("caption:") || line.hasPrefix("note:") {
                    Text(String(line.drop(while: { $0 != ":" }).dropFirst()).trimmingCharacters(in: .whitespaces))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                } else if line.contains("->") || line.contains("<->") {
                    flowDiagram(line: line)
                } else {
                    Text(line)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.navyAccent.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.navyAccent.opacity(0.15), lineWidth: 1)
                )
        )
    }

    @ViewBuilder
    private func flowDiagram(line: String) -> some View {
        let parts = line.components(separatedBy: " -> ")
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(parts.indices, id: \.self) { i in
                    Text(parts[i])
                        .font(.caption.weight(.medium))
                        .foregroundColor(.navyAccent)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Color.navyAccent.opacity(0.1)))
                    if i < parts.count - 1 {
                        Image(systemName: "arrow.right")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}


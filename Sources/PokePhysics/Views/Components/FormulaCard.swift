import SwiftUI
import UIKit

struct FormulaCard: View {
    @Environment(\.colorScheme) private var scheme
    let formula: Formula

    @EnvironmentObject private var bookmarkStore: BookmarkStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(formula.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Button {
                    bookmarkStore.toggle(formula)
                } label: {
                    Image(systemName: bookmarkStore.isBookmarked(formula) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.navyAccent)
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }

            LaTeXView(
                latex: formula.latex,
                fontSize: 26,
                textColor: scheme == .dark ? .white : .black
            )
            .frame(maxWidth: .infinity)
            .frame(height: 44)

            HStack(alignment: .bottom) {
                Text(formula.summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()

                if formula.examTag != .none {
                    ExamTagBadge(tag: formula.examTag)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.navyButton.opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}

// MARK: - Tag Badge

struct ExamTagBadge: View {
    let tag: ExamTag

    private var color: Color {
        switch tag {
        case .common:   return .teal
        case .advanced: return .orange
        case .none:     return .clear
        }
    }

    var body: some View {
        Text(tag.rawValue)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(
                Capsule().stroke(color.opacity(0.7), lineWidth: 1)
                    .background(Capsule().fill(color.opacity(0.08)))
            )
    }
}

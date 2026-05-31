import SwiftUI

struct FormulaCard: View {
    let formula: Formula

    @EnvironmentObject private var bookmarkStore: BookmarkStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(formula.title)
                    .font(.headline)
                    .foregroundColor(Color(hex: "1F355C"))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Button {
                    bookmarkStore.toggle(formula)
                } label: {
                    Image(systemName: bookmarkStore.isBookmarked(formula) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color(hex: "1F355C"))
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }

            LaTeXView(latex: formula.latex, fontSize: 26)
                .frame(maxWidth: .infinity)
                .frame(height: 44)

            Text(formula.summary)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color(hex: "1F355C").opacity(0.08), radius: 12, x: 0, y: 4)
        )
    }
}

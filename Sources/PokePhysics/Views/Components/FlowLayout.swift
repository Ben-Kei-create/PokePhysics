import SwiftUI

struct FlowLayout: Layout {
    var alignment: VerticalAlignment = .center
    var horizontalSpacing: CGFloat = 4
    var verticalSpacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                height += rowHeight + verticalSpacing
                x = 0
                rowHeight = 0
            }
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        var rowViews: [(view: LayoutSubview, size: CGSize, x: CGFloat)] = []

        func flushRow() {
            for (view, size, vx) in rowViews {
                let dy: CGFloat
                switch alignment {
                case .center: dy = (rowHeight - size.height) / 2
                case .top:    dy = 0
                default:      dy = rowHeight - size.height
                }
                view.place(at: CGPoint(x: vx, y: y + dy), proposal: ProposedViewSize(size))
            }
            y += rowHeight + verticalSpacing
            rowViews = []
            rowHeight = 0
        }

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && !rowViews.isEmpty {
                flushRow()
                x = bounds.minX
            }
            rowViews.append((view, size, x))
            rowHeight = max(rowHeight, size.height)
            x += size.width + horizontalSpacing
        }
        flushRow()
    }
}

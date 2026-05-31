import SwiftUI
import UIKit

struct LaTeXView: UIViewRepresentable {
    let latex: String
    var fontSize: CGFloat = 28
    var textColor: UIColor = .label  // adaptive; override in FormulaDetailView

    func makeUIView(context: Context) -> FittingMathContainerView {
        FittingMathContainerView()
    }

    func updateUIView(_ uiView: FittingMathContainerView, context: Context) {
        uiView.configure(latex: latex, fontSize: fontSize, textColor: textColor)
    }
}

final class FittingMathContainerView: UIView {
    private let mathView: UIView
    private let fallbackLabel: UILabel?

    override init(frame: CGRect) {
        guard let labelType = NSClassFromString("MTMathUILabel") as? UIView.Type else {
            let fallback = UILabel()
            fallback.textAlignment = .center
            fallback.numberOfLines = 1
            mathView = fallback
            fallbackLabel = fallback
            super.init(frame: frame)
            addSubview(fallback)
            clipsToBounds = true
            return
        }

        let label = labelType.init(frame: .zero)
        label.setValue(1, forKey: "textAlignment")
        label.setValue(1, forKey: "labelMode")
        mathView = label
        fallbackLabel = nil

        super.init(frame: frame)
        addSubview(label)
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(latex: String, fontSize: CGFloat, textColor: UIColor) {
        if let fallback = fallbackLabel {
            fallback.text = latex
            fallback.font = .systemFont(ofSize: fontSize)
            fallback.textColor = textColor
        } else {
            mathView.setValue(latex, forKey: "latex")
            mathView.setValue(fontSize, forKey: "fontSize")
            mathView.setValue(textColor, forKey: "textColor")
        }

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let availableWidth = max(bounds.width, 1)
        let availableHeight = max(bounds.height, 1)
        let measuredSize = mathView.sizeThatFits(
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        )
        let contentSize = CGSize(
            width: max(measuredSize.width, 1),
            height: max(measuredSize.height, 1)
        )
        let scale = min(1, availableWidth / contentSize.width, availableHeight / contentSize.height)

        mathView.bounds = CGRect(origin: .zero, size: contentSize)
        mathView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        mathView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}

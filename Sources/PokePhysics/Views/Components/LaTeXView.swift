import SwiftUI
import UIKit

struct LaTeXView: UIViewRepresentable {
    let latex: String
    var fontSize: CGFloat = 28
    var textColor: UIColor = .label  // adaptive; override in FormulaDetailView

    func makeUIView(context: Context) -> UIView {
        guard let labelType = NSClassFromString("MTMathUILabel") as? UIView.Type else {
            let fallback = UILabel()
            fallback.textAlignment = .center
            fallback.numberOfLines = 1
            return fallback
        }

        let label = labelType.init(frame: .zero)
        label.setValue(1, forKey: "textAlignment")
        label.setValue(1, forKey: "labelMode")
        return label
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let fallback = uiView as? UILabel {
            fallback.text = latex
            fallback.font = .systemFont(ofSize: fontSize)
            fallback.textColor = textColor
            return
        }

        uiView.setValue(latex, forKey: "latex")
        uiView.setValue(fontSize, forKey: "fontSize")
        uiView.setValue(textColor, forKey: "textColor")
    }
}

import SwiftUI
import UIKit
import iosMath

struct LaTeXView: UIViewRepresentable {
    let latex: String
    var fontSize: CGFloat = 28
    var textColor: UIColor = .label

    func makeUIView(context: Context) -> MTMathUILabel {
        let label = MTMathUILabel()
        label.textAlignment = .center
        label.labelMode = .text
        return label
    }

    func updateUIView(_ uiView: MTMathUILabel, context: Context) {
        uiView.latex = latex
        uiView.fontSize = fontSize
        uiView.textColor = textColor
    }
}

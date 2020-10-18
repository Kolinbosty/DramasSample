//
//  StarView2.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/17.
//

import UIKit

/*
     Note: StarView 後發現，SF Symbols 其實是文字，用一個 Label 就不可以解決...
     就跟下面 enum 內的註解一樣...但是實驗後只有 macOS 可行，iOS 不行
     https://stackoverflow.com/questions/58341042/is-it-possible-to-use-sf-symbols-outside-of-uiimage
     所以只能用 image 放在，attributedString 內。

     這沒有特殊的客製化的情況下，這個做法比較簡單。
 */
class StarView2: UILabel {

    enum Style {
        case single     // 􀋃 4.5, 􀋂 0.0
        case full       // 􀋃􀋃􀋃􀋃􀋄 4.8, 􀋃􀋃􀋄􀋂􀋂 2.3, 􀋂􀋂􀋂􀋂􀋂 0.0
    }

    var rate: Double {
        didSet {
            updateText()
        }
    }

    let style: Style

    required init?(coder: NSCoder) {
        self.rate = 0.0
        self.style = .single
        super.init(coder: coder)

        // Update
        updateText()
        textColor = UIColor.cs.rating
    }

    init(_ rate: Double, style: Style = .single) {
        self.rate = rate
        self.style = style
        super.init(frame: .zero)

        // Update
        updateText()
        textColor = UIColor.cs.rating
    }

    private func updateText() {
        let fullText = NSMutableAttributedString()

        // Range 0...5
        let validValue = max(0.0, min(5.0, rate))

        // Stars
        switch style {
        case .single:
            let isEmpty = rate <= 0.0
            if isEmpty {
                fullText.append(img: UIImage.sf.star(size: font.pointSize))
            } else {
                fullText.append(img: UIImage.sf.starFill(size: font.pointSize))
            }

        case .full:
            let maxCount = 5
            let floorValue = Int(floor(validValue))
            let ceilValue = Int(ceil(validValue))

            for _ in 0..<floorValue { fullText.append(img: UIImage.sf.starFill(size: font.pointSize)) }
            if ceilValue != floorValue { fullText.append(img: UIImage.sf.starHalfFill(size: font.pointSize)) }
            for _ in 0..<(maxCount - ceilValue) { fullText.append(img: UIImage.sf.star(size: font.pointSize)) }
        }

        // Number
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        let numText = formatter.string(from: NSNumber(value: validValue)) ?? "0.0"

        // Update
        fullText.append(NSAttributedString(string: " \(numText)"))
        attributedText = fullText
    }

    // Note: 下述為純文字的方式，不過看起來這只能在 mac 不會亂碼，詳見置頂說明。
//    private func updateText() {
//        // Range 0...5
//        let validValue = max(0.0, min(5.0, rate))
//        
//        // Stars
//        let maxCount = 5
//        let floorValue = Int(floor(validValue))
//        let ceilValue = Int(ceil(validValue))
//        
//        let fillStars = String(repeating: "􀋃", count: floorValue)
//        let halfStars = String(repeating: "􀋄", count: ceilValue - floorValue)
//        let emptyStars = String(repeating: "􀋂", count: maxCount - ceilValue)
//        let starsText = fillStars + halfStars + emptyStars
//        
//        // Number
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.minimumFractionDigits = 1
//        formatter.maximumFractionDigits = 1
//        let numText = formatter.string(from: NSNumber(value: validValue)) ?? "0.0"
//        
//        self.text = "\(starsText) \(numText)"
//    }
}

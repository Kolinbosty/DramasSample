//
//  UIColor+ColorSet.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

struct ColorSetProxy {
    var background: UIColor? {
        return UIColor(named: "Background")
    }

    var title: UIColor? {
        return UIColor(named: "Title")
    }

    var subtitle: UIColor? {
        return UIColor(named: "Subtitle")
    }

    var rating: UIColor? {
        return UIColor(named: "Rating")
    }
}

extension UIColor {
    static var cs: ColorSetProxy { ColorSetProxy() }
}

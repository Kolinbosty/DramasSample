//
//  UIImage+SFSymbol.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/16.
//

import UIKit

// Template (Using Code Snippets or CodeGen)
//func <#MethodName#>(configuration: UIImage.Configuration? = nil) -> UIImage? {
//    return UIImage(systemName: "<#KeyName#>", withConfiguration: configuration)
//}
//
//func <#MethodName#>(size: CGFloat) -> UIImage? {
//    let config = UIImage.SymbolConfiguration(pointSize: size)
//    return UIImage(systemName: "<#KeyName#>", withConfiguration: config)
//}

struct SFSymbolProxy {

    // Star
    func star(configuration: UIImage.Configuration? = nil) -> UIImage? {
        return UIImage(systemName: "star", withConfiguration: configuration)
    }

    func star(size: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size)
        return UIImage(systemName: "star", withConfiguration: config)
    }

    // Star Fill
    func starFill(configuration: UIImage.Configuration? = nil) -> UIImage? {
        return UIImage(systemName: "star.fill", withConfiguration: configuration)
    }

    func starFill(size: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size)
        return UIImage(systemName: "star.fill", withConfiguration: config)
    }

    // Star Half Fill
    func starHalfFill(configuration: UIImage.Configuration? = nil) -> UIImage? {
        return UIImage(systemName: "star.leadinghalf.fill", withConfiguration: configuration)
    }

    func starHalfFill(size: CGFloat) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size)
        return UIImage(systemName: "star.leadinghalf.fill", withConfiguration: config)
    }
}

extension UIImage {
    static var sf: SFSymbolProxy {
        return SFSymbolProxy()
    }
}

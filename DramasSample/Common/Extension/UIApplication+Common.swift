//
//  UIApplication+Common.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/19.
//

import UIKit

extension UIApplication {
    var isLandscape: Bool {
        windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation.isLandscape ?? false
    }
}

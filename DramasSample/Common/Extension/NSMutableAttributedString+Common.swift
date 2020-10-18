//
//  NSMutableAttributedString+Common.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/19.
//

import UIKit

extension NSMutableAttributedString {
    func append(img: UIImage?) {
        guard let img = img else { return }
        let attachment = NSTextAttachment(image: img)
        self.append(NSAttributedString(attachment: attachment))
    }
}

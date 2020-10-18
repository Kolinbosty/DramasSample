//
//  DaramaInfoCellViewModel.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/19.
//

import UIKit

class DaramaInfoCellViewModel: BasicCollectionViewCellViewModel {
    override class func cellIdentifier() -> String { "dramaInfo" }
    override class func cellClass() -> AnyClass? { DramaInfoCell.self }
    override var mainData: AnyHashable { dramaData }

    let dramaData: LineTVAPI.Drama

    init(_ dramaData: LineTVAPI.Drama) {
        self.dramaData = dramaData
        super.init()
    }
}

extension DaramaInfoCellViewModel: DramaInfoCellViewModelProtocol {

    var imageURL: URL? {
        return dramaData.thumb
    }

    var title: String {
        return dramaData.name
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: dramaData.createdAt)
    }

    var totalViewsAttributedText: NSAttributedString {
        // Create Text
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let numStr = formatter.string(from: NSNumber(value: dramaData.totalViews)) ?? "0"

        // Insert Eye
        let attributedStr = NSMutableAttributedString()
        attributedStr.append(img: UIImage.sf.eyeFilled(size: 12.0))
        attributedStr.append(NSAttributedString(string: numStr))

        return attributedStr
    }

    var rating: Double {
        dramaData.rating
    }
}

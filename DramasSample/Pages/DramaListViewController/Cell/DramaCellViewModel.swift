//
//  DramaCellViewModel.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

class DramaCellViewModel: BasicCollectionViewCellViewModel {
    override class func cellIdentifier() -> String { "drama" }
    override class func cellClass() -> AnyClass? { DramaCell.self }
    override var mainData: AnyHashable { dramaData }

    let dramaData: LineTVAPI.Drama

    init(_ dramaData: LineTVAPI.Drama) {
        self.dramaData = dramaData
        super.init()
    }
}

extension DramaCellViewModel: DaramaCellViewModelProtocol {

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

    var rating: Double {
        dramaData.rating
    }
}

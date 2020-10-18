//
//  OfflineCellViewModel.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import Foundation

class OfflineCellViewModel: BasicCollectionViewCellViewModel {
    override class func cellIdentifier() -> String { "offline" }
    override class func cellClass() -> AnyClass? { OfflineCell.self }
    override var mainData: AnyHashable { "offline" }
}

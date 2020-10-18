//
//  BasicCollectionViewCell.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

class BasicCollectionViewCellViewModel: NSObject {
    class func cellIdentifier() -> String {
        assert(false, "Error: must override this method")
        return "basic"
    }

    class func cellClass() -> AnyClass? {
        assert(false, "Error: must override this method")
        return BasicCollectionViewCell.self
    }

    var mainData: AnyHashable {
        assert(false, "Error: must override this method")
        return super.hash
    }

    override var hash: Int {
        return mainData.hashValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let vm = object as? BasicCollectionViewCellViewModel {
            return mainData == vm.mainData
        }
        return super.isEqual(object)
    }
}

class BasicCollectionViewCell: UICollectionViewCell {
    func update(with viewModel: BasicCollectionViewCellViewModel) {
        assert(false, "Error: must override this method")
    }
}

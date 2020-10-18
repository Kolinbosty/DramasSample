//
//  OfflineCell.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

/*
    Note:
        後來發現 Offline 這樣用往下滑後不容易發現
        應該可以直接固定在 List 的上方就好，不用寫成 Cell
        不過可以用來展示兩種 Section 的情況，跟不同的 Cell，所以保持這樣。

 */
class OfflineCell: BasicCollectionViewCell {

    // UI Properties
    private weak var titleLabel: UILabel?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // Calculate Width
        let cellWidth: CGFloat = UIScreen.main.bounds.width
        let size = self.systemLayoutSizeFitting(CGSize(width: cellWidth, height: 50.0), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        attributes.frame.size = size

        return attributes
    }

    override func update(with viewModel: BasicCollectionViewCellViewModel) {
        // Do nothing (prevent assert)
    }
}

extension OfflineCell {
    private func initializeUI() {
        backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)

        // Create UI
        createTitleLabel()

        // Setup Constraint
        setupConstraints()
    }

    private func createTitleLabel() {
        // Remove old
        self.titleLabel?.removeFromSuperview()

        // Create & config
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.text = "離線模式"
        titleLabel.font = .systemFont(ofSize: 14.0)

        // Add
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
    }

    private func setupConstraints() {
        guard let titleLabel = titleLabel else {
            assert(false, "Error: must create UI first...")
            return
        }

        // Title
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

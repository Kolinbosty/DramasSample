//
//  DramaInfoCell.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit
import Kingfisher

// Note: 寫 Protocol，保留共用的彈性。
protocol DramaInfoCellViewModelProtocol: BasicCollectionViewCellViewModel {
    var imageURL: URL? { get }
    var title: String { get }
    var dateText: String { get }
    var totalViewsAttributedText: NSAttributedString { get }
    var rating: Double { get }
}

class DramaInfoCell: BasicCollectionViewCell {
    // UI Properties
    private weak var imageView: UIImageView?
    private weak var titleLabel: UILabel?
    private weak var dateLabel: UILabel?
    private weak var totalViewsLabel: UILabel?
    private weak var ratingView: StarView?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    override func update(with viewModel: BasicCollectionViewCellViewModel) {
        // Type checking
        guard let viewModel = viewModel as? DramaInfoCellViewModelProtocol else {
            assert(false, "Error: invalid view model?")
            return
        }

        imageView?.kf.setImage(with: viewModel.imageURL)
        titleLabel?.text = viewModel.title
        dateLabel?.text = viewModel.dateText
        totalViewsLabel?.attributedText = viewModel.totalViewsAttributedText
        ratingView?.rate = viewModel.rating
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // Calculate Width
        let cellWidth: CGFloat = UIScreen.main.bounds.width
        let size = self.systemLayoutSizeFitting(CGSize(width: cellWidth, height: 50.0), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        attributes.frame.size = size

        return attributes
    }
}

extension DramaInfoCell {
    private func initializeUI() {
        // Create UI
        createImageView()
        createTitleLabel()
        createDateLabel()
        createTotalViewsLabel()
        createRateView()

        // Setup Constraint
        setupConstraints()
    }

    private func createImageView() {
        // Remove old
        self.imageView?.removeFromSuperview()

        // Create & config
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        // Add
        contentView.addSubview(imageView)
        self.imageView = imageView
    }

    private func createTitleLabel() {
        // Remove old
        self.titleLabel?.removeFromSuperview()

        // Create & config
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.cs.title

        // Add
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
    }

    private func createDateLabel() {
        // Remove old
        self.dateLabel?.removeFromSuperview()

        // Create & config
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 1
        dateLabel.font = .systemFont(ofSize: 12.0)
        dateLabel.textColor = UIColor.cs.subtitle

        // Add
        contentView.addSubview(dateLabel)
        self.dateLabel = dateLabel
    }

    private func createTotalViewsLabel() {
        // Remove old
        self.totalViewsLabel?.removeFromSuperview()

        // Create & config
        let totalViewsLabel = UILabel()
        totalViewsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalViewsLabel.numberOfLines = 1
        totalViewsLabel.font = .systemFont(ofSize: 12.0)
        totalViewsLabel.textColor = UIColor.cs.subtitle

        // Add
        contentView.addSubview(totalViewsLabel)
        self.totalViewsLabel = totalViewsLabel
    }

    private func createRateView() {
        // Remove old
        self.ratingView?.removeFromSuperview()

        // Create & config
        let ratingView = StarView(0.0, style: .full, configuration: .standard)
        ratingView.translatesAutoresizingMaskIntoConstraints = false

        // Add
        contentView.addSubview(ratingView)
        self.ratingView = ratingView
    }

    private func setupConstraints() {
        guard let imageView = imageView,
              let titleLabel = titleLabel,
              let dateLabel = dateLabel,
              let totalViewsLabel = totalViewsLabel,
              let ratingView = ratingView else {
            assert(false, "Error: must create UI first")
            return
        }

        // Constant
        let imageHScale: CGFloat = 1.4 // (1000x1404)
        let hMargin: CGFloat = 12.0
        let hSpace: CGFloat = 4.0
        let vSpace: CGFloat = 8.0

        // Image
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageHScale, constant: 0)
        ])

        // Title
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: vSpace),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                             constant: hMargin),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor,
                                              constant: -hMargin),
        ])

        // Date - Total Views
        totalViewsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: vSpace),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                            constant: hMargin),
            totalViewsLabel.leftAnchor.constraint(greaterThanOrEqualTo: dateLabel.rightAnchor,
                                                  constant: hSpace),
            totalViewsLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            totalViewsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                                   constant: -hMargin)
        ])

        // Rate
        let ratingBottomConstraint = ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ratingBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: vSpace),
            ratingView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: hMargin),
            ratingBottomConstraint
        ])
    }
}

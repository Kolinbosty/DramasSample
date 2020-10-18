//
//  DramaCell.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit
import Kingfisher

// Note: 寫 Protocol，保留共用的彈性。
protocol DaramaCellViewModelProtocol: BasicCollectionViewCellViewModel {
    var imageURL: URL? { get }
    var title: String { get }
    var dateText: String { get }
    var rating: Double { get }
}

class DramaCell: BasicCollectionViewCell {

    // UI Properties
    private weak var imageView: UIImageView?
    private weak var titleLabel: UILabel?
    private weak var dateLabel: UILabel?
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
        guard let viewModel = viewModel as? DaramaCellViewModelProtocol else {
            assert(false, "Error: invalid view model?")
            return
        }

        imageView?.kf.setImage(with: viewModel.imageURL)
        titleLabel?.text = viewModel.title
        dateLabel?.text = viewModel.dateText
        ratingView?.rate = viewModel.rating
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // Calculate Width
        let isLandscape = UIApplication.shared.isLandscape
        let cellCountInLine: CGFloat = isLandscape ? 4.0 : 2.0
        let separatorCount: CGFloat = cellCountInLine - 1.0
        let spacing: CGFloat = 10.0
        let hMargin: CGFloat = 10.0
        let availableWidth: CGFloat = UIScreen.main.bounds.width - (hMargin * 2.0) - (spacing * separatorCount)
        let cellWidth: CGFloat = floor(availableWidth / cellCountInLine)

        let size = self.systemLayoutSizeFitting(CGSize(width: cellWidth, height: 50.0), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        attributes.frame.size = size

        return attributes
    }
}

// MARK - UI
extension DramaCell {
    private func initializeUI() {
        // Create UI
        createImageView()
        createTitleLabel()
        createDateLabel()
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
        imageView.layer.cornerRadius = 5.0

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
        titleLabel.numberOfLines = 1
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

    private func createRateView() {
        // Remove old
        self.ratingView?.removeFromSuperview()

        // Create & config
        let ratingView = StarView(0.0, style: .single, configuration: .standard)
        ratingView.translatesAutoresizingMaskIntoConstraints = false

        // Add
        contentView.addSubview(ratingView)
        self.ratingView = ratingView
    }

    private func setupConstraints() {
        guard let imageView = imageView,
              let titleLabel = titleLabel,
              let dateLabel = dateLabel,
              let ratingView = ratingView else {
            assert(false, "Error: must create UI first")
            return
        }

        // Constant
        let imageHScale: CGFloat = 1.4 // (1000x1404)
        let vSpace: CGFloat = 2.0

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
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
        ])

        // Date
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: vSpace),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dateLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor)
        ])

        // Rate
        let ratingBottomConstraint = ratingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ratingBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: vSpace),
            ratingView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            ratingBottomConstraint
        ])
    }
}

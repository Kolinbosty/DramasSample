//
//  StarView.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/16.
//

import UIKit

class StarView: UIView {

    var rate: Double {
        didSet {
            // Deubg Warning
            let range = 0.0...5.0
            assert(range.contains(rate), "Error: var 'rate' out of range!")

            // Update
            updateRate()
        }
    }

    let style: Style

    var configuration: Configuration {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    // UI Propertis
    private var stackView: UIStackView?
    private var stars: [UIImageView] = []
    private var rateLabel: UILabel?

    private var heightConstraint: NSLayoutConstraint?
    private var labelSpaceConstraint: NSLayoutConstraint?

    required init?(coder: NSCoder) {
        // Default value
        self.rate = 0.0
        self.style = .single
        self.configuration = .standard
        super.init(coder: coder)

        initializeUI()
    }

    init(_ rate: Double, style: Style = .single, configuration: Configuration = .standard) {
        self.rate = rate
        self.style = style
        self.configuration = configuration
        super.init(frame: .zero)

        initializeUI()
    }

    override func updateConstraints() {
        // Self
        heightConstraint?.constant = configuration.preferHeight

        // Stack
        stackView?.spacing = configuration.starSpacing
        updateStars()

        // Label
        rateLabel?.font = .boldSystemFont(ofSize: configuration.labelFontSize)
        labelSpaceConstraint?.constant = configuration.labelSpacing

        super.updateConstraints()
    }

    private func updateRate() {
        // Label
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        rateLabel?.text = formatter.string(from: NSNumber(value: rate))

        // Star
        updateStars()
    }

    /// Only update star imageView, will not update label.
    private func updateStars() {
        switch style {
        case .single:
            let isEmpty = rate <= 0.0
            stars.first?.image = isEmpty ? emptyStar : filledStar

        case .full:
            for (idx, imageView) in stars.enumerated() {
                if rate >= Double(idx + 1) {
                    imageView.image = filledStar
                } else if rate > Double(idx) {
                    imageView.image = halfStar
                } else {
                    imageView.image = emptyStar
                }
            }
        }
    }
}

// MARK: - Configuaration
extension StarView {

    enum Style {
        case single     // 􀋃 4.5, 􀋂 0.0
        case full       // 􀋃􀋃􀋃􀋃􀋄 4.8, 􀋃􀋃􀋄􀋂􀋂 2.3, 􀋂􀋂􀋂􀋂􀋂 0.0
    }

    // Note: 因為需求沒指定，用這種方式保留彈性修改。
    struct Configuration {
        // Default
        static var standard: Configuration { Configuration() }

        var preferHeight: CGFloat = 24.0
        var starPointSize: CGFloat = 18.0
        var starSpacing: CGFloat = 4.0
        var labelFontSize: CGFloat = 18.0
        var labelSpacing: CGFloat = 4.0
    }

    private var emptyStar: UIImage? {
        UIImage.sf.star(size: configuration.starPointSize)
    }

    private var filledStar: UIImage? {
        UIImage.sf.starFill(size: configuration.starPointSize)
    }

    private var halfStar: UIImage? {
        UIImage.sf.starHalfFill(size: configuration.starPointSize)
    }
}

// MARK: - UI
extension StarView {
    private func initializeUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: configuration.preferHeight)
        heightConstraint.isActive = true
        self.heightConstraint = heightConstraint

        // Create UI
        createStackView()
        createRateLabel()
        resetStarViews()

        // Setup Constraint
        setupConstraints()

        // Update
        updateRate()
    }

    private func createStackView() {
        // Remove old
        self.stackView?.removeFromSuperview()

        // Create & config
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = configuration.starSpacing

        // Add
        self.addSubview(stackView)
        self.stackView = stackView
    }

    private func createRateLabel() {
        // Remove old
        self.rateLabel?.removeFromSuperview()

        // Create & config
        let rateLabel = UILabel()
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.font = .boldSystemFont(ofSize: configuration.labelFontSize)
        rateLabel.textColor = .systemGreen

        // Add
        self.addSubview(rateLabel)
        self.rateLabel = rateLabel
    }

    private func setupConstraints() {
        guard let stackView = stackView,
              let rateLabel = rateLabel else {
            assert(false, "Error: must create UI first!")
            return
        }

        // Stack View
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Rate Label
        let labelSpaceConstraint = rateLabel.leftAnchor.constraint(equalTo: stackView.rightAnchor,
                                                                   constant: configuration.labelSpacing)
        labelSpaceConstraint.priority = .required - 1
        self.labelSpaceConstraint = labelSpaceConstraint

        rateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            labelSpaceConstraint,
            rateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func resetStarViews() {
        // Remove all
        stars.forEach { $0.removeFromSuperview() }

        // Add
        let count = (style == .single) ? 1 : 5
        (0..<count).forEach { _ in addStarView() }

        // Update
        updateStars()
    }

    private func addStarView() {
        guard let stackView = stackView else {
            assert(false, "Error: must create stack view first!")
            return
        }

        // Create
        let starImgView = UIImageView()
        starImgView.contentMode = .center
        starImgView.tintColor = .systemGreen
        starImgView.image = emptyStar

        // Add
        stackView.addArrangedSubview(starImgView)
        stars.append(starImgView)
    }
}

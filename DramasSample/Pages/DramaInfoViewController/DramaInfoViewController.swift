//
//  DramaInfoViewController.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/16.
//

import UIKit

class DramaInfoViewController: UIViewController {

    // UI Properties
    private weak var collectionView: UICollectionView?

    private let dramaData: LineTVAPI.Drama
    private lazy var viewModel: DramaInfoViewModel = {
        return DramaInfoViewModel(dramaData, collectionView: collectionView)
    }()

    required init?(coder: NSCoder) {
        fatalError("Do not support interface builder, using code to init...")
    }

    init(_ drama: LineTVAPI.Drama) {
        self.dramaData = drama
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "影集詳細"

        // Setup UI
        initializeUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload UI
        viewModel.reloadValues()
    }
}

// MARK: - UI
extension DramaInfoViewController {

    private func initializeUI() {
        // Create UI
        createCollectionView()
    }

    private func createCollectionView() {
        // Remove old
        self.collectionView?.removeFromSuperview()

        // Create & config
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.cs.background

        // Add
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
}

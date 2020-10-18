//
//  DramaListViewController.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/16.
//

import UIKit
import JGProgressHUD

class DramaListViewController: UIViewController {

    private lazy var searchController: UISearchController = {
        return UISearchController(searchResultsController: nil)
    }()

    // UI Properties
    private weak var collectionView: UICollectionView?
    private weak var emptyResultView: UIView?
    private var refreshControl: UIRefreshControl = UIRefreshControl()

    private lazy var viewModel: DramaListViewModel = {
        return DramaListViewModel(collectionView: collectionView,
                                  emptyResultView: emptyResultView,
                                  viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "影集列表"

        // Setup UI
        initializeUI()
        setupSearchController()
        setupRefreshControl()

        // Fetch Data
        reloadData()
    }

    @objc private func reloadData(isPullToRefresh: Bool = false) {
        // Only show HUD in normal reload
        var hud: JGProgressHUD? = nil
        if !isPullToRefresh {
            let isDrakMode = traitCollection.userInterfaceStyle == .dark
            hud = JGProgressHUD(style: isDrakMode ? .extraLight : .dark)
            hud?.show(in: view)
        }

        viewModel.fetchDataAndReload { [weak self] (isSuccess) in
            guard let self = self else { return }
            hud?.dismiss()

            // Error handling
            if (!isSuccess) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                self.showNetworkErrorAlert {
                    self.refreshControl.endRefreshing()
                }
            } else {
                self.refreshControl.endRefreshing()
            }
        }
    }

    @objc private func pullToRefreshReload() {
        reloadData(isPullToRefresh: true)
    }

    private func setupRefreshControl() {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.cs.subtitle ?? .black]
        refreshControl.attributedTitle = NSAttributedString(string: "下拉更新", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(pullToRefreshReload), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }

    private func showNetworkErrorAlert(completion: (() -> Void)? = nil) {
        // Actions
        let cancelAction = UIAlertAction(title: "確認", style: .cancel) { _ in
            if let completion = completion { completion() }
        }

        // Alert
        let alertController = UIAlertController(title: "網路有問題？", message: "無法取得資料", preferredStyle: .alert)
        alertController.addAction(cancelAction)

        // Present
        present(alertController, animated: true)
    }
}

// MARK: - SearchController
extension DramaListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(title: searchController.searchBar.text)

        // Update local storage
        OfflineModeStorage.standard.saveSearchKeyword(searchController.searchBar.text)
    }

    private func setupSearchController() {
        searchController.searchBar.placeholder = "影集名稱"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self

        // Load default search text
        viewModel.skipReload {
            let previousSearchText = OfflineModeStorage.standard.loadSearchKeyword()
            searchController.searchBar.text = previousSearchText
        }

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UI
extension DramaListViewController {

    private func initializeUI() {
        // Create UI
        createCollectionView()
        createEmptyResultView()
    }

    private func createCollectionView() {
        // Remove old
        self.collectionView?.removeFromSuperview()

        // Create & config
        let layout = LeftAlignedCollectionViewFlowLayout()
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

    private func createEmptyResultView() {
        // Remove old
        self.emptyResultView?.removeFromSuperview()

        // Note: 這邊很小，就偷懶不另寫 CustomView 了
        // Create & config
        let label = UILabel(frame: view.bounds)
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.text = "找不到對應的影片..."
        label.font = .boldSystemFont(ofSize: 24.0)
        label.textColor = UIColor.cs.subtitle
        label.textAlignment = .center

        // Add
        view.addSubview(label)
        self.emptyResultView = label
        label.isHidden = true
    }
}

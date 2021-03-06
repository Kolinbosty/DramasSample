//
//  DramaListViewModel.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

class DramaListViewModel: NSObject {
    enum Section {
        case offline
        case drama
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, BasicCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BasicCollectionViewCellViewModel>

    private var dataSource: DataSource?
    private var dramas: [LineTVAPI.Drama] = []

    private weak var collectionView: UICollectionView?
    private weak var emptyResultView: UIView?
    private weak var viewController: UIViewController?

    private var currentSearchText: String?
    private var isNetworkConnected: Bool = true
    private var willSkipReload: Bool = false

    init(collectionView: UICollectionView?,
         emptyResultView: UIView?,
         viewController: UIViewController) {
        self.collectionView = collectionView
        self.emptyResultView = emptyResultView
        self.viewController = viewController
        super.init()

        setupCollectionView()
        startObserveNetwork()
    }

    private func startObserveNetwork() {
        // Only trigger while condition changed
        NetworkMonitor.shared.addObserver { [weak self] (isConnected) -> Bool in
            // Update
            self?.isNetworkConnected = isConnected
            self?.reloadValues(checkEmpty: false)

            // Remove if needed
            return self != nil
        }

        // Current state
        self.isNetworkConnected = NetworkMonitor.shared.isConnected
    }
}

// MARK: - CollectionView
extension DramaListViewModel: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private func setupCollectionView() {
        guard let collectionView = collectionView else {
            assert(false, "Error: must create collection view first...")
            return
        }

        // Note: 如果新增的 VM 只要加在這邊，下面的 Register 的 loop 會自己跑完。
        let knownVMs: [BasicCollectionViewCellViewModel.Type] = [
            OfflineCellViewModel.self,
            DramaCellViewModel.self
        ]

        // Register
        knownVMs.forEach { (vmType) in
            collectionView.register(vmType.cellClass(),
                                    forCellWithReuseIdentifier: vmType.cellIdentifier())
        }

        // Create DataSource
        let dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, vm) -> UICollectionViewCell? in
            // Dequeue & Update
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: vm).cellIdentifier(),
                                                          for: indexPath) as? BasicCollectionViewCell
            cell?.update(with: vm)

            return cell
        }
        self.dataSource = dataSource

        // Delegate
        collectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let dataSource = dataSource else { return .zero }
        let sectionType = dataSource.sectionIdentifier(at: section)

        switch sectionType {
        case .drama:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        case .offline:
            return UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let dataSource = dataSource else { return false }

        // Only drama can select
        let isDrama = dataSource.sectionIdentifier(at: indexPath.section) == .drama
        return isDrama
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource,
              let dramaVM = dataSource.itemIdentifier(for: indexPath) as? DramaCellViewModel else {
            return
        }

        // Go to info page
        let vc = DramaInfoViewController(dramaVM.dramaData)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UICollectionViewDiffableDataSource {
    func sectionIdentifier(at section: Int) -> SectionIdentifierType {
        return snapshot().sectionIdentifiers[section]
    }
}

// MARK: - Operation
extension DramaListViewModel {
    // Any reload trigger from block will be ignore
    func skipReload(while block: () -> Void) {
        willSkipReload = true
        block()
        willSkipReload = false
    }

    func fetchDataAndReload(completion: @escaping (Bool) -> Void) {
        LineTVAPI.client.fetchDramas { [self] (result) in
            switch result {
            case .success(let response):
                dramas = response.data
                reloadValues()
                completion(true)

            case .failure(_):
                reloadValues()
                completion(false)
            }
        }
    }

    func search(title: String? = nil) {
        // Update
        currentSearchText = title
        reloadValues()
    }

    /// Construct & Apply Snapshot
    /// - Parameter checkEmpty: Will check empty result or not.
    func reloadValues(checkEmpty: Bool = true) {
        // Ignore
        guard !willSkipReload else { return }

        // Create Snapshot
        var snapshot = Snapshot()

        // Network connection
        if !isNetworkConnected {
            snapshot.appendSections([.offline])
            snapshot.appendItems([OfflineCellViewModel()])
        }

        // Search matched drama
        var searchResult = dramas
        if let searchText = currentSearchText, !searchText.isEmpty {
            searchResult = dramas.filter { drama in
                return drama.name.range(of: searchText, options: .caseInsensitive) != nil
            }
        }

        let vms = searchResult.map { DramaCellViewModel($0) }
        snapshot.appendSections([.drama])
        snapshot.appendItems(vms)

        // Apply
        dataSource?.apply(snapshot)

        // Others
        if checkEmpty {
            // Update empty view state
            emptyResultView?.isHidden = !searchResult.isEmpty
        }
    }
}

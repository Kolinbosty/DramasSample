//
//  NetworkMonitor.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/17.
//

import Foundation
import Network

class NetworkMonitor {
    // Note: 如果 return false，就會在下一次執行時從 observers 內移除，最簡單的用法就是 `weakSelf != nil`，這樣就不用主動移除。
    /// (isConnected) -> ContinueObserve
    typealias Observer = (Bool) -> Bool

    // Singleton
    static let shared: NetworkMonitor = NetworkMonitor()

    // IMPORTANT: Once you cancel a path monitor, that specific object is done. You can’t start it again. You will need to create a new path monitor in.
    private var monitor: NWPathMonitor?

    private var observers: [Observer] = []

    private let queue: DispatchQueue = .main

    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }

    func start() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let isConnected = path.status == .satisfied
            self.observers = self.observers.filter { $0(isConnected) }
        }
        monitor.start(queue: queue)
        self.monitor = monitor
    }

    func stop() {
        monitor?.cancel()
    }

    func addObserver(_ observer: @escaping Observer) {
        if Thread.isMainThread {
            self.observers.append(observer)
        } else {
            DispatchQueue.main.async {
                self.observers.append(observer)
            }
        }
    }
}

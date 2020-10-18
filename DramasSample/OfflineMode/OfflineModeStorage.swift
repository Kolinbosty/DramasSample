//
//  OfflineModeStorage.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/19.
//

import Foundation

/*
    Note:
        這邊目前只實作用 UserDefault 的方式
        不過只要 implement OfflineModeStorageProtocol
        然後把 OfflineModeStorage.standard 換掉，就可以用不同的方式存取
        其他地方不用改 Code
 */
protocol OfflineModeStorageProtocol {
    func saveAPIData(urlStr: String, data: Data?)
    func loadAPIData(urlStr: String) -> Data?

    func saveSearchKeyword(_ keyword: String?)
    func loadSearchKeyword() -> String?
}

struct OfflineModeStorage {
    static var standard: OfflineModeStorageProtocol = OfflineModeStorage_UserDefault()
}

struct OfflineModeStorage_UserDefault: OfflineModeStorageProtocol {
    private let previousSearchKey = "previousSearchValue"

    func saveAPIData(urlStr: String, data: Data?) {
        UserDefaults.standard.setValue(data, forKey: urlStr)
    }

    func loadAPIData(urlStr: String) -> Data? {
        return UserDefaults.standard.value(forKey: urlStr) as? Data
    }

    func saveSearchKeyword(_ keyword: String?) {
        UserDefaults.standard.setValue(keyword, forKey: previousSearchKey)
    }

    func loadSearchKeyword() -> String? {
        return UserDefaults.standard.value(forKey: previousSearchKey) as? String
    }
}

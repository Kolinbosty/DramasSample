//
//  INTERVIEW.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/11/2.
//

import UIKit

// MARK: DataObj
struct DramaObj {}

// MARK: - Core
struct OAuthToken {
    let accessToken: String
    let refreshToken: String
}

struct OAuthAPI {
    private static var clientID: String = "clientID"
    static var token: OAuthToken? // 會存在 keychain，並且一開始嘗試從 keychain 去取得。
    static var isLogin: Bool { return token != nil }

    func login(completion: (Bool) -> Void) {
        // 示意
        // Get auth code
        // Exchange auth code for token
    }
    func refreshToken(completion: (Bool) -> Void) {}

    // 不需要登入
    func fetchList(completion: ([DramaObj]) -> Void) {}

    // 需要登入 (會帶上 access token)
    func needLoginAPICall(path: String, completion: (Data?) -> Void, retry: Bool = false) {
        // Add access token to header
        guard let _ = OAuthAPI.token?.accessToken else {
            completion(nil)
            return
        }

        // 以下示意
        // Call API if cache exist & not expired
        // Optional 如果系統的 cache 機制夠用其實不需要
//        if let cache = CacheManager.shared.cache(with: path) {
//            // Using cache
//            completion(cache)
//        } else {
//            CALL_API { (success, data) in
//                if let data = data {
//                    // Success
//                    CacheManager.shared.genMemCache(key: path, data: data)
//                    CacheManager.shared.genDiskCache(key: path, data: data)
//                    completion(true, data)
//                } else if token 過期  {
//                    // Refresh token & retry
//                } else {
//                    // Fail
//                }
//            }
//        }
    }
    func fetchFav(completion: ([DramaObj]) -> Void) {}
    func saveFav(_ drama: DramaObj) {}
    func removeFav(_ drama: DramaObj) {}

    func fetchHistory(completion: ([DramaObj]) -> Void) {}
    func saveHistory(_ drama: DramaObj) {}
    func removeHistory(_ drama: DramaObj) {}
}

// Optional 如果系統的 cache 機制夠用其實不需要
struct CacheManager {
    static var shared: CacheManager = CacheManager()
    func memCache(with key: String) -> Data? { return nil }
    func diskCache(with key: String) -> Data? { return nil}
    func genMemCache(key: String, data: Data) {}
    func genDiskCache(key: String, data: Data) {}

    func cache(with key: String) -> Data? {
        if let memCache = memCache(with: key) {
            return memCache
        } else if let diskCache = diskCache(with: key) {
            genMemCache(key: key, data: diskCache)
            return diskCache
        }
        return nil
    }
}

// MARK: - Page
class ListVC: UIViewController {
    // 不需要登入
    // Fetch fav and refresh UI
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         每次都重新打 API (因為不知道 server 何時更新)
         1. request 數量的問題用 cache 解決
         2. 畫面刷新的問題用 DiffableDataSource 解決閃爍
         */
    }
}

class DramaVC: UIViewController {
    // 可以不登入，如果有登入，觀看後會 call saveHistory(_ drama: DramaObj)
}

class MemberVC: UIViewController {
    // 可以不登入，如果有登入，會 fetch fav?
    // NEXT PAGE
    func pushFavPage() {
        if OAuthAPI.isLogin {
            // 推 FavVC
        } else {
            // 推 LoginVC
        }
    }

    func pushHistory() {
        if OAuthAPI.isLogin {
            // 推 HistoryVC
        } else {
            // 推 LoginVC
        }
    }
}

class LoginVC: UIViewController {
    // Handle login
}

class FavVC: UIViewController {
    // Fetch fav and refresh UI
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         每次都重新打 API (因為不知道 server 何時更新)
         1. request 數量的問題用 cache 解決
         2. 畫面刷新的問題用 DiffableDataSource 解決閃爍
         */
    }
}

class HistoryVC: UIViewController {
    // Fetch history and refresh UI
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
         每次都重新打 API (因為不知道 server 何時更新)
         1. request 數量的問題用 cache 解決
         2. 畫面刷新的問題用 DiffableDataSource 解決閃爍
         */
    }
}

//
//  LineTVAPI+Dramas.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/17.
//

import Foundation

// Note: 通常 API 的量會很大，所以這邊用另外寫檔案用 Extension 的方式做整理，以及擴充方便。
extension LineTVAPI {
    func fetchDramas(completion: @escaping (Result<DramasResponse, GenernalNetworkError>) -> Void) {
        get(path: "interview/dramas-sample.json", completion: completion)
    }
}

// MARK: - DATA
extension LineTVAPI {
    struct DramasResponse: Codable {
        let data: [Drama]
    }

    struct Drama: Codable {
        let dramaId: Int
        let name: String
        let totalViews: Int
        let createdAt: Date
        let thumb: URL
        let rating: Double
    }
}

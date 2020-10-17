//
//  LineTVAPI.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/17.
//

import Foundation

class LineTVAPI: NetworkClient {
    var baseURLStr: String = "https://static.linetv.tw/"

    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()

        // Key
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        return decoder
    }

    // Singleton
    static let client = LineTVAPI()
}

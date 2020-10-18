//
//  NetworkClient.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/17.
//

import Foundation

enum GenernalNetworkError: Error {
    case invalidURL
    case connectionError
    case invalidResponse
    case invalidData
    case failToDecode
}

// Note: 這邊留了個彈性，不同的 Client 可以有不同的 decode 方式。
protocol NetworkClient {
    var baseURLStr: String { get }
    var jsonDecoder: JSONDecoder { get }

    func get<T: Decodable>(path: String, completion: @escaping (Result<T, GenernalNetworkError>) -> Void)
}

// MARK: - Default Implement
extension NetworkClient {
    func get<T: Decodable>(path: String, completion: @escaping (Result<T, GenernalNetworkError>) -> Void) {
        // Create URL
        guard var url = URL(string: baseURLStr) else {
            completion(.failure(.invalidURL))
            return
        }
        url.appendPathComponent(path)

        // Note: 這邊其實可以把 Session & Request 把客製彈性開出去，有需要的時候再把 Protocol 補上即可。
        // Note: 這邊也故意把 Cache 拿掉，相對容易複製出錯誤情境。
        // Send Request
        let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: .main)
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (data, respones, error) in
            // Error checking
            guard error == nil else {
                completion(.failure(.connectionError))
                return
            }

            guard let httpResponse = respones as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            // Decode
            guard let result = try? jsonDecoder.decode(T.self, from: data) else {
                completion(.failure(.failToDecode))
                return
            }

            // Success
            completion(.success(result))
        }.resume()
    }
}

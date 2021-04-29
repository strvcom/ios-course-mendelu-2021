//
//  NetworkClient.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Foundation
import Combine
import os.log

struct NetworkResponse<T> {
    let value: T
    let response: URLResponse
}

protocol Networking {
    func perform<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<NetworkResponse<T>, Error>
}

struct NetworkClient: Networking {
    private let session: URLSession = .shared

    func perform<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<NetworkResponse<T>, Error> {
        os_log("🚀🚀 Performing request: %{private}@", log: OSLog.default, type: .info, request.url?.absoluteString ?? "")
        return session.dataTaskPublisher(for: request)
            .retry(2)
            .tryMap { result -> NetworkResponse<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return NetworkResponse(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { value in
                os_log("✅✅ Request %{private}@ was successful", log: OSLog.default, type: .info, request.url?.absoluteString ?? "")
            }, receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    os_log("❌❌ %{private}@", log: OSLog.default, type: .error, error.localizedDescription)
                case .finished:
                    break
                }
            })
            .eraseToAnyPublisher()
    }
}


//
//  NetworkClient.swift
//  CryptoMarketCap
//
//  Created by Marek Slávik on 12.04.2021.
//

import Foundation
import Combine
import os.log

struct NetworkClient {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    private let session: URLSession = .shared

    func perform<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        os_log("🚀🚀 Performing request: %{private}@", log: OSLog.default, type: .info, request.url?.absoluteString ?? "")
        return session.dataTaskPublisher(for: request)
            .retry(2)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
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


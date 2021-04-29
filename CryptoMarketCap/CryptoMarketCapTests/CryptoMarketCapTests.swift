//
//  CryptoMarketCapTests.swift
//  CryptoMarketCapTests
//
//  Created by Marek Slávik on 12.04.2021.
//

import Combine
import XCTest
@testable import CryptoMarketCap

class CryptoMarketCapTests: XCTestCase {

    var sut: MarketsServicing?
    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mockNetwork = NetworkMock()
        let coingeckoAPI = CoingeckoAPI(client: mockNetwork)

        sut = MarketsService(coingeckoAPI: coingeckoAPI)
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testMarkets() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expectation = XCTestExpectation(description: "Markets should be fetched.")

        sut?.markets()
            .sink(receiveCompletion: { completion in
                guard case .failure = completion else { return }

                XCTFail("Market fetching shouldn't fail.")
            }, receiveValue: { markets in
                XCTAssertEqual(markets, NetworkMock.mockMarkets)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

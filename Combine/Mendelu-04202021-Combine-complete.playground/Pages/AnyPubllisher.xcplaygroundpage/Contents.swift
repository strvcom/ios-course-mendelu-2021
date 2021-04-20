import Foundation
import Combine

// MARK: TASK 6
// Create two different publishers and erase them to anyPublisher

// MARK: AnyPublisher

var cancellables = Set<AnyCancellable>()

// Publisher which receives 1 value and complete
var oneValuePublisher: AnyPublisher<Int, Never>

if Bool.random() {
    oneValuePublisher = Just(1).print().eraseToAnyPublisher()
} else {
    oneValuePublisher = Publishers.First(upstream: [1, 2, 3].publisher).print().eraseToAnyPublisher()
}

oneValuePublisher
    .sink { value in
        assert(value == 1)
        print("I got value \(value)")
    }
    .store(in: &cancellables)

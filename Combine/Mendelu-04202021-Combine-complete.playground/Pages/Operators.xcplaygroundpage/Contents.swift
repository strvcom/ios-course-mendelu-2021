import UIKit
import Combine

// MARK: TASK 7
// Operators

var cancellables = Set<AnyCancellable>()
let firstNumberPublisher = RandomNumbersPublisherProvider().numbersPublisher()
let secondNumberPublisher = RandomNumbersPublisherProvider().numbersPublisher()

// Use values from both publishers
// For values > 3 generate random string
// Get count of letter 'a' in string
// Print it out without duplicates
// For errors return 0

let complexPublisher = firstNumberPublisher
    .print()
    .merge(with: secondNumberPublisher)
    .filter { $0 > 3 }
    .map { Int.random(in: 1...$0) }
    .map { String.randomString(of: $0) }
    .flatMap {
        asyncTaskIntPublisher($0, letter: "a")
    }
    .removeDuplicates()
    .catch { error -> AnyPublisher<Int, Never> in
        print(error)
        return Just(0).eraseToAnyPublisher()
    }

let complexSubscription = complexPublisher
    .sink { completion in
        print("💗 Completion \(completion) received from publisher subscription!")
    } receiveValue: { value in
        print("🌟 Value \(value) received from publisher subscription!")
    }


DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    print("🔇 Cancel notification subscription")
    complexSubscription.cancel()
}

import Foundation
import Combine

// MARK: TASK 5
// Cancel subscription, error completion

let randomNumberPublisherProvider = RandomNumbersPublisherProvider()

let numberSubscription = randomNumberPublisherProvider.numbersPublisher()
    .sink(receiveCompletion: { completion in
        print("🌟 Completion \(completion) received from publisher subscription!")
    }, receiveValue: { number in
        print("🧡 Number \(number) received from publisher subscription!")
    })

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    print("🔇 Cancel number subscription")
    numberSubscription.cancel()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    print("🔇 Complete number subscription with error")
    randomNumberPublisherProvider.throwError()
}

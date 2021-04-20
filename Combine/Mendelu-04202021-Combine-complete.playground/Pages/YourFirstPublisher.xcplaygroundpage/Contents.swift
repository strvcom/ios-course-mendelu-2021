import Combine
import Foundation

// MARK: TASK 4
// Create publishers and subscribe them

// MARK: Collection publisher with completion

var cancellables = Set<AnyCancellable>()

let intArrayPublisher = [1, 2, 3, 4, 5].publisher
intArrayPublisher
    .sink { completion in
        print("🌟 Array publisher cancellable completion \(completion)")
    } receiveValue: { value in
        print("💗 Array publisher received \(value) from stored cancellable!")
    }
    .store(in: &cancellables)

// MARK: Assign to property

// Class needed
class User {
  var email = "default"
}

// One value publisher, failure: Never
let emailPublisher = Just("test@email.com")

let firstUser = User()
let secondUser = User()
print("FirstUser with email \"\(firstUser.email)\"")
print("SecondUser with email \"\(secondUser.email)\"")

// Assign
emailPublisher.assign(to: \.email, on: secondUser)
    .store(in: &cancellables)

print("After subscribe secondUser email \"\(secondUser.email)\"")

// Subscribers.Assign
let lastPostLabelSubscriber = Subscribers.Assign(object: firstUser, keyPath: \.email)
lastPostLabelSubscriber.store(in: &cancellables)
emailPublisher.subscribe(lastPostLabelSubscriber)
print("After subscribe firstUser email \"\(firstUser.email)\"")

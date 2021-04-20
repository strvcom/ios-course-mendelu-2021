import Combine
import Foundation

let iosCourseNotification = Notification.Name("CourseNotification")
let notificationCenter = NotificationCenter.default

for index in 1...5 {
    let randomSecondDelay = Int.random(in: index...index*2)
    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(randomSecondDelay)) {
        print("✅ Notification \(index) posted")
        notificationCenter.post(name: iosCourseNotification, object: nil)
    }
}

// MARK: Standard solution

notificationCenter.addObserver(forName: iosCourseNotification, object: nil, queue: nil) { notification in
    print("👍 Notification \(notification) received from observer callback!")
}

// MARK: BONUS TASK
// Create notification center subscribtions
// MARK: Publisher solution with subscription

let notificationPublisher = notificationCenter
    .publisher(for: iosCourseNotification, object: nil)

let notificationSubscription = notificationPublisher
    .sink { notification in
        print("🧡 Notification \(notification) received from publisher subscription!")
    }

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    print("🔇 Cancel notification subscription")
    notificationSubscription.cancel()
}

// MARK: Publisher solution with storing cancellable

var cancellables = Set<AnyCancellable>()

notificationPublisher
    .sink { completion in
        print("🌟 Notification cancellable completion \(completion)")
    } receiveValue: { notification in
        print("💗 Notification \(notification) received from stored cancellable!")
    }
    .store(in: &cancellables)

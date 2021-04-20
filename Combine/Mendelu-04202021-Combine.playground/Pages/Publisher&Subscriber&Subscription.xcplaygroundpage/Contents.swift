import Combine

// MARK: BONUS TASK - read both protocols and try implement own publisher/subscriber
// MARK: Publisher protocol

public protocol Publisher {
    // Value type
    associatedtype Output

    // Failure type (Never)
    associatedtype Failure : Error

    // Implementation of subscribe call this method to attach subscriber
    func receive<S>(subscriber: S)
    where S: Subscriber,
          Self.Failure == S.Failure,
          Self.Output == S.Input

    // Subscriber calls this method to attach to a publisher
    func subscribe<S>(_ subscriber: S)
    where S : Subscriber,
          Self.Failure == S.Failure,
          Self.Output == S.Input
}

// MARK: Subscriber protocol

public protocol Subscriber: CustomCombineIdentifierConvertible {
  // Value type
  associatedtype Input

  // Failure type
  associatedtype Failure: Error

  // Receive subscription from publisher
  func receive(subscription: Subscription)

  // Receive value from publisher
  func receive(_ input: Self.Input) -> Subscribers.Demand

  // Receive from publisher information that publisher finishes sending values
  func receive(completion: Subscribers.Completion<Self.Failure>)
}

// MARK: Subscription

public protocol Subscription: Cancellable, CustomCombineIdentifierConvertible {
    func request(_ demand: Subscribers.Demand)
}

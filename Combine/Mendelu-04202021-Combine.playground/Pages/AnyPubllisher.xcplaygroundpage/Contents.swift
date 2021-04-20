import Foundation
import Combine

// MARK: TASK 6
// Create two different publishers and erase them to anyPublisher

// MARK: AnyPublisher

var cancellables = Set<AnyCancellable>()

// Publisher which sends 1 value and complete
var oneValuePublisher: AnyPublisher<Int, Never>

// TODO:

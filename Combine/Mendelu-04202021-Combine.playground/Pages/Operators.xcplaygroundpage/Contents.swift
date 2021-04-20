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

// TODO:

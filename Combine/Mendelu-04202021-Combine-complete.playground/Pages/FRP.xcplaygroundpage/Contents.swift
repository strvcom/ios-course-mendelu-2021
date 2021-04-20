import Foundation

// Generate random array of string from a-z, A-Z, 0-9
let randomString = String.randomString(of: 100)

// MARK: TASK 1
// Return count of a character in randomString

// 1 - Imperative approach
// Check every letter and increase counter
func imperativeLetterCount(_ string: String, letter: Character) -> Int {
    var counter = 0
    randomString.forEach { character in
        if character == letter {
            counter += 1
        }
    }
    return counter
}

// 2 - Declarative approach
func declarativeLetterCount(_ string: String, letter: Character) -> Int {
    randomString
        .filter { $0 == letter }
        .count
}

let imperativeCount = imperativeLetterCount(randomString, letter: "a")
let declarativeCount = declarativeLetterCount(randomString, letter: "a")

assert(imperativeCount == declarativeCount, "Both functions should return same count")

print("✅ Count of letter 'a' in \(randomString) is \(declarativeCount)")

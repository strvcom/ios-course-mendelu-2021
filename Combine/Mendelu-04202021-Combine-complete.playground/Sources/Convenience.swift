import Foundation
import Combine

// MARK: String + random string

public extension String {
    static func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var string = ""
        for _ in 0 ..< length {
            string.append(letters.randomElement()!)
        }
        return string
    }
}

// MARK: Async methods

public func asyncTaskString(_ result: @escaping (String?, Error?) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        result(String.randomString(of: 10), nil)
    }
}

public func asyncTaskInt(_ string: String, letter: Character, result: @escaping (Int?, Error?) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        result(string
                .filter { $0 == letter }
                .count, nil)
    }
}

public func asyncTaskBool(_ count: Int, result: @escaping (Bool?, Error?) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if count > 3 {
            result(true, nil)
        }
        result(false, nil)
    }
}

// MARK: Async publishers methods

public func asyncTaskStringPublisher() -> AnyPublisher<String, Error> {
    Just(String.randomString(of: 10))
        .setFailureType(to: Error.self)
        .delay(for: 1, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

public func asyncTaskIntPublisher(_ string: String, letter: Character) -> AnyPublisher<Int, Error> {

    Just(string.filter { $0 == letter }.count)
        .setFailureType(to: Error.self)
        .delay(for: 1, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

public func asyncTaskBoolPublisher(_ count: Int) -> AnyPublisher<Bool, Error> {
    Just(count > 3)
        .setFailureType(to: Error.self)
        .delay(for: 1, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}

// MARK: URLS

public let courseSylabusURL = URL(string: "https://is.mendelu.cz/katalog/syllabus.pl?predmet=127492;zpet=../pracoviste/predmety.pl?id=8)")!
public let courseSupervisorURL = URL(string: "https://is.mendelu.cz/lide/clovek.pl?id=18583")!
public let courseSupervisorImageURL = URL(string: "https://is.mendelu.cz/lide/foto.pl?id=18583")!

// MARL: Random numbers
public struct RandomNumbersPublisherProvider{

    enum NumberError: Error {
        case tooMuchNumbers
    }

    public init() {}
    
    private var currentValue = CurrentValueSubject<Int, Error>(0)

    public func numbersPublisher() -> AnyPublisher<Int, Error> {
        startPostingNumbers()
        return currentValue.eraseToAnyPublisher()
    }

    public func throwError() {
        currentValue.send(completion: .failure(NumberError.tooMuchNumbers))
    }

    func startPostingNumbers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentValue.value += 1
            startPostingNumbers()
        }
    }
}


import Foundation
import Combine

class AsyncTaskSolver {

    // MARK: TASK 2
    // Implement function with asyncTaskString, asyncTaskInt, asyncTaskBool hierarchy
    // func asyncTaskString(_ result: @escaping (String?, Error?) -> Void)
    // func asyncTaskInt(_ string: String, letter: Character, result: @escaping (Int?, Error?) -> Void)
    // func asyncTaskBool(_ count: Int, result: @escaping (Bool?, Error?) -> Void)
    func solveAsyncTask() {

        asyncTaskString { string, error in
            guard error == nil else {
                print(error!)
                return
            }
            if let string = string {
                asyncTaskInt(string, letter: "a") { count, error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    if let count = count {
                        asyncTaskBool(count) { success, error in
                            guard error == nil else {
                                print(error!)
                                return
                            }

                            print("Successfully finished callback hell")
                        }
                    }
                }
            }
        }
    }

    // func asyncTaskStringPublisher() -> AnyPublisher<String, Error>
    // func asyncTaskIntPublisher(_ string: String, letter: Character) -> AnyPublisher<Int, Error>
    // func asyncTaskBoolPublisher(_ count: Int) -> AnyPublisher<Bool, Error>
    var cancellables = Set<AnyCancellable>()
    func solveAsyncTaskPublisher() {
        asyncTaskStringPublisher()
            .flatMap { asyncTaskIntPublisher($0, letter: "a") }
            .flatMap { asyncTaskBoolPublisher($0)}
            .sink { completion in
                print("Publisher completion \(completion)")
            } receiveValue: { _ in
                print("Successfully finished publishers")
            }
            .store(in: &cancellables)
    }
}

var asyncTaskSolver = AsyncTaskSolver()
asyncTaskSolver.solveAsyncTask()
asyncTaskSolver.solveAsyncTaskPublisher()

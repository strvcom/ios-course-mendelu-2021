
import Foundation
import Combine

class AsyncTaskSolver {

    // MARK: TASK 2
    // Implement function with asyncTaskString, asyncTaskInt, asyncTaskBool hierarchy
    // func asyncTaskString(_ result: @escaping (String?, Error?) -> Void)
    // func asyncTaskInt(_ string: String, letter: Character, result: @escaping (Int?, Error?) -> Void)
    // func asyncTaskBool(_ count: Int, result: @escaping (Bool?, Error?) -> Void)
    func solveAsyncTask() {

       // TODO:
    }

    // func asyncTaskStringPublisher() -> AnyPublisher<String, Error>
    // func asyncTaskIntPublisher(_ string: String, letter: Character) -> AnyPublisher<Int, Error>
    // func asyncTaskBoolPublisher(_ count: Int) -> AnyPublisher<Bool, Error>
    var cancellables = Set<AnyCancellable>()
    func solveAsyncTaskPublisher() {
        
        // TODO:
    }
}

var asyncTaskSolver = AsyncTaskSolver()
asyncTaskSolver.solveAsyncTask()
asyncTaskSolver.solveAsyncTaskPublisher()

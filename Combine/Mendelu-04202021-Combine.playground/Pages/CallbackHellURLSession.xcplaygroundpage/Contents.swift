import Foundation
import UIKit
import Combine
import PlaygroundSupport

// MARK: BONUS TASKS
// Read implementations of image loader

struct CourseSupervisorImageLoader {
    // MARK: Callback hell
    static func loadWithHellCourseSupervisorImage(_ imageHandler: @escaping (UIImage?) -> Void) {
        let urlSession = URLSession.shared
        let courseSylabusTask = urlSession.dataTask(with: URLRequest(url: courseSylabusURL)) { data, response, error in

            guard error == nil,
                  let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let html = String(data: data, encoding: .utf8),
                  html.contains("Ing. David Procházka, Ph.D.") else {

                imageHandler(nil)
                return
            }

            print("✅ Loaded course sylabus web page")

            let courseSupervisorTask = urlSession.dataTask(with: URLRequest(url: courseSupervisorURL)) { data, response, error in

                guard error == nil,
                      let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let html = String(data: data, encoding: .utf8),
                      html.contains("Ing. David Procházka, Ph.D.") else {

                    imageHandler(nil)
                    return
                }

                print("✅ Loaded course supervisor web page")

                let courseSupervisorImageTask = urlSession.dataTask(with: URLRequest(url: courseSupervisorImageURL)) { data, response, error in

                    guard  error == nil,
                           let data = data,
                           let httpResponse = response as? HTTPURLResponse,
                           httpResponse.statusCode == 200 else {

                        imageHandler(nil)
                        return
                    }

                    print("✅ Loaded course supervisor image")

                    imageHandler(UIImage(data: data))
                }

                courseSupervisorImageTask.resume()

            }
            courseSupervisorTask.resume()
        }
        courseSylabusTask.resume()
    }

    // MARK: - Combine version

    static func loadWithPleasureCourseSupervisorImage() -> AnyPublisher<UIImage?, URLError> {
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: courseSylabusURL))
            .filter { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return false
                }
                return true
            }
            .flatMap { _  ->  URLSession.DataTaskPublisher in
                URLSession.shared.dataTaskPublisher(for: URLRequest(url: courseSupervisorURL))
            }
            .filter { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return false
                }
                return true
            }
            .flatMap { _ ->  URLSession.DataTaskPublisher in
                URLSession.shared.dataTaskPublisher(for: URLRequest(url: courseSupervisorImageURL))
            }
            .filter { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return false
                }
                return true
            }
            .map { value -> UIImage? in
                UIImage(data: value.data)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: View controller to test image loader

class CourseSupervisorImageViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let courseSupervisorImageView = UIImageView()
        courseSupervisorImageView.frame = CGRect(x: 100, y: 100, width: 154, height: 192)
        CourseSupervisorImageLoader.loadWithHellCourseSupervisorImage { image in
            courseSupervisorImageView.image = image
        }

        view.addSubview(courseSupervisorImageView)
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = CourseSupervisorImageViewController()





import Combine
import UIKit
import PlaygroundSupport

// MARK: View controller with user actions using subjects

class SubjectsViewController : UIViewController {

    // Variables
    var colors: [UIColor] = [.red, .blue, .green]
    var randomColor: UIColor {
        colors[Int.random(in: 0...self.colors.count - 1)]
    }
    var backgroundColorButton: UIButton = UIButton()
    var backgroundColorPicker: UISegmentedControl = UISegmentedControl(items: ["RED", "BLUE", "GREEN"])

    // MARK: TASK 8
    // Use subjects to handle UI actions

    // TODO:

    var cancellables = Set<AnyCancellable>()

    override func loadView() {


        let view = UIView()
        view.backgroundColor = .white

        // background color setup
        backgroundColorButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorButton.backgroundColor = .white
        backgroundColorButton.setTitle("Change background color", for: .normal)
        backgroundColorButton.setTitleColor(.black, for: .normal)
        backgroundColorButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        view.addSubview(backgroundColorButton)

        // color picker setup
        backgroundColorPicker.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorPicker.addTarget(self, action: #selector(pickColor), for: .valueChanged)

        view.addSubview(backgroundColorPicker)

        self.view = view

        NSLayoutConstraint.activate([
            backgroundColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundColorButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            backgroundColorPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundColorPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            backgroundColorPicker.widthAnchor.constraint(equalToConstant: 200)
        ])

        binding()
    }

    func binding() {

        // TODO:
    }

    @IBAction func changeColor() {
        // TODO:
    }

    @IBAction func pickColor(colorPicker: UISegmentedControl) {
        // TODO:
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = SubjectsViewController()

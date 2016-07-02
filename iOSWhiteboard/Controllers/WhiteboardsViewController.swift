import UIKit
import Whiteboard

struct State {
    var id: String?
    var error: WhiteboardValidationError?
}

class WhiteboardsViewController: UIViewController {
    @IBOutlet var validationErrorLabel: UILabel?
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var submitButton: UIButton?
    @IBOutlet var newlyCreatedWhiteboardIDLabel: UILabel?

    var state = State()
    var whiteboardRepository: WhiteboardRepository = WhiteboardRepositoryFake()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render()
    }
}

extension WhiteboardsViewController: Gui {
    func validationFailed(errors: [WhiteboardValidationError]) {
        state.id = nil
        state.error = errors.first
        render()
    }

    func whiteboardCreated(id: String) {
        state.id = id
        state.error = nil
        render()
    }
}

extension WhiteboardsViewController {

    @IBAction
    func submitButtonTapped() {
        if let nameTextField = nameTextField, name = nameTextField.text {
            createWhiteboard(name: name, gui: self, repo: whiteboardRepository)
        }
    }

}

extension WhiteboardsViewController {
    func render() {
        if let newlyCreatedWhiteboardIDLabel = newlyCreatedWhiteboardIDLabel,
            validationErrorLabel = validationErrorLabel {
            if let error = state.error {
                validationErrorLabel.text = "\(error.field) must be \(error.validation)"
                validationErrorLabel.isHidden = false
                newlyCreatedWhiteboardIDLabel.isHidden = true
            } else if let id = state.id {
                newlyCreatedWhiteboardIDLabel.text = id
                newlyCreatedWhiteboardIDLabel.isHidden = false
                validationErrorLabel.isHidden = true
            } else {
                newlyCreatedWhiteboardIDLabel.isHidden = true
                validationErrorLabel.isHidden = true
            }
        }
    }
}

import UIKit
import Whiteboard

struct State {
    var id: String?
    var error: WhiteboardError?
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
    func validationFailed(errors: [WhiteboardError]) {
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
                validationErrorLabel.text = WhiteboardErrorFormatter().formattedError(error: error)
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

class WhiteboardErrorFormatter {

    func formattedError(error: WhiteboardError) -> String {
        switch (error) {
        case .Validation(let field, let validation):
            switch (field) {
            case .Name:
                switch (validation) {
                case .Unique: return "name must be unique"
                case .Required: return "name is required"
                }
            }
        default:
            return ""
        }
    }

}

import XCTest
@testable import iOSWhiteboard
import Whiteboard

class WhiteboardsViewControllerTests: XCTestCase {
    var subject: WhiteboardsViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        subject = storyboard.instantiateViewController(withIdentifier: "WhiteboardsViewController") as! WhiteboardsViewController
        subject.renderView()
    }

    func testWhenTheViewAppearsItHidesTheValidationErrors() {
        XCTAssertTrue(subject.validationErrorLabel!.isHidden)
    }

    func testWhenTheViewAppearsItHidesTheNewlyCreatedWhiteboardIDLabel() {
        XCTAssertTrue(subject.newlyCreatedWhiteboardIDLabel!.isHidden)
    }

    func testWhenSubmitButtonIsTappedItHidesErrors() {
        subject.validationErrorLabel!.isHidden = false

        subject.nameTextField!.text = "some text"
        subject.submitButton!.sendActions(for: .touchUpInside)

        XCTAssertTrue(subject.validationErrorLabel!.isHidden)
    }

    func testItDisplaysNewlyCreatedWhiteboardDetails() {
        subject.whiteboardCreated(id: "id")

        XCTAssertFalse(subject.newlyCreatedWhiteboardIDLabel!.isHidden)
        XCTAssertEqual(subject.newlyCreatedWhiteboardIDLabel!.text!, "id")
    }

    func test_whenThereIsAnError_ItDisplaysValidationErrors_ItDoesNotDisplayAnId() {
        subject.state.id = "some id"
        XCTAssertTrue(subject.validationErrorLabel!.isHidden)

        let error = WhiteboardError.Validation(field: .Name, validation: .Unique)
        subject.validationFailed(errors: [error])

        XCTAssertFalse(subject.validationErrorLabel!.isHidden)
        XCTAssertTrue(subject.newlyCreatedWhiteboardIDLabel!.isHidden)

        XCTAssertEqual(subject.validationErrorLabel!.text!, "name must be unique")
    }
}

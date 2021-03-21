//
//  InfoViewControllerTests.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample

class InfoViewControllerTests: XCTestCase
{
    var viewController: InfoViewController!
	var view: UIView!

    override func setUp() {
        super.setUp()
		self.continueAfterFailure = false

		viewController = (UIViewController.loadFromStoryboard(identifier: "InfoViewController") as! InfoViewController)
		view = viewController.view!
    }

	override func tearDown() {
		super.tearDown()
		UIViewController.flushPendingTestArtifacts()
	}

    func testDoneButton() {
        let doneButton = view.viewWithAccessibilityIdentifier("Done") as! UIButton

        doneButton.simulateTouch()

        XCTAssertTrue(viewController.hasBeenDismissed)
    }
    
    func testLightBulbButton() {
        let lightBulbButton = view.viewWithAccessibilityIdentifier("LightBulbButton") as! UIButton
        let lightBulbLabel = view.viewWithAccessibilityIdentifier("LightBulb") as! UILabel

        lightBulbButton.simulateTouch()

        let alertController = viewController.mostRecentlyPresentedViewController as? UIAlertController
        XCTAssertNotNil(alertController)
        let alertAction = alertController!.action(withStyle: .default)
        XCTAssertNotNil(alertAction)
        XCTAssertTrue(lightBulbLabel.isHidden)

        alertAction!.simulateTouch()

        XCTAssertFalse(lightBulbLabel.isHidden)
    }

    func testPickerViewDisplaysSelectedRow() {
        let pickerView = view.viewWithAccessibilityIdentifier("PickerView") as! UIPickerView
        let pickerLabel = view.viewWithAccessibilityIdentifier("PickerLabel") as! UILabel

        pickerView.simulateSwipe(toRow: 3, inComponent: 0)

        XCTAssertEqual(pickerLabel.text, "4")
    }

    func testDatePickerDisplayDayOfWeek() {
        let datePicker = view.viewWithAccessibilityIdentifier("DatePicker") as! UIDatePicker
        let dayOfWeekLabel = view.viewWithAccessibilityIdentifier("DayOfWeekrLabel") as! UILabel
        let today = Date.today
        let tomorrow = Date.tomorrow

        XCTAssertEqual(dayOfWeekLabel.text, today.dayOfWeek)

        datePicker.simulateSwipe(toDate: tomorrow)
        XCTAssertEqual(dayOfWeekLabel.text, tomorrow.dayOfWeek)
    }

	func testGestureTogglesIconVisibilityViaExpectations() {
		let infoLabel = view.viewWithAccessibilityIdentifier("Info") as! UILabel
		let iconLabel = view.viewWithAccessibilityIdentifier("Icon") as! UILabel
		let gestureRecognizer = infoLabel.gestureRecognizers?.first { $0 is UILongPressGestureRecognizer }

		XCTAssertTrue(iconLabel.isHidden)
		XCTAssertEqual(gestureRecognizer?.state, .possible)
		XCTAssertTrue(gestureRecognizer!.isEnabled)

		self.waitForRecognizedState(of: gestureRecognizer!)
		XCTAssertFalse(iconLabel.isHidden)

		self.waitForRecognizedState(of: gestureRecognizer!)
		XCTAssertTrue(iconLabel.isHidden)
	}

	func testGestureTogglesIconVisibilityViaSimulation() {
		let infoLabel = view.viewWithAccessibilityIdentifier("Info") as! UILabel
		let iconLabel = view.viewWithAccessibilityIdentifier("Icon") as! UILabel
		let gestureRecognizer = infoLabel.gestureRecognizers?.first { $0 is UILongPressGestureRecognizer }

		XCTAssertTrue(iconLabel.isHidden)
		XCTAssertEqual(gestureRecognizer?.state, .possible)
		XCTAssertTrue(gestureRecognizer!.isEnabled)

		gestureRecognizer?.simulateRecognition()
		XCTAssertFalse(iconLabel.isHidden)

		gestureRecognizer?.simulateRecognition()
		XCTAssertTrue(iconLabel.isHidden)
	}
}

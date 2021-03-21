//
//  MiscellaneousTests.swift
//
//	These tests are mostly just here to test UIUTest itself or get the code coverage to 100%.
//
//  Copyright © 2018-2021 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTest
import UIUTestExample

class MiscellaneousTests: XCTestCase
{
	func testPushSiblingViewControllerStoryboardLoad() {
		let viewController = UIViewController.loadFromStoryboard(identifier: "ButtonsViewController", forNavigation: true) as! ButtonsViewController
		let navigationController = viewController.navigationController!

		viewController.pushSiblingViewController(withIdentifier: "SwitchesViewController", storyBoardName: "Main", animated: true)
		UIView.allowAnimation()

		XCTAssertNotNil(navigationController.topViewController as? SwitchesViewController)
	}

	func testDefaultAuthenticator() {
		let defaultAuthenticator = DefaultAuthenticator()

		XCTAssertTrue(defaultAuthenticator.authenticate(user: DefaultAuthenticator.validUser, password: DefaultAuthenticator.validPassword))
	}

    func testViewControllerEndsLifecycleWhenTestArtifactsAreFlushed() {
        let viewController = SpyViewController()
        viewController.loadForTesting()
        RunLoop.current.singlePass()
        RunLoop.current.singlePass()

        XCTAssertEqual(viewController.viewDidAppearCount, 1)
        XCTAssertEqual(viewController.viewDidDisappearCallCount, 0)

        UIViewController.flushPendingTestArtifacts()

        XCTAssertEqual(viewController.viewDidAppearCount, 1)
        XCTAssertEqual(viewController.viewDidDisappearCallCount, 1)
    }
}

extension MiscellaneousTests
{
    class SpyViewController: UIViewController
    {
        var viewDidAppearCount = 0
        var viewDidDisappearCallCount = 0

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.viewDidAppearCount += 1
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            self.viewDidDisappearCallCount += 1
        }
    }
}

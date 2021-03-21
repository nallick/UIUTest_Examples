//
//  TableViewControllerTests.swift
//
//  Copyright © 2017-2021 Purgatory Design. Licensed under the MIT License.
//

import XCTest
import UIUTestExample

class TableViewControllerTests: XCTestCase
{
    var viewController: TableViewController!
    var tableView: UITableView!

    override func setUp() {
        super.setUp()

		viewController = (UIViewController.loadFromStoryboard(identifier: "TableViewController") as! TableViewController)
        tableView = viewController.tableView!
    }

	override func tearDown() {
		super.tearDown()
		UIViewController.flushPendingTestArtifacts()
	}

    func testSegueFromInfoButtonToInfoViewController() {
        tableView.simulateAccessoryTouch(at: IndexPath(row: 1, section: 0))

        let segue = viewController.mostRecentlyPerformedSegue
        XCTAssertEqual(segue?.identifier, "Info")
        XCTAssertNotNil(segue?.destination as? InfoViewController)
    }

    func testSegueFromTableToNextViewController() {
        tableView.simulateTouch(at: IndexPath(row: 3, section: 0))

        let segue = viewController.mostRecentlyPerformedSegue
        XCTAssertEqual(segue?.identifier, "Next")
        XCTAssertNotNil(segue?.destination as? ButtonsViewController)
    }

    func testDeleteEditableTableViewCell() {
        let initialRowCount = viewController.tableView(tableView, numberOfRowsInSection: 0)

        tableView.simulateEdit(.delete, rowAt: IndexPath(row: viewController.editableCellIndex, section: 0))
        let finalRowCount = viewController.tableView(tableView, numberOfRowsInSection: 0)

        XCTAssertEqual(finalRowCount, initialRowCount - 1)
    }

    func testMoveEditableTableViewCell() {
        let initialRowCount = viewController.tableView(tableView, numberOfRowsInSection: 0)
        let initialIndex = IndexPath(row: viewController.editableCellIndex, section: 0)
        let finalIndex = IndexPath(row: 0, section: 0)
        let initialCell = tableView.cellForRow(at: initialIndex)

        tableView.isEditing = true
        tableView.simulateEdit(moveRowAt: initialIndex, to: finalIndex)
        let finalRowCount = viewController.tableView(tableView, numberOfRowsInSection: 0)
        let finalCell = tableView.cellForRow(at: finalIndex)

        XCTAssertEqual(finalRowCount, initialRowCount)
        XCTAssertEqual(finalCell, initialCell)
    }
}

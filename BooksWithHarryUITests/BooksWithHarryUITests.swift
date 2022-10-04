//
//  BooksWithHarryUITests.swift
//  BooksWithHarryUITests
//
//  Created by Kristian Andersen on 26/09/2022.
//

import XCTest

class BooksWithHarryUITests: XCTestCase {
	var app: XCUIApplication!

    override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		app.launchArguments = ["testing"]
		app.launch()
    }

	func testHeaderHasQuery() {
		XCTAssertTrue(app.staticTexts["Query: harry"].exists)
	}

	func testAppLoadsCells() {
		XCTAssertTrue(app.cells.count >= 5)
	}

	func testCellsShowData() {
		let collectionView = app.collectionViews.element(boundBy: 0)
		let firstCell = collectionView.cells.element(boundBy: 0)

		let titleLabel = firstCell.staticTexts.matching(identifier: "searchCellTitleLabel").firstMatch.label
		XCTAssertTrue(titleLabel.hasPrefix("Harry Potter"))

		let authorLabel = firstCell.staticTexts.matching(identifier: "searchCellAuthorLabel").firstMatch.label
		XCTAssertEqual(authorLabel, "by J.K. Rowling")

		let narratorLabel = firstCell.staticTexts.matching(identifier: "searchCellNarratorLabel").firstMatch.label
		XCTAssertEqual(narratorLabel, "with Björn Kjellman")
	}
}

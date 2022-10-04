//
//  ModelJSONParsing.swift
//  BooksWithHarryTests
//
//  Created by Kristian Andersen on 02/10/2022.
//

import Foundation
import XCTest
@testable import BooksWithHarry

// This is not a very thorough test case. We're just making sure
// that at least the basic response parses. You would want to make
// sure all the models parses they properties correctly
// Also to make sure that edgecases in the data are fulfilled.
class ModelTests: XCTestCase {
	var decoder: JSONDecoder!

	override func setUpWithError() throws {
		decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		try super.setUpWithError()
	}

	override func tearDownWithError() throws {
		decoder = nil
		try super.tearDownWithError()
	}

	func test_models_parses_first_10_results() async throws {
		let first10: SearchResponse = try await jsonDecode(fromFile: "harry-10", decoder: decoder)

		XCTAssertEqual(first10.items.count, 10)
		XCTAssertEqual(first10.query, "harry")
		XCTAssertEqual(first10.nextPageToken, "10")
	}

	func test_parses_all_properties_of_book() async throws {
		let sut: Book = try await jsonDecode(fromFile: "harry-1", decoder: decoder)

		XCTAssertEqual(sut.id, "134970")
		XCTAssertEqual(sut.title, "Harry Potter och Hemligheternas kammare")
		XCTAssertEqual(sut.language, "sv")
		XCTAssertTrue(sut.isKidsBook)
		XCTAssertNotNil(sut.seriesInfo)
		XCTAssert(sut.authors.count == 1)
		XCTAssert(sut.narrators.count == 1)
		XCTAssert(sut.formats.count == 2)
	}

	func test_parses_all_foramts() async throws {
		let book: Book = try await jsonDecode(fromFile: "harry-1", decoder: decoder)

		let firstFormat = book.formats[0]
		XCTAssertEqual(firstFormat.id, "919648")
		XCTAssertEqual(firstFormat.type, "ebook")
		XCTAssertEqual(firstFormat.releaseDate, try Date("2015-12-08T00:00:00Z", strategy: .iso8601))
		XCTAssertTrue(firstFormat.isReleased)
		XCTAssertFalse(firstFormat.isLockedContent)

		let secondFormat = book.formats[1]
		XCTAssertEqual(secondFormat.id, "134970")
		XCTAssertEqual(secondFormat.type, "abook")
		XCTAssertEqual(secondFormat.releaseDate, try Date("2017-07-13T00:00:00Z", strategy: .iso8601))
		XCTAssertTrue(secondFormat.isReleased)
		XCTAssertFalse(secondFormat.isLockedContent)
	}

	func test_parses_all_book_covers() async throws {
		let book: Book = try await jsonDecode(fromFile: "harry-1", decoder: decoder)

		let firstCover = book.formats[0].cover
		XCTAssertEqual(firstCover.url, URL(string: "https://covers.storytel.com/jpg-640/9781781105658.456743a3-8761-464e-a978-ab6c7e2a0639")!)
		XCTAssertEqual(firstCover.width, 427)
		XCTAssertEqual(firstCover.height, 640)

		let secondCover = book.formats[1].cover
		XCTAssertEqual(secondCover.url, URL(string: "https://covers.storytel.com/jpg-640/9781781108963.840360dc-84e7-4a25-af7f-e254cd897ff7")!)
		XCTAssertEqual(secondCover.width, 640)
		XCTAssertEqual(secondCover.height, 640)
	}

	func test_parses_all_book_people() async throws {
		let book: Book = try await jsonDecode(fromFile: "harry-1", decoder: decoder)

		XCTAssertEqual(book.authors[0].id, "1998")
		XCTAssertEqual(book.authors[0].name, "J.K. Rowling")

		XCTAssertEqual(book.narrators[0].id, "167")
		XCTAssertEqual(book.narrators[0].name, "Björn Kjellman")
	}

	func test_parses_book_with_audio_format_only() async throws {
		let book: Book = try await jsonDecode(fromFile: "djuren", decoder: decoder)

		XCTAssertEqual(book.id, "1711322")
		XCTAssertEqual(book.formats.count, 1)
		XCTAssertEqual(book.formats[0].type, "abook")
	}

	func test_parses_pre_release_book() async throws {
		let sut: Book = try await jsonDecode(fromFile: "prerelease", decoder: decoder)

		XCTAssertEqual(sut.id, "134970")
		XCTAssertTrue(sut.formats[0].releaseDate.timeIntervalSince1970 > Date().timeIntervalSince1970)
		XCTAssertTrue(sut.formats[1].releaseDate.timeIntervalSince1970 > Date().timeIntervalSince1970)
		XCTAssertFalse(sut.formats[0].isReleased)
		XCTAssertFalse(sut.formats[1].isReleased)
	}

	func test_parsing_fails_for_book_with_missing_id() async throws {
		do {
			let _: Book = try await jsonDecode(fromFile: "missingid", decoder: decoder)

			// Should not reach because an error should be thrown
			XCTFail()
		} catch {
			XCTAssertTrue(error is DecodingError)
		}
	}
}

extension XCTestCase {
	func jsonDecode<T: Decodable>(fromFile file: String, decoder: JSONDecoder) async throws -> T {
		guard let path = Bundle(for: Self.self).path(forResource: file, ofType: "json") else {
			fatalError("Can't find json file ")
		}

		let data = try Data(contentsOf: URL(fileURLWithPath: path))
		return try decoder.decode(T.self, from: data)
	}
}

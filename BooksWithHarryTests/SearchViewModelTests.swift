//
//  BooksWithHarryTests.swift
//  BooksWithHarryTests
//
//  Created by Kristian Andersen on 26/09/2022.
//

import XCTest
@testable import BooksWithHarry

class SearchViewModelTests: XCTestCase {
	var decoder: JSONDecoder!
	var service: MockSearchService!
	var output: MockSearchViewModelOutput!
	var sut: SearchViewModel!

    override func setUpWithError() throws {
		decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		service = MockSearchService()
		output = MockSearchViewModelOutput()
		sut = SearchViewModel(service: service)
		sut.output = output

		try super.setUpWithError()
    }

	override func tearDownWithError() throws {
		sut = nil
		service = nil
		output = nil
		decoder = nil

		try super.tearDownWithError()
    }

    func test_fetching_next_result_triggers_output() async throws {
		let response: SearchResponse = try await jsonDecode(fromFile: "harry-10", decoder: decoder)
		service.resultToReturn = .success(response)

		await sut.fetchNextResults(forQuery: "harry")
		XCTAssertEqual(output.errorsGiven.count, 0)
		XCTAssertEqual(output.resultsGiven.count, 1)
		XCTAssertEqual(output.resultsGiven[0].items[0].id, response.items[0].id)
		XCTAssertTrue(sut.shouldLoadNextResults())
    }

	func test_fetch_fail_triggers_failure_output() async throws {
		service.resultToReturn = .failure(.emptyResponse)

		await sut.fetchNextResults(forQuery: "harry")
		XCTAssertEqual(output.errorsGiven.count, 1)
		XCTAssertEqual(output.resultsGiven.count, 0)
		XCTAssertTrue(output.errorsGiven[0] is APIClientError)
		XCTAssertTrue(sut.shouldLoadNextResults())
	}

	func test_fetching_one_page_result_output() async throws {
		let response: SearchResponse = try await jsonDecode(fromFile: "onepage", decoder: decoder)
		service.resultToReturn = .success(response)

		await sut.fetchNextResults(forQuery: "harry")
		XCTAssertEqual(output.resultsGiven[0].items.count, response.items.count)
		XCTAssertEqual(output.resultsGiven[0].nextPageToken, nil)
		XCTAssertFalse(sut.shouldLoadNextResults())
	}
}

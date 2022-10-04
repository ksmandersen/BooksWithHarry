//
//  MockSearchViewModelOutput.swift
//  BooksWithHarryTests
//
//  Created by Kristian Andersen on 02/10/2022.
//

import Foundation
@testable import BooksWithHarry

class MockSearchViewModelOutput: SearchViewModelOutput {
	var errorsGiven: [Error] = []
	var resultsGiven: [SearchResponse] = []

	func searchFailed(withError error: Error) {
		errorsGiven.append(error)
	}

	func searchResultsUpdated(_ results: SearchResponse) {
		resultsGiven.append(results)
	}
}

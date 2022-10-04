//
//  MockAPIClient.swift
//  BooksWithHarryTests
//
//  Created by Kristian Andersen on 01/10/2022.
//

import Foundation
@testable import BooksWithHarry

class MockSearchService: SearchService {
	var resultToReturn: Result<SearchResponse, APIClientError> = .failure(.unknownError)

	func fetchSearch(for query: String, nextPageToken: String?) async -> Result<SearchResponse, APIClientError> {
		return resultToReturn
	}
}

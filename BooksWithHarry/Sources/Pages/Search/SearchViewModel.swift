//
//  SearchViewModel.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 30/09/2022.
//

import Foundation

class SearchViewModel {
	private let service: SearchService
	private var isLoading: Bool = false
	private var nextPageToken: String?
	private var hasReachedLastPageToken: Bool = false

	private var totalCount = 1
	private var loadedCount = 0

	weak var output: SearchViewModelOutput?

	init(service: SearchService) {
		self.service = service
	}

	func shouldLoadNextResults() -> Bool {
		return !isLoading && loadedCount < totalCount && !hasReachedLastPageToken
	}

	func fetchNextResults(forQuery query: String) async {
		// We have loaded all avaialble results or we are already loading
		guard shouldLoadNextResults() else { return }

		await fetchResults(forQuery: query, withPageToken: nextPageToken)
	}

	private func fetchResults(forQuery query: String,
							  withPageToken pageToken: String? = nil) async {
		let result = await self.service.fetchSearch(for: query, nextPageToken: nextPageToken)

		switch result {
		case let .success(searchResponse):
			if searchResponse.nextPageToken == self.nextPageToken {
				self.hasReachedLastPageToken = true
			}

			self.nextPageToken = searchResponse.nextPageToken
			self.totalCount = searchResponse.totalCount
			self.loadedCount += searchResponse.items.count
			self.output?.searchResultsUpdated(searchResponse)
		case let .failure(error):
			self.output?.searchFailed(withError: error)
		}

		self.isLoading = false
	}
}


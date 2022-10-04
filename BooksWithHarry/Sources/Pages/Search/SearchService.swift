//
//  SearchService.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 02/10/2022.
//

import Foundation

protocol SearchService: AnyObject {
	func fetchSearch(for query: String, nextPageToken: String?) async -> Result<SearchResponse, APIClientError>
}

extension APIClient: SearchService {
	func fetchSearch(for query: String, nextPageToken: String? = nil) async -> Result<SearchResponse, APIClientError> {
		let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query

		var params = [
			"query": escapedQuery,
			"searchFor": "books",
			"store": "STHP-SE",
		]

		if let nextPageToken = nextPageToken {
			params["page"] = nextPageToken
		}

		guard let url = buildURL(to: "/search/client", params: params) else {
			return .failure(.invalidURL)
		}

		return await fetch(url: url)
	}
}

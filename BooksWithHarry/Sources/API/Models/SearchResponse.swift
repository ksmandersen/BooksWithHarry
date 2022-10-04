//
//  SearchResponse.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

struct SearchResponse: Codable {
	let items: [Book]
	let query: String
	let totalCount: Int
	let nextPageToken: String?
}

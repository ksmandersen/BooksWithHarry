//
//  SearchViewModelOutput.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 02/10/2022.
//

import Foundation

protocol SearchViewModelOutput: AnyObject {
	func searchResultsUpdated(_ results: SearchResponse)
	func searchFailed(withError: Error)
}

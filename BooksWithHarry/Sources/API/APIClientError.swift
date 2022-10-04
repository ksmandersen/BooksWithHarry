//
//  APIClientError.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

enum APIClientError: Error {
	case jsonDecodingError(DecodingError)
	case wrappedSessionError(Error)
	case invalidResponse(Int)
	case invalidURL
	case emptyResponse
	case unknownError
}

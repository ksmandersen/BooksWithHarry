//
//  APIClient.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

class APIClient {
	let baseURL: URL
	let session: URLSession
	let decoder: JSONDecoder

	init(baseURL: URL, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
		self.baseURL = baseURL
		self.session = session
		self.decoder = decoder

		self.decoder.dateDecodingStrategy = .iso8601
	}

	func buildURL(to path: String, params: [String: String]) -> URL? {
		guard var components = URLComponents(string: path) else {
			return nil
		}

		components.queryItems = params.map { key, value in
			URLQueryItem(name: key, value: value)
		}

		return components.url(relativeTo: baseURL)
	}

	func fetch<T: Decodable>(url: URL, rootKey: String? = nil) async -> Result<T, APIClientError> {
		do {
			let (data, response) = try await session.data(from: url)

			guard let httpResponse = response as? HTTPURLResponse else {
				return .failure(.unknownError)
			}

			guard (200...299).contains(httpResponse.statusCode) else {
				return .failure(.invalidResponse(httpResponse.statusCode))
			}

			let result = try decoder.decode(T.self, from: data)
			return .success(result)
		} catch let error as DecodingError {
			return .failure(.jsonDecodingError(error))
		} catch {
			return .failure(.wrappedSessionError(error))
		}
	}
}

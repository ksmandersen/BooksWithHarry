//
//  ImageLoader.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 29/09/2022.
//

import Foundation
import UIKit

enum ImageLoaderError: Error {
	case unableToParseImageData
}

// This is a very basic Image Loader class that we can
// easily and quickly use to fetch and save some images for
// the cells in memory. It could be improved by saving images
// to disk or by backing it with NSCache. It could also benefit from
// returning task handlers rather than an async API, such that image
// requests can be cancelled if cells are reused before requests complete.
actor ImageLoader {
	private var images: [URLRequest: ImageStatus] = [:]

	func fetch(url: URL) async throws -> UIImage {
		let request = URLRequest(url: url)
		return try await fetch(request)
	}

	func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
		if let status = images[urlRequest] {
			switch status {
			case .complete(let image):
				return image
			case .inProgress(let task):
				return try await task.value
			}
		}

		// Here we could check if the image is already on disk to
		// avoid unnecessary network round trips.

		let task: Task<UIImage, Error> = Task {
			let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
			guard let image = UIImage(data: imageData) else {
				throw ImageLoaderError.unableToParseImageData
			}

			// Here we could persist the image to disk for better caching
			return image
		}

		images[urlRequest] = .inProgress(task)
		let image = try await task.value

		images[urlRequest] = .complete(image)
		return image
	}

	private enum ImageStatus {
		case inProgress(Task<UIImage, Error>)
		case complete(UIImage)
	}
}

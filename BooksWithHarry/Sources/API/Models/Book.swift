//
//  Book.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

struct Book: Codable {
	let id: String
	let title: String
	let language: String

	let seriesInfo: SeriesInfo?
	let authors: [Person]
	let narrators: [Person]
	let formats: [BookFormat]

	let isKidsBook: Bool

	enum CodingKeys: String, CodingKey {
		case id, title, language
		case seriesInfo, authors, narrators, formats
		case isKidsBook = "kidsBook"
	}
}

extension Book: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}

	static func == (lhs: Book, rhs: Book) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Book: Identifiable {}

extension Book {
	var eBook: BookFormat? {
		return formats.first(where: { $0.type == "ebook" })
	}

	var audioBook: BookFormat? {
		return formats.first(where: { $0.type == "abook" })
	}
}


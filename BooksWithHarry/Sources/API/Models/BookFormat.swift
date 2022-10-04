//
//  BookFormat.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

struct BookFormat: Codable {
	let id: String
	let cover: BookCover
	let releaseDate: Date

	let type: String
	let isReleased: Bool
	let isLockedContent: Bool
}

extension BookFormat: Identifiable {}

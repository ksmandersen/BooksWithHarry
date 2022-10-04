//
//  Person.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

struct Person: Codable {
	let id: String
	let name: String
	let deepLink: URL?
}

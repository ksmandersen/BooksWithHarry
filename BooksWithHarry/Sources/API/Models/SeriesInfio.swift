//
//  SeriesInfio.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import Foundation

struct SeriesInfo: Codable {
	let id: String
	let name: String
	let orderInSeries: Int
	let deepLink: URL
}

extension SeriesInfo: Identifiable {}

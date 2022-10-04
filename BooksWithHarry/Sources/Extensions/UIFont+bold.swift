//
//  UIFont+bold.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 03/10/2022.
//

import Foundation
import UIKit

extension UIFont {
	var bold: UIFont {
		return with(.traitBold)
	}

	func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
		let symbolicTraits = UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)
		
		guard let descriptor = self.fontDescriptor.withSymbolicTraits(symbolicTraits) else {
			return self
		}

		return UIFont(descriptor: descriptor, size: 0)
	}
}

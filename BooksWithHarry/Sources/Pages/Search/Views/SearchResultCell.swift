//
//  SearchResultCell.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 29/09/2022.
//

import Foundation
import UIKit

class SearchResultCell: CollectionViewCell, ReusableView {
	lazy var contentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 2
		stackView.distribution = .fill
		stackView.alignment = .leading
		stackView.translatesAutoresizingMaskIntoConstraints = false

		return stackView
	}()

	lazy var bookCoverImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .lightGray
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}()

	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .callout).bold
		label.numberOfLines = 1
		label.textColor = .black
		label.accessibilityIdentifier = "searchCellTitleLabel"

		return label
	}()

	let authorLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .footnote)
		label.numberOfLines = 1
		label.accessibilityIdentifier = "searchCellAuthorLabel"
		return label
	}()

	let narratorLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .preferredFont(forTextStyle: .footnote)
		label.accessibilityIdentifier = "searchCellNarratorLabel"
		return label
	}()

	let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = .black.withAlphaComponent(0.075)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override func configureView() {
		super.configureView()

		contentStackView.addArrangedSubview(titleLabel)
		contentStackView.addArrangedSubview(authorLabel)
		contentStackView.addArrangedSubview(narratorLabel)
		contentStackView.addArrangedSubview(UIView())

		contentStackView.setCustomSpacing(8, after: titleLabel)

		contentView.addSubview(bookCoverImageView)
		contentView.addSubview(contentStackView)
		contentView.addSubview(separatorView)

		NSLayoutConstraint.activate([
			bookCoverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			bookCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			bookCoverImageView.trailingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: -10),
			bookCoverImageView.widthAnchor.constraint(equalToConstant: 90),
			bookCoverImageView.heightAnchor.constraint(equalToConstant: 90),
			contentStackView.topAnchor.constraint(equalTo: bookCoverImageView.topAnchor),
			contentStackView.bottomAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor),
			contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			separatorView.leadingAnchor.constraint(equalTo: bookCoverImageView.leadingAnchor),
			separatorView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
			separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1),
			separatorView.heightAnchor.constraint(equalToConstant: 1),
		])
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		bookCoverImageView.image = nil
		titleLabel.text = " "
		authorLabel.text = " "
		narratorLabel.text = " "
	}
}

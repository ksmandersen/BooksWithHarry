//
//  SearchResultsViewController.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import UIKit

class SearchViewController: UIViewController {
	private let viewModel: SearchViewModel
	private let imageLoader: ImageLoader
	private var dataSource: UICollectionViewDiffableDataSource<Int, Book>!

	private var query = "harry"
	private var numberOfRows = 0

	var contentView: SearchResultsView {
		view as! SearchResultsView
	}

	var collectionView: UICollectionView {
		contentView.collectionView
	}

	var loadingIndicatorView: UIActivityIndicatorView? {
		let sectionFooter = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter,
															 at: IndexPath(item: 0, section: 0))
		return (sectionFooter as? SearchSectionFooterView)?.loadingIndicatorView
	}

	init(viewModel: SearchViewModel, imageLoader: ImageLoader) {
		self.viewModel = viewModel
		self.imageLoader = imageLoader
		super.init(nibName: nil, bundle: nil)

		self.viewModel.output = self
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		view = SearchResultsView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		dataSource = createDataSource()

		collectionView.register(SearchResultCell.self,
								forCellWithReuseIdentifier: SearchResultCell.defaultReuseIdentifier)
		collectionView.register(SearchSectionFooterView.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
								withReuseIdentifier: SearchSectionFooterView.defaultReuseIdentifier)
		collectionView.register(SearchQueryHeaderView.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
								withReuseIdentifier: SearchQueryHeaderView.defaultReuseIdentifier)
		collectionView.delegate = self
		collectionView.dataSource = dataSource
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		loadData()
	}

	private func loadImage(forCell cell: SearchResultCell, from url: URL) {
		// extract this into a func
		Task(priority: .userInitiated) { [weak self] in
			if let image = try? await self?.imageLoader.fetch(url: url) {
				await MainActor.run { [weak cell] in
					cell?.bookCoverImageView.image = image
				}
			}
		}
	}

	private func createDataSource() -> UICollectionViewDiffableDataSource<Int, Book> {
		let dataSource: UICollectionViewDiffableDataSource<Int, Book> = .init(collectionView: collectionView) { collectionView, indexPath, book in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.defaultReuseIdentifier,
														  for: indexPath) as! SearchResultCell

			cell.titleLabel.text = book.title

			// Prefer the audiobook covers (since they're usually square dimensions)
			// We could improve performance by preloading the images with collectionview delegate methods.
			if let format = book.audioBook {
				self.loadImage(forCell: cell, from: format.cover.url)
			} else if let firstFormat = book.formats.first {
				self.loadImage(forCell: cell, from: firstFormat.cover.url)
			}

			cell.authorLabel.text = "by \(book.authors.map({ $0.name }).joined(separator: ", "))"
			if book.narrators.count > 0 {
				cell.narratorLabel.text = "with \(book.narrators.map({ $0.name }).joined(separator: ", "))"
			} else {
				cell.narratorLabel.text = " "
			}

			return cell
		}

		dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
			switch kind {
			case UICollectionView.elementKindSectionFooter:
				return self?.prepareLoadingFooterView(in: collectionView, at: indexPath)
			case UICollectionView.elementKindSectionHeader:
				return self?.prepareHeaderQueryView(in: collectionView, at: indexPath)
			default: return nil
			}
		}

		return dataSource
	}

	private func prepareLoadingFooterView(in collectionView: UICollectionView,
										  at indexPath: IndexPath) -> UICollectionReusableView {
		return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
															   withReuseIdentifier: SearchSectionFooterView.defaultReuseIdentifier,
															   for: indexPath)
	}

	private func prepareHeaderQueryView(in collectionView: UICollectionView,
										at indexPath: IndexPath) -> UICollectionReusableView? {
		let kind = UICollectionView.elementKindSectionHeader
		let reuseIdentifier = SearchQueryHeaderView.defaultReuseIdentifier

		guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
																			   withReuseIdentifier: reuseIdentifier,
																			   for: indexPath) as? SearchQueryHeaderView else {
			return nil
		}

		headerView.queryLabel.text = "Query: \(self.query)"

		return headerView
	}

	private func loadData() {
		guard viewModel.shouldLoadNextResults() else { return }

		loadingIndicatorView?.startAnimating()
		Task(priority: .userInitiated) { [weak self] in
			guard let self = self else { return }
			await self.viewModel.fetchNextResults(forQuery: self.query)
		}
	}

	private func handleError(_ error: Error) {
		let alert = UIAlertController(title: "There was an unexpected error", message: error.localizedDescription,
									  preferredStyle: .alert)
		alert.addAction(.init(title: "Ok", style: .default, handler: { _ in alert.dismiss(animated: true )}))
		present(alert, animated: true)
	}
}

extension SearchViewController: SearchViewModelOutput {
	func searchFailed(withError error: Error) {
		DispatchQueue.main.async { [weak self] in
			self?.handleError(error)
		}
	}

	func searchResultsUpdated(_ results: SearchResponse) {
		Task { [weak self] in
			guard let self = self else { return }

			var snapshot = self.dataSource.snapshot()

			// If this is the first time we load, then insert the only section we have
			if snapshot.numberOfSections == 0 {
				snapshot.appendSections([0])
			}

			snapshot.appendItems(results.items)

			self.numberOfRows = snapshot.numberOfItems

			await self.dataSource.apply(snapshot, animatingDifferences: true)

			DispatchQueue.main.async { [weak self] in
				self?.loadingIndicatorView?.stopAnimating()
			}
		}
	}
}

extension SearchViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
						forItemAt indexPath: IndexPath) {
		// Make sure that we are not triggering a re-fetch
		// on first load before any rows has been displayed
		guard numberOfRows != 0 else { return }

		// If we scroll to the last row, then start loading more data
		if indexPath.row == numberOfRows - 1 {
			loadData()
		}
	}
}

//
//  SceneDelegate.swift
//  BooksWithHarry
//
//  Created by Kristian Andersen on 26/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let baseURL = URL(string: "https://api.storytel.net")!
		let client = APIClient(baseURL: baseURL)
		let viewModel = SearchViewModel(service: client)
		let imageLoader = ImageLoader()

		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = SearchViewController(viewModel: viewModel, imageLoader: imageLoader)
		window?.makeKeyAndVisible()
	}
}


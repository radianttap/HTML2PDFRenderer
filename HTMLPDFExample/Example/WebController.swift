//
//  WebController.swift
//  HTMLPDFExample
//
//  Created by Aleksandar Vacić on 14.2.18..
//  Copyright © 2018. Radiant Tap. All rights reserved.
//

import UIKit
import WebKit

final class WebController: UIViewController {
	//	UI

	@IBOutlet private weak var webView: WKWebView!
}


extension WebController {
	override func viewDidLoad() {
		super.viewDidLoad()

		setupNavigationBarButtons()

		setupWebView()
		loadWebPage()
	}
}


private extension WebController {
	func setupWebView() {
		webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
	}

	func loadWebPage() {
		guard
			let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html")
		else { return }

		let accessURL = url.deletingLastPathComponent()
		webView.loadFileURL(url, allowingReadAccessTo: accessURL)
	}

	func setupNavigationBarButtons() {

		let makePDF = UIBarButtonItem(title: NSLocalizedString("Save PDF", comment: "")) {
			[unowned self] _ in
			self.savePDF()
		}

		navigationItem.rightBarButtonItems = [makePDF]
	}

	func savePDF() {

	}
}


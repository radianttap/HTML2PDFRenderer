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
		let fm = FileManager.default
		guard let pdfURL = fm.documentsURL?.appendingPathComponent("order.pdf") else { return }

		if fm.fileExists(atPath: pdfURL.path) {
			do {
				try fm.removeItem(at: pdfURL)
			} catch let fileError {
				let ac = UIAlertController(title: nil, message: fileError.localizedDescription, preferredStyle: .alert)
				ac.addAction( UIAlertAction(title: "OK", style: .default, handler: nil) )
				self.present(ac, animated: true, completion: nil)
				return
			}
		}

		let renderer = HTML2PDFRenderer()
		renderer.render(webView: self.webView, toPDF: pdfURL, paperSize: .a4, paperMargins: UIEdgeInsets.init(top: 30, left: 0, bottom: 0, right: 0)) {
			url, error in

			if let error = error {
				DispatchQueue.main.async {
					let ac = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
					ac.addAction( UIAlertAction(title: "OK", style: .default, handler: nil) )
					self.present(ac, animated: true, completion: nil)
				}
				return
			}

			print("URL: \( url?.path ?? "" )")
			DispatchQueue.main.async {
				let m = NSLocalizedString("PDF generated, at this app's Documents folder.\n\n(Look in the console for full URL)", comment: "")
				let ac = UIAlertController(title: nil, message: m, preferredStyle: .alert)
				ac.addAction( UIAlertAction(title: "OK", style: .default, handler: nil) )
				self.present(ac, animated: true, completion: nil)
			}
		}
	}
}


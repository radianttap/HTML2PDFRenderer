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
	}
}


private extension WebController {
	func setupNavigationBarButtons() {

		
	}
}

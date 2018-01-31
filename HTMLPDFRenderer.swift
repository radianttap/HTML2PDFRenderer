//
//  HTMLPDFRenderer.swift
//  HTMLPDFRenderer
//
//  Copyright © 2015 Aleksandar Vacić, Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit
import WebKit

protocol HTML2PDFRendererDelegate: class {
	func html2pdfRenderer(_ renderer: HTML2PDFRenderer, didCreatePDFAtFileURL url: URL)
	func html2pdfRenderer(_ renderer: HTML2PDFRenderer, didFailedWithError error: Error)
}

final class HTML2PDFRenderer {
	weak var delegate: HTML2PDFRendererDelegate?

	typealias Callback = (URL?, Error?) -> Void

	//

	private var webView: WKWebView?
	private var webLoadingTimer: Timer?
}

private extension HTML2PDFRenderer {
	enum Key: String {
		case paperRect
		case printableRect
	}
}

extension HTML2PDFRenderer {
	///
	func render(htmlURL: URL,
				toPDF pdfURL: URL,
				paperSize: PaperSize,
				fileName: String? = nil,
				delegate: HTML2PDFRendererDelegate? = nil,
				callback: @escaping Callback = {_, _ in})
	{
		guard
			let w = UIApplication.shared.keyWindow,
			let accessURL = FileManager.default.documentsURL
		else { return }

		let view = UIView(frame: w.bounds)
		view.alpha = 0
		w.addSubview(view)

		let webView = WKWebView(frame: view.bounds)
		webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
		view.addSubview(webView)
		self.webView = webView

		if htmlURL.isFileURL {
			webView.loadFileURL(htmlURL, allowingReadAccessTo: accessURL)
		} else {
			let req = URLRequest(url: htmlURL)
			webView.load(req)
		}

		webLoadingTimer = Timer.every(0.5, {
			[weak self] timer in
			guard let `self` = self else { return }

			if self.webView?.isLoading ?? false { return }
			timer.invalidate()

			self.render(webView: webView, toPDF: pdfURL, paperSize: paperSize, delegate: delegate) {
				[weak self] pdfURL, pdfError in
				guard let `self` = self else { return }

				self.webView?.superview?.removeFromSuperview()
				self.webView = nil

				callback(pdfURL, pdfError)
			}
		})

	}

	///	Takes an existing instance of `WKWebView` and prints into paged PDF with specified paper size.
	///
	///	You can supply `delegate` and/or `callback` closure.
	///	Both will be called and given back the file URL where PDF is created or an Error.
	func render(webView: WKWebView,
				toPDF pdfURL: URL,
				paperSize: PaperSize,
				delegate: HTML2PDFRendererDelegate? = nil,
				callback: Callback = {_, _ in})
	{
		let fm = FileManager.default
		if !pdfURL.isFileURL {
			log(level: .warning, "Given PDF path is not file URL")
			return
		}
		if !fm.lookupOrCreate(directoryAt: pdfURL.deletingLastPathComponent()) {
			log(level: .warning, "Can't access PDF's parent folder:\n\( pdfURL.deletingLastPathComponent() )")
			return
		}

		let renderer = UIPrintPageRenderer()
		renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)
		let paperRect = CGRect(x: 0, y: 0, width: paperSize.size.width, height: paperSize.size.height)
		let printableRect = paperRect.insetBy(dx: 0, dy: 20)
		renderer.setValue(paperRect, forKey: Key.paperRect.rawValue)
		renderer.setValue(printableRect, forKey: Key.printableRect.rawValue)

		let pdfData = renderer.makePDF()

		do {
			try pdfData.write(to: pdfURL, options: .atomicWrite)
			log(level: .info, "Generated PDF file at url:\n\( pdfURL.path )")

			delegate?.html2pdfRenderer(self, didCreatePDFAtFileURL: pdfURL)
			callback(pdfURL, nil)

		} catch let error {
			log(level: .error, "Failed to create PDF:\n\( error )")

			delegate?.html2pdfRenderer(self, didFailedWithError: error)
			callback(nil, error)
			return
		}

	}
}

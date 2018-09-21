//
//  HTMLPDFRenderer.swift
//  HTMLPDFRenderer
//
//  Copyright © 2015 Aleksandar Vacić, Radiant Tap
//	https://github.com/radianttap/HTML2PDFRenderer
//
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit
import WebKit

public protocol HTML2PDFRendererDelegate: class {
	func html2pdfRenderer(_ renderer: HTML2PDFRenderer, didCreatePDFAtFileURL url: URL)
	func html2pdfRenderer(_ renderer: HTML2PDFRenderer, didFailedWithError error: Error)
}

///	Uses UIPrintPageRenderer to create PDF file out of HTML web page loaded in WKWebView.
///
/// See `PaperSize` enum for declaration of supported pages. Extend as needed.
public final class HTML2PDFRenderer {
	weak var delegate: HTML2PDFRendererDelegate?

	public typealias Callback = (URL?, Error?) -> Void

	//	Internal

	private var webView: WKWebView?
	private var webLoadingTimer: Timer?
}

private extension HTML2PDFRenderer {
	///	UIPrintPageRenderer attributes are read-only, but they can be set using KVC.
	///	Thus modeling those attributes with this enum.
	enum Key: String {
		case paperRect
		case printableRect
	}
}

extension HTML2PDFRenderer {
	///	Takes the given `htmlURL`, creates hidden `WKWebView`, waits for the web page to load,
	///	then calls the other method below.
	///
	///	Supports both http and file URLs.
	public func render(htmlURL: URL,
				toPDF pdfURL: URL,
				paperSize: PaperSize,
				paperMargins: UIEdgeInsets = .zero,
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
			guard let self = self else { return }

			if self.webView?.isLoading ?? false { return }
			timer.invalidate()

			self.render(webView: webView, toPDF: pdfURL, paperSize: paperSize, delegate: delegate) {
				[weak self] pdfURL, pdfError in
				guard let self = self else { return }

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
	public func render(webView: WKWebView,
				toPDF pdfURL: URL,
				paperSize: PaperSize,
				paperMargins: UIEdgeInsets = .zero,
				delegate: HTML2PDFRendererDelegate? = nil,
				callback: Callback = {_, _ in})
	{
		let fm = FileManager.default
		if !fm.lookupOrCreate(directoryAt: pdfURL.deletingLastPathComponent()) {
			log(level: .warning, "Can't access PDF's parent folder:\n\( pdfURL.deletingLastPathComponent() )")
			return
		}

		let renderer = UIPrintPageRenderer()
		renderer.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0)

		let paperRect = CGRect(x: 0, y: 0, width: paperSize.size.width, height: paperSize.size.height)
		renderer.setValue(paperRect, forKey: Key.paperRect.rawValue)

		var printableRect = paperRect
		printableRect.origin.x += paperMargins.left
		printableRect.origin.y += paperMargins.top
		printableRect.size.width -= (paperMargins.left + paperMargins.right)
		printableRect.size.height -= (paperMargins.top + paperMargins.bottom)
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

# HTMLPDFRenderer

`HTML2PDFRenderer` is rather simple utility class which takes HTML web page loaded in WKWebView and generate (paged) PDF out of it, saved at file URL you give it.

## How to use it

1. Take the following files and add them into your project:
	- HTMLPDFRenderer.swift
	- PDFPaperSize.swift
	- UIPrintPageRenderer-Extensions.swift
2. You also need these helper files, if you don’t already use them on their own:
	- FileManager-Extensions.swift (simplified version from the [one in Swift Essentials](https://github.com/radianttap/Swift-Essentials/blob/master/Foundation/FileManager-Extensions.swift))
	- Log.swift (simplest logging utility)
	- SwiftyTimer.swift (this [micro-library](https://github.com/radex/SwiftyTimer))
3. Now edit `PaperSize.swift` to add custom paper sizes if you need them or use A4 or Letter which are already declared.

See example project (run it in landscape iPhone) how it can be used.

### Cocoapods

I’ve added simple .podspec file but I don’t use this library as CocoaPod, ever. Reasons:

- it’s very simple
- I may need to tweak paper size, per project
- I want to use better log tool then `print`
- I usually use full Swift-Essentials collection of micro-libraries instead of just FileManager

YMMV.

### Swift Package Manager

Add the HTML2PDFRenderer dependency in your Package.swift.

```
dependencies: [
    .package(
        url: "https://github.com/radianttap/HTML2PDFRenderer.git",
        .exact("1.1.0")
    ),
]
```

### Example code

```swift
let fm = FileManager.default
guard let pdfURL = fm.documentsURL?.appendingPathComponent("order.pdf") else { return }

let renderer = HTML2PDFRenderer()
renderer.render(webView: self.webView, toPDF: pdfURL, paperSize: .a4) {
	url, error in

}
```

## Documentation

You can use regular http or https URLs or local file URLs, whatever you need.

`pdfURL` must be file URL, pointing somewhere inside your `Documents` sandbox.

There are two methods:

(1) Supply a reference to existing `WKWebView` instance + file URL where to save the generated PDF.

```swift
func render(webView: WKWebView,
		toPDF pdfURL: URL,
		paperSize: PaperSize,
		paperMargins: UIEdgeInsets = .zero,
		delegate: HTML2PDFRendererDelegate? = nil,
		callback: Callback = {_, _ in})
```

(2) Supply HTML URL you want to load + file URL where to save the generated PDF. In this case, library will create hidden WKWebView, load the given URL, wait until it’s fully loaded and then generate the PDF.

```swift
func render(htmlURL: URL,
		toPDF pdfURL: URL,
		paperSize: PaperSize,
		paperMargins: UIEdgeInsets = .zero,
		delegate: HTML2PDFRendererDelegate? = nil,
		callback: @escaping Callback = {_, _ in})
```


## How it works

This library uses [UIPrintPageRenderer](https://developer.apple.com/documentation/uikit/uiprintpagerenderer) class, thus what you are actually doing is **printing**. 

Hence the PDF will look the same as if you have printed from Safari.

## License

[MIT](https://opensource.org/licenses/MIT), of course.

---

Copyright 2017 Aleksandar Vacić, Radiant Tap

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

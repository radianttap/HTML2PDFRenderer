//
//  PDFPaperSize.swift
//  HTMLPDFRenderer
//
//  Copyright © 2015 Aleksandar Vacić, Radiant Tap
//	https://github.com/radianttap/HTML2PDFRenderer
//
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

extension HTML2PDFRenderer {
	public enum PaperSize {
		case a4
		case letter

		var size: CGSize {
			switch self {
			case .a4:
				return CGSize(width: 595.2, height: 841.8)

			case .letter:
				return CGSize(width: 612, height: 792)

			}
		}
	}
}

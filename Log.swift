//
//  Log.swift
//  Log
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

enum LogLevel {
	case verbose
	case debug
	case info
	case warning
	case error
}

protocol Loggable {
	func log(level: LogLevel, _ message: @autoclosure () -> Any)
}

//	now, we use protocol extension to provide default implementation of the protocol metods
extension HTML2PDFRenderer: Loggable {
	func log(level: LogLevel, _ message: @autoclosure () -> Any) {
	}
}

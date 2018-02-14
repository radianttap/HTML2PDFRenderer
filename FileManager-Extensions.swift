//
//  FileManager-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2016 Radiant Tap
//	https://github.com/radianttap/Swift-Essentials
//
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation


extension FileManager {

	///	Put user data in `Documents/`.
	///	User data generally includes any files you might want to expose to the user—anything you might want the user to create, import, delete or edit.
	var documentsURL : URL? {
		let paths =	urls(for: .documentDirectory, in: .userDomainMask)
		return paths.first
	}
}


extension FileManager {

	func lookupOrCreate(directoryAt url: URL) -> Bool {

		//	must use ObjCBool as the method method expects that. (yikes)
		var isDirectory : ObjCBool = false

		//	check if something exists with the supplied path
		if fileExists(atPath: url.path, isDirectory: &isDirectory) {
			//	if this is directory
			if isDirectory.boolValue {
				//	then all is fine
				return true
			}
			//	otherwise it's a file, so report back that it's NOT ok
			return false
		}

		//	ok, nothing exists at this path, so create this folder
		do {
			//	also create all required folders in between
			try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
		} catch let error {
			print(error)
			return false
		}

		return true
	}
}

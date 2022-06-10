//
//  Model.swift
//  Wordle
//
//  Created by Pedro Muñoz
//

import Foundation
import SwiftUI

enum Status {
	case normal
	case match
	case dontAppear
	case appear
}

enum BannerType {
	case error(String)
	case success
}

struct LetterModel: Hashable {
	let id: String = UUID().uuidString
	let name: String
	var status: Status

	init(_ name: String) {
		self.name = name
		status = .normal
	}

	var backgroundColor: Color {
		switch status {
			case .normal:
				return Color(red: 213.0 / 255, green: 216.0 / 255, blue: 222.0 / 255)
			case .match:
				return Color(red: 109.0 / 255, green: 169.0 / 255, blue: 103.0 / 255)
			case .dontAppear:
				return Color(red: 120.0 / 255, green: 124.0 / 255, blue: 127.0 / 255)
			case .appear:
				return Color(red: 201.0 / 255, green: 180.0 / 255, blue: 87.0 / 255)
		}
	}

	var foregroundColor: Color {
		switch status {
			case .normal:
				return .black
			case .match, .dontAppear, .appear:
				return .white
		}
	}
}

//
//  ViewModel.swift
//  Wordle
//
//  Created by Pedro Muñoz
//

import Foundation
import UIKit

final class ViewModel: ObservableObject {

	let JUEGO_INICIAL: [[LetterModel]] = [
		[.init(""), .init(""), .init(""), .init(""), .init("")],
		[.init(""), .init(""), .init(""), .init(""), .init("")],
		[.init(""), .init(""), .init(""), .init(""), .init("")],
		[.init(""), .init(""), .init(""), .init(""), .init("")],
		[.init(""), .init(""), .init(""), .init(""), .init("")],
		[.init(""), .init(""), .init(""), .init(""), .init("")]
	]

	let KEYBOARDDATA_INICIAL: [LetterModel] = [
		.init("Q"), .init("W"), .init("E"), .init("R"), .init("T"), .init("Y"),
		.init("U"), .init("I"), .init("O"), .init("P"), .init("A"), .init("S"),
		.init("D"), .init("F"), .init("G"), .init("H"), .init("J"), .init("K"),
		.init("L"), .init("Ñ"), .init("✔️"), .init(""), .init("Z"), .init("X"),
		.init("C"), .init("V"), .init("B"), .init("N"), .init("M"), .init("🔙")
	]

	var PALABRAS: [String] = []
	var keyboardData: [LetterModel] = []
	var numOfRow: Int = 0
	@Published var gameOver: Bool = false
	@Published var bannerType: BannerType? = nil
	@Published var word: [LetterModel] = []
	@Published var palabra_correcta: String = ""
	@Published var game: [[LetterModel]] = []

	init() {
		PALABRAS = loadFile("palabras.json")
		palabra_correcta = PALABRAS.randomElement()!.uppercased()
		game = JUEGO_INICIAL
		keyboardData = KEYBOARDDATA_INICIAL

		print("Iniciando juego")
		print("Palabra: \"\(palabra_correcta)\"")
	}

	func replay() {
		numOfRow = 0
		gameOver = false
		bannerType = nil
		word = []
		palabra_correcta = PALABRAS.randomElement()!.uppercased()
		game = JUEGO_INICIAL
		keyboardData = KEYBOARDDATA_INICIAL

		print("Reiniciando juego")
		print("Palabra: \"\(palabra_correcta)\"")
	}

	func addNewLetter(letterModel: LetterModel) {
		bannerType = nil

		if letterModel.name == "✔️" {
			tapOnSend()
			return
		}

		if letterModel.name == "🔙" {
			tapOnRemove()
			return
		}

		if word.count < 5 {
			let letter = LetterModel(letterModel.name)
			word.append(letter)
			game[numOfRow][word.count - 1] = letter
		}
	}

	private func tapOnSend() {
		guard word.count == 5 else {
			print("Añade mas letras!")
			bannerType = .error("Añade mas letras!")
			return
		}

		let finalStringWord = word.map { $0.name }.joined()
		print("Palabra escrita: \"\(finalStringWord)\"")

		if wordIsReal(word: finalStringWord) {
			print("Palabra correcta!")

			for (i, _) in word.enumerated() {
				let currentCharacter = word[i].name
				var status: Status

				if palabra_correcta.contains(where: { String($0) == currentCharacter }) {
					status = .appear
					print("Si hay una \(currentCharacter)")

					if currentCharacter == String(palabra_correcta[palabra_correcta.index(palabra_correcta.startIndex, offsetBy: i)]) {
						status = .match
						print("Y esta en esta posicion (verde)")
					} else {
						print("Pero no en esta posicion (amarillo)")
					}
				} else {
					status = .dontAppear
					print("No hay una \(currentCharacter) (gris)")
				}

				// Update GameView
				var updateGameBoardCell = game[numOfRow][i]
				updateGameBoardCell.status = status
				game[numOfRow][i] = updateGameBoardCell

				let indexToUpdate = keyboardData.firstIndex(where: { $0.name == currentCharacter })
				var keyboardKey = keyboardData[indexToUpdate!]

				if keyboardKey.status != .match {
					keyboardKey.status = status
					keyboardData[indexToUpdate!] = keyboardKey
				}
			}

			let isUserWinner = game[numOfRow].reduce(0) { partialResult, letterModel in
				if letterModel.status == .match {
					return partialResult + 1
				}
				return 0
			}

			if isUserWinner == 5 {
				bannerType = .success
				gameOver = true
				print("Palabra encontrada")
			} else {
				// Clean word and move to the next row
				word = []
				numOfRow += 1

				if numOfRow == 6 {
					print("Perdiste")
					bannerType = .error("La palabra era \(palabra_correcta)")
					gameOver = true
				}
			}
		} else {
			print("La \(finalStringWord) palabra no existe")
			bannerType = .error("La palabra \(finalStringWord) no existe!")
		}
	}

	private func tapOnRemove() {
		guard word.count > 0 else {
			return
		}
		game[numOfRow][word.count - 1] = .init("")
		word.removeLast()
	}

	private func wordIsReal(word: String) -> Bool {
		UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word)
	}

	func hasError(index: Int) -> Bool {
		guard let bannerType = bannerType else {
			return false
		}

		switch bannerType {
			case .error(_):
				return index == numOfRow
			case .success:
				return false
		}
	}

	private func loadFile<T: Decodable>(_ filename: String) -> T {
		let data: Data
		guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
			fatalError("No se encontro \(filename)")
		}
		do {
			data = try Data(contentsOf: file)
		} catch {
			fatalError("Error al cargar \(filename):\n\(error)")
		}
		do {
			let decoder = JSONDecoder()
			return try decoder.decode(T.self, from: data)
		} catch {
			fatalError("Error al convertir \(filename): \(T.self):\n\(error)")
		}
	}
}

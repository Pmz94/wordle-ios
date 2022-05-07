//
//  ContentView.swift
//  Wordle
//
//  Created by Csweb on 27/04/22.
//

import SwiftUI

struct ContentView: View {
	@StateObject var viewModel = ViewModel()

	var body: some View {
		ZStack {
			VStack(spacing: 30) {
				GameView(viewModel: viewModel)
				KeyboardView(viewModel: viewModel)
			}
			if viewModel.bannerType != nil {
				BannerView(bannerType: viewModel.bannerType!)
			}
		}.alert(isPresented: $viewModel.gameOver) {
			Alert(
				title: Text("Juego terminado"),
				message: Text("Juege otra vez!"),
				dismissButton: .default(
					Text("Esta bien"),
					action: viewModel.replay
				)
			)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

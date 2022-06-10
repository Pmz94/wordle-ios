//
//  MainView.swift
//  Wordle
//
//  Created by Pedro Muñoz
//

import SwiftUI

struct MainView: View {
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
		MainView()
	}
}

//
//  MainView.swift
//  Wordle
//
//  Created by Pedro Muñoz
//

import SwiftUI

struct MainView: View {
	@StateObject var vm = ViewModel()

	var body: some View {
		ZStack {
			VStack(spacing: 30) {
				GameView(viewModel: vm)
				KeyboardView(viewModel: vm)
			}

			if vm.bannerType != nil {
				BannerView(bannerType: vm.bannerType!)
			}
		}.alert(isPresented: $vm.gameOver) {
			Alert(
				title: Text("Juego terminado"),
				message: Text("Juege otra vez!"),
				dismissButton: .default(
					Text("Esta bien"),
					action: vm.replay
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

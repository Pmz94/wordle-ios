//
//  BannerView.swift
//  Wordle
//
//  Created by Csweb on 27/04/22.
//

import Foundation
import SwiftUI

struct BannerView: View {
	private let bannerType: BannerType

	@State private var isOnScreen: Bool = false

	init(bannerType: BannerType) {
		self.bannerType = bannerType
	}

	var body: some View {
		VStack {
			Spacer()
			switch bannerType {
				case .error(let errorMessage):
					Text(errorMessage)
						.foregroundColor(.white)
						.padding()
						.background(.red)
						.cornerRadius(12)
				case .success:
					Text("¡HAS GANADO!")
						.foregroundColor(.white)
						.padding()
						.background(.green)
						.cornerRadius(12)
			}
			Spacer()
		}.padding(.horizontal, 12)
		 .frame(height: 40)
		 .animation(.easeInOut(duration: 0.3), value: isOnScreen)
		 .offset(y: isOnScreen ? -250 : -400)
		 .onAppear {
			 isOnScreen = true
		 }
	}
}

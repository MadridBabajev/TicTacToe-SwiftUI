//
//  AppBackground.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 29.12.2022.
//

import Foundation
import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient   (colors:[Color("LightRed"), .white]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
    }
}

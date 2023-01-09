//
//  AppMainButton.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 30.12.2022.
//

import Foundation
import SwiftUI

struct AppMainButton: View {
    var buttonName: String
    
    var body: some View {
        Text(buttonName).bold()
            .font(.title3)
            .frame(width: 170, height: 60)
            .background(Color("LightBlue"))
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}

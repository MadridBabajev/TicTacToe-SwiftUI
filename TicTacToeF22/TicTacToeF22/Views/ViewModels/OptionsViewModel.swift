//
//  OptionsViewModel.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 30.12.2022.
//

import Foundation

final class OptionsViewModel: ObservableObject {
    @Published var selectedVsPlayer = true
    @Published var aiDifficulty = 0.0
}

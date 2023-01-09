//
//  Alerts.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 03.01.2023.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text = Text("")
    var buttonTitle: Text = Text("")
}

struct AlertContext {
    static let player1Win = AlertItem(title: Text("Player 1 wins!"))
                            // buttonTitle: Text("Rematch!"))
    static let player2Win = AlertItem(title: Text("Player 2 wins"))
                            // buttonTitle: Text("Rematch!"))
    static let aiWin = AlertItem(title: Text("You lost!"))
                            // buttonTitle: Text("Rematch!"))
    static let draw = AlertItem(title: Text("It's a draw!"))
                            // buttonTitle: Text("Try again"))
}

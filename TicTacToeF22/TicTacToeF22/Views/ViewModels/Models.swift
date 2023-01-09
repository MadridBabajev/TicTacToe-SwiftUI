//
//  Models.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 04.01.2023.
//

import Foundation

enum EPlayer: String, Codable {
    case player1
    case player2
    case ai
}

struct Move: Codable {
    let player: EPlayer
    let boardIndex: Int
    
    var indicator: String {
        return player == .player1 ? "xmark" : "circle"
    }
    
    enum CodingKeys: String, CodingKey {
        case player
        case boardIndex
    }
    
    init(player: EPlayer, boardIndex: Int) {
        self.player = player
        self.boardIndex = boardIndex
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.player = try container.decode(EPlayer.self, forKey: .player)
        self.boardIndex = try container.decode(Int.self, forKey: .boardIndex)
    }
}

//struct CodableMoves: Codable {
//    
//    var codableMoves: [Move?]
//
//    enum CodingKeys: String, CodingKey {
//        case moves
//    }
//
//    init(codableMoves: [Move?]) {
//        self.codableMoves = codableMoves
//    }
//
//    init(from decoder:Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.codableMoves = try container.decode([Move?].self, forKey: .moves)
//    }
//}

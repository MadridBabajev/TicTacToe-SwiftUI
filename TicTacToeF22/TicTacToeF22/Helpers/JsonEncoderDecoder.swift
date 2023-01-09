//
//  JsonEncoderDecoder.swift
//  TicTacToeF22
//
//  Created by Marta Ossipova on 05.01.2023.
//

import Foundation

func encodeGameState(moves: [Move?]) -> Data? {
    
    let dictionary: [String:[Move?]] = [
        "moves" : moves 
    ]
    let jsonEncoder = JSONEncoder()
    
    let jsonData = try? jsonEncoder.encode(dictionary)
    
    return jsonData
}

func decodeGameState(jsonData: Data) -> [Move?]? {
    
    // Setup values
    let jsonString = String(data: jsonData, encoding: .utf8) // - to get the string
    
    let elementsStringPartialFormat: String = (jsonString?.components(separatedBy: "[")[1])!
    let elementsStringValidFormat: String = elementsStringPartialFormat.components(separatedBy: "]")[0]
    
    // print("====\n\(String(describing: elementsStringValidFormat))\n====")
    
    var retList: [Move?] = []
    var currentPlayer: EPlayer = .player1
    
    // Recreate the array
    for element in elementsStringValidFormat.components(separatedBy: ",") {
        // print(element)
        if element == "null" {
            retList.append(nil)
            continue
        }
        
        if element.contains("{") {
            currentPlayer = retrievePlayerFromString(element)
            continue
        } else {
            let currentBoardPosition = retrieveBoardPositionFromString(element)
            let move = Move(player: currentPlayer, boardIndex: currentBoardPosition)
            retList.append(move)
            currentPlayer = .player1
        }
    }
    // Decoding like that does not work
//    let decoder = JSONDecoder()
//    if let obj = try? decoder.decode([Move?].self, from: jsonData) {
//        return obj
//    }

    return retList
}

func retrievePlayerFromString(_ playerString: String) -> EPlayer {
    let playerStr = (playerString.components(separatedBy: ":")[1]).replacingOccurrences(of: #"""#, with: "")
    
    switch playerStr {
    case "player1":
        return .player1
    case "player2":
        return .player2
    case "ai":
        return .ai
    default:
        return .player1
    }
}

func retrieveBoardPositionFromString(_ boardPositionString: String) -> Int {
    let boardPosStr = (boardPositionString.components(separatedBy: ":")[1])
        .replacingOccurrences(of: #"}"#, with: "")
    return Int(boardPosStr)!
}

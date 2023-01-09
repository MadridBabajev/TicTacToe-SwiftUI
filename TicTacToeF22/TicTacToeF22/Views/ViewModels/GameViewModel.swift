//
//  GameViewModel.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 30.12.2022.
//

import Foundation
import SwiftUI
import CoreData

final class GameViewModel: ObservableObject {
    
    @Published var options = OptionsViewModel()
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isPlayer1Turn = true
    @Published var isBoardDisabled = false
    @Published var gameWonBy: EPlayer? = nil
    @Published var alertItem: AlertItem?
    
    private let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) {return}
        
        let player2Tapped: EPlayer = options.selectedVsPlayer ?
            .player2 : .ai
        
        // Player win
        moves[position] = Move(player: isPlayer1Turn ? .player1 : player2Tapped,
                               boardIndex: position)
        
        // Check for Player conditions
        if checkWinCondition(for: isPlayer1Turn ? .player1 : player2Tapped, in: moves)
            { return }
        if checkForDraw(in: moves) {
            setAlertItem()
            return
        }
        
        // 2 Player game? then switch
        if (options.selectedVsPlayer) {
            isPlayer1Turn.toggle()
            return
        }
        
        isBoardDisabled = true
        DispatchQueue.main.asyncAfter(deadline:
                .now() + 0.6) {[self] in
                    
                    // Ai move
                    let aiPosition = determineAiMovePosition(in: moves)
                    moves[aiPosition] = Move(player: .ai, boardIndex: aiPosition)
                    
                    // Check for Ai conditions
                    if checkWinCondition(for: .ai, in: moves)
                        { return }
                    if checkForDraw(in: moves) {
                        setAlertItem()
                        return
                    }
                    
                    isBoardDisabled = false
                }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineAiMovePosition(in moves: [Move?]) -> Int {
        
        // If Ai can win && difficulty Hard, then win
        if (options.aiDifficulty >= 1.9) {
            let aiWinMove = getPlayerWinMove(for: .ai)
            if aiWinMove != -1 {
                return aiWinMove
            }
        }
        
        // If Ai can't win && difficulty Medium, then block or middle
        if (options.aiDifficulty >= 0.9) {
            let humanWinMove = getPlayerWinMove(for: .player1)
            if humanWinMove != -1 {
                return humanWinMove
            }
            // If middle square is available, take the middle
            let centerSquare = 4
            if !isSquareOccupied(in: moves, forIndex: 4) { return centerSquare }
        }
        
        // else, Random move
        var moveTo = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: moveTo) {
            moveTo = Int.random(in: 0..<9)
        }
        return moveTo
    }
    
    func getPlayerWinMove(for player: EPlayer) -> Int {
        let playerMoves = moves.compactMap { $0 }.filter{ $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let playerWinPositions = pattern.subtracting(playerPositions)
            
            if playerWinPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: playerWinPositions.first!)
                    { return playerWinPositions.first! }
            }
        }
        return -1
    }
    
    func checkWinCondition(for player: EPlayer, in moves: [Move?]) -> Bool {

        let playerMoves = moves.compactMap{$0}.filter{$0.player == player}
        let playerPositions = Set(playerMoves.map{$0.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            gameWonBy = player
            isBoardDisabled = true
            setAlertItem()
            return true
        }
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool
        { moves.compactMap{$0}.count == 9 }
    
    func resetGame() {
        isBoardDisabled = false
        gameWonBy = nil
        isPlayer1Turn = true
        moves = Array(repeating: nil, count: 9)
    }
    
    func setAlertItem() {
        switch gameWonBy {
        case .ai:
            alertItem = AlertContext.aiWin
            
        case .player1:
            alertItem = AlertContext.player1Win
            
        case .player2:
            alertItem = AlertContext.player2Win
        case nil:
            alertItem = AlertContext.draw
        }
    }
    
    func processDBChangesAfterMove(currentGame: Game, context: NSManagedObjectContext) {
        
        // TODO: Serialize state
        let stateData: Data = encodeGameState(moves: moves)!

        // Save board & game state
        DataController().addState(
            state: stateData,
            isMainPlayerMove: isPlayer1Turn,
            game: currentGame,
            context:context
        )
        
        DataController().editGame(
            updateGame: currentGame,
            wonBy: gameWonBy,
            context: context
        )
    }
    
    func processDBChangesAfterReset(currentGame: Game, context: NSManagedObjectContext) {
        let gameStates: any Sequence =  currentGame.game_states!
        for gameState in gameStates {
            context.delete(gameState as! GameState)
        }
        
        DataController().editGame(
            updateGame: currentGame,
            wonBy: gameWonBy,
            context: context
        )
    }
    
    func processDBChangesAfterOneMoveBack(currentGame: Game, context: NSManagedObjectContext) {
        print("One Move Back")
        if currentGame.game_states?.count ?? -1 > 0 {
            // print("\n\(String(describing: Int(currentGame.game_states!.count)))")
            
            var states = (currentGame.game_states! as! Set<GameState>)
                .sorted(by: { $0.created_at! > $1.created_at! })
            
            context.delete(states.first! as NSManagedObject)

            DataController().save(context: context)
            
            if currentGame.game_states?.count ?? 0 == 0 {
                resetGame()
                return
            }
            
            // let lastStateObj: GameState = currentGame.game_states?.allObjects.first as! GameState
            states = (currentGame.game_states! as! Set<GameState>)
                .sorted(by: { $0.created_at! > $1.created_at! })
            
            let lastStateObj: GameState = states.first!
            let lastState = decodeGameState(jsonData: lastStateObj.state_data!)!
            isPlayer1Turn = lastStateObj.is_main_player_turn == 1 ? true : false
            
            moves = lastState
        }
    }
}

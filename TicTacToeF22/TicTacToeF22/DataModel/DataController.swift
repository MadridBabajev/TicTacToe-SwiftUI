//
//  DataController.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 07.01.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    static let container = NSPersistentContainer(name: "GameModel")
    
    init() {
        DataController.container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data from the database: \(error)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Successfully added new data!")
        } catch {
            print("Failed to save new data..")
        }
    }
    
    func addGame(gameId: UUID, type gameType: Int16, difficulty aiDifficulty: Float, context: NSManagedObjectContext) {
        let game = Game(context: context)
        
        game.game_id = gameId
        game.created_at = Date()
        game.game_type = gameType
        game.ai_difficulty = aiDifficulty
        
        save(context: context)
    }
    
    func addState(state stateData: Data, isMainPlayerMove: Bool, game: Game, context: NSManagedObjectContext) {
        let state = GameState(context: context)
        
        state.state_id = UUID()
        state.state_data = stateData
        state.is_main_player_turn = isMainPlayerMove ? 1 : 0
        state.game_fk = game
        state.created_at = Date()
        
        save(context: context)
    }
    
    func editGame(updateGame game: Game, wonBy: EPlayer?, context: NSManagedObjectContext) {
        game.created_at = Date()
        game.game_won_by = wonBy != nil ? wonBy!.rawValue : nil
        
        save(context: context)
    }
    
}

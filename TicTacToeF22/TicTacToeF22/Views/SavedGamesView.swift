//
//  SavedGamesView.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 29.12.2022.
//

import SwiftUI

struct SavedGamesView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.created_at, order: .reverse)])
        var games: FetchedResults<Game>
    
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                List {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailsView(game: game), label: { SavedGameCell(game: game) })
                    }.onDelete(perform: deleteGame)
                }
                .listStyle(.plain)
                .padding(.top, 10)
            }
        }.navigationTitle("Played games")
    }
    
    private func deleteGame(offsets: IndexSet) {
        withAnimation {
            offsets.map { games[$0] }
                .forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
}

struct SavedGameCell: View {
    
    var game: Game
    
    var body: some View {
        HStack {
            VStack {
                let gameTypeTitle = game.game_type == 1 ?
                "Player vs Player" : "Player vs AI"
                Text(gameTypeTitle)
                    .fontWeight(.semibold)
                    .font(.title3)
                
                let playerWon = getPlayerWon(game)
                Text(playerWon)
                    .font(.system(size: 20))
                    .foregroundColor(.green)
                    .padding()
                
                Text("Last played: \(calcTimeSince(date:game.created_at!))")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .italic()
            }
            
            Spacer()
            
            GameLastBoardState(game: game)
        }
    }
    
    func getPlayerWon(_ game: Game) -> String {
        
        let generalPrefix = "Game won by "
        
        switch game.game_won_by {
            case "player1":
                return generalPrefix + "Player 1"
            case "player2":
                return generalPrefix + "Player 2"
            case "AI":
                return generalPrefix + "AI"
            default:
                return "Game unfinished"
        }
    }
}

struct GameLastBoardState: View {
    
    var game: Game
    
    var body: some View {
        Text("Details")
    }
}

struct SavedGamesView_Previews: PreviewProvider {
    
    static var previews: some View {
        SavedGamesView()
    }
}

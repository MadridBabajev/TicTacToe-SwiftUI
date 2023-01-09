//
//  GameView.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 29.12.2022.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameVm: GameViewModel
    
    
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                GameHub(gameVm: gameVm)
                GameBoardView(gameVm: gameVm)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct GameBoardView: View {
    
    @StateObject var gameVm: GameViewModel
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment (\.newGameId) var gameId: UUID
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.created_at, order: .reverse)])
        var games: FetchedResults<Game>
        
    var body: some View {
        
        // Find current game in the DB
//        let currentGame: Game = games.first(
//            where: { $0.game_id == gameId })!
        
        let currentGame: Game = games.first!
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: gameVm.columns, spacing: 10) {
                    ForEach(0..<9) { position in
                        ZStack {
                            GameSquareView(proxy: geometry)
                            PlayerMoveIndicator(systemImageName: gameVm.moves[position]?.indicator ?? "")
                        }.onTapGesture {
                            gameVm.processPlayerMove(
                                for: position)
                            gameVm.processDBChangesAfterMove(
                                currentGame: currentGame,
                                context: managedObjContext)
                        }
                    }
                    Spacer()
                }
                .disabled(gameVm.isBoardDisabled)
                .padding()
                .alert(item: $gameVm.alertItem, content: { (alertItem: AlertItem) in Alert(title: alertItem.title) })
            }
        }
    }
}

struct GameHub: View {
    
    @StateObject var gameVm: GameViewModel
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.created_at, order: .reverse)])
        var games: FetchedResults<Game>
    
    var body: some View {
        VStack {
            let titlePrefix = "Playing against the"
            
            gameVm.options.selectedVsPlayer ?
            GameTitle(gameTitle: "\(titlePrefix) player")
            : GameTitle(gameTitle: "\(titlePrefix) AI")
            
            let currentTurnString =
            "Currently is \(gameVm.isPlayer1Turn ? "Cross's" : "Circle's") move"
            gameVm.options.selectedVsPlayer ?
                CurrentMoveView(currentMoveString: currentTurnString) : nil
            Spacer()
            
            ActionButtons(gameVm: gameVm)
        }
    }
}

struct GameTitle: View {
    
    var gameTitle: String
    
    var body: some View {
        Text(gameTitle)
            .font(.title)
            .bold()
            .opacity(0.7)
            .padding(.top, 50)
    }
}

struct CurrentMoveView: View {
    
    var currentMoveString: String
    
    var body: some View {
        Text(currentMoveString)
            .font(.title3)
            .opacity(0.9)
            .padding()
    }
}

struct ActionButtons: View {
    
    @StateObject var gameVm: GameViewModel
    @Environment (\.newGameId) var gameId: UUID
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.created_at, order: .reverse)])
        var games: FetchedResults<Game>
    
    var body: some View {
        
        // Find current game in the DB
        
        // try finding game by id
//        let currentGame: Game = games.first(
//            where: { $0.game_id == gameId })!
        
        // IDs
//        Text(gameId.uuidString).foregroundColor(.red).font(.system(size: 12))
//        ForEach(games) { game in
//            Text(game.game_id!.uuidString).font(.system(size: 12))
//        }
//        Text(currentGame.game_id!.uuidString).foregroundColor(.blue).font(.system(size: 12))
        
        // simply picks the most recent game
        let currentGame: Game = games.first!
        
        HStack {
            
            // Navigate back to home
            Spacer()
            NavigationLink(destination: HomeView(),
                label: { HubButton(systemImg: "house")
            })
            
            // One turn back, displayed if 2 player game
            !gameVm.options.selectedVsPlayer || gameVm.gameWonBy != nil ?
            nil : HubButton(systemImg: "arrow.counterclockwise").onTapGesture {
                
                gameVm.processDBChangesAfterOneMoveBack(
                    currentGame: currentGame,
                    context: managedObjContext
                )
                
            }
            
            // Reset game
            HubButton(systemImg: "arrow.2.circlepath").onTapGesture {
                
                gameVm.resetGame()
                
                gameVm.processDBChangesAfterReset(
                    currentGame: currentGame,
                    context: managedObjContext
                )
                
            }
            Spacer()
        }.padding()
    }
}

struct HubButton: View {
    
    var systemImg: String
    
    var body: some View {
        Text(Image(systemName: systemImg))
            .bold()
            .font(.system(size: 40))
            .foregroundColor(.white)
            .frame(width: 100, height: 80)
            .background(Color("DarkerGrayForGameButtons"))
            .cornerRadius(20)
            .padding(.horizontal, 5)
    }
}

struct GameSquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle().foregroundColor(Color("LightBlue").opacity(0.75)).frame(width: proxy.size.width / 3 - 15)
    }
}

struct PlayerMoveIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameVm: GameViewModel())
    }
}

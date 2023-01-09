//
//  GameDetailsView.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 04.01.2023.
//

import SwiftUI

struct GameDetailsView: View {
    
    var game: Game
    
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                GeneralDetails(game: game)
                    .frame(width: 325, height: 200)
                    .background(.white)
                    .cornerRadius(15)
                    .padding(2)
                    .background(.black)
                    .cornerRadius(15)
                
                GameStates(game: game)
            }
        }
    }
}

struct GeneralDetails: View {
    
    var game: Game
    
    var body: some View {
        
        let difficultyParams = getGameDifficultyStringAndColor(game: game)
        
        HStack {
            
            VStack(spacing: 25) {
                GeneralDetailsTitle(headline: "Last update on:")
                GeneralDetailsTitle(headline: "Game winner:")
                GeneralDetailsTitle(headline: "Game Type:")
                difficultyParams == nil ? nil :
                    GeneralDetailsTitle(headline: "AI difficulty:")
            }.padding()
            
            Spacer()
            
            VStack(spacing: 25) {
                // Last updated
                let updatedDate: String = game.created_at!.formatted()
                GeneralDetailsSubtitle(headline: "\(updatedDate)").minimumScaleFactor(0.5)
                
                // Won by
                let winnerString = getGameWonByString(wonByStr: game.game_won_by)
                GeneralDetailsSubtitle(headline: "\(winnerString)")
                
                // Type
                let gameType = getGameTypeString(type: game.game_type)
                    GeneralDetailsSubtitle(headline: "\(gameType)")
                
                // Difficulty if vsAi
                difficultyParams == nil ? nil :
                    GeneralDetailsTitle(headline: difficultyParams!.title)
                        .foregroundColor(difficultyParams!.color)
            }.padding()
        }
    }
    
    func getGameWonByString(wonByStr: String?) -> String {
        
        switch wonByStr {
            case "player1":
                return "Player 1"
            case "player2":
                return "Player 2"
            case "ai":
                return "AI"
            default:
                return "No winner"
        }
    }
    
    func getGameTypeString(type: Int16) -> String {
        switch type {
            case 0:
                return "Player VS AI"
            case 1:
                return "Player VS Player"
            default:
                return "none"
        }
    }
    
    func getGameDifficultyStringAndColor(game: Game) -> DifficultyParams? {
        
        if game.game_type == 1 { return nil }
        
        switch game.ai_difficulty {
        case 0.0:
            return DifficultyParams(title: "Easy", color: .green)
        case 1.0:
            return DifficultyParams(title: "Medium", color: .yellow)
        case 2.0:
            return DifficultyParams(title: "Hard", color: .red)
        default:
            return nil
        }
    }
    
    class DifficultyParams {
        let title: String
        let color: Color
        
        init(title: String, color: Color) {
            self.title = title
            self.color = color
        }
    }
    
}

struct GeneralDetailsTitle: View {
    var headline: String
    
    var body: some View {
        Text(headline).font(.system(size: 16)).bold()
    }
}

struct GeneralDetailsSubtitle: View {
    var headline: String
    
    var body: some View {
        Text(headline).font(.system(size: 16)).bold().foregroundColor(.gray).italic()
    }
}

struct GameStates: View {
    
    var game: Game
    
    var body: some View {
        
        VStack {
            Text("Game States").font(.title2).opacity(0.8)
            Divider()
            
            if (game.game_states?.count == 0) {
                Text("Game has no states..")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(.red)
            } else {
                // let states = game.game_states! as! Set<GameState>
                let states = (game.game_states! as! Set<GameState>)
                    .sorted(by: { $0.created_at! > $1.created_at! })
                List {
                    ForEach(Array(states as [GameState]), id: \.self) { state in
                        let lastState = decodeGameState(jsonData: state.state_data!)!
                        StateView(board: lastState)
                        // Divider()
                    }.frame(height: 240)
                }.listStyle(.plain)
                    .padding(.vertical, 5)
                
            }
        }
    }
}

struct StateView: View {
 
    var board: [Move?]
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
        
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<9) { position in
                        ZStack {
                            StateSquareView(proxy: geometry)
                            StateMoveIndicator(systemImageName: board[position]?.indicator ?? "")
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct StateSquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Circle().foregroundColor(Color("StateLightBlue").opacity(0.75)).frame(width: proxy.size.width / 5 - 5)
    }
}

struct StateMoveIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.white)
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameDetailsView(game: Game())
    }
}

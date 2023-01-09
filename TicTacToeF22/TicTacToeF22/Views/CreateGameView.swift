//
//  CreateGameView.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 29.12.2022.
//

import SwiftUI

struct CreateGameView: View {
    
    @StateObject var gameViewModel = GameViewModel()
    @Environment (\.managedObjectContext) var managedObjContext
    
    var body: some View {
        ZStack {
            AppBackground()
            VStack {
                GameTypeSelector(selectedVsPlayer: $gameViewModel.options.selectedVsPlayer).position(x: 200, y: 250)
                
                !gameViewModel.options.selectedVsPlayer ? GameDifficultySelector(aiDifficulty: $gameViewModel.options.aiDifficulty).position(x: 200, y: 100) : nil
                
                let newGameId = UUID()
                
                NavigationLink(destination: GameView(
                    gameVm: gameViewModel).environment(\.newGameId,newGameId),
                    label: { AppMainButton(buttonName: "Start Game")
                }).simultaneousGesture(TapGesture().onEnded{
                    DataController().addGame(
                        gameId: newGameId,
                        type: gameViewModel.options.selectedVsPlayer ? 1 : 0,
                        difficulty: Float(gameViewModel.options.aiDifficulty),
                        context: managedObjContext)
                })
            }
        }
    }
}

struct GameTypeSelector: View {
    
    @Binding var selectedVsPlayer: Bool
    
    var body: some View {
        VStack{
            OptionsTitle(title: "Game Type")
            HStack {
                if (selectedVsPlayer) {
                    ChooseGameTypeButton(playerButtonType: "VS Player")
                        .background(.green).padding(5).scaleEffect(1.1)
                    ChooseGameTypeButton(playerButtonType: "VS AI").onTapGesture {
                        withAnimation(.easeOut(duration: 0.25)) {
                            selectedVsPlayer.toggle()
                        }
                    }
                } else {
                    ChooseGameTypeButton(playerButtonType: "VS Player").onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedVsPlayer.toggle()
                        }
                    }
                    ChooseGameTypeButton(playerButtonType: "VS AI")
                        .background(.green).padding(5).scaleEffect(1.1)
                }
            }
        }
    }
}

struct GameDifficultySelector: View {
    
    @Binding var aiDifficulty: Double
    
    var body: some View {
        VStack{
            OptionsTitle(title: "AI Difficulty")
            Slider(value: $aiDifficulty, in: 0...2, step: 1)
                .padding(.horizontal, 40)
            DifficultySpecifiers()
        }
    }
}

struct ChooseGameTypeButton: View {
    var playerButtonType: String
    
    var body: some View {
        Text(playerButtonType).font(.title3)
            .foregroundColor(.black)
            .frame(width: 150, height: 60)
            .background(.white)
            .cornerRadius(20)
    }
}

struct DifficultySpecifiers: View {
    
    var body: some View {
        HStack {
            DifficultySpecifier(difficultyName: "Easy",
                                difficultyColor: .green).padding(.horizontal, 50)
            Spacer()
            DifficultySpecifier(difficultyName: "Medium",
                                difficultyColor: .yellow)
            Spacer()
            DifficultySpecifier(difficultyName: "Hard",
                                difficultyColor: .red).padding(.horizontal, 50)
        }
    }
}

struct DifficultySpecifier: View {
    var difficultyName: String
    var difficultyColor: Color
    
    var body: some View {
        Text(difficultyName)
            .foregroundColor(difficultyColor)
            .frame(width: 80, height: 40)
            .background(.white)
            .cornerRadius(20)
    }
}

struct OptionsTitle: View {
    var title: String
    
    var body: some View {
        Text(title).bold().font(.title2)
            .foregroundColor(.black).padding(20)
    }
}

struct CreateGameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGameView(
            gameViewModel: GameViewModel())
    }
}


struct NewGameIdKey: EnvironmentKey {
    static let defaultValue: UUID = UUID()
}

extension EnvironmentValues {
    var newGameId: UUID {
        get {
            self[NewGameIdKey.self]
        }
        set {
            self[NewGameIdKey.self] = newValue
        }
    }
}

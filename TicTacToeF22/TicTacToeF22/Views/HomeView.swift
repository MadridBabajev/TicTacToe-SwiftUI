//
//  ContentView.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 25.12.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView() {
            ZStack{
                AppBackground().navigationTitle("Home")
                VStack {
                    HomeViewTitle().padding(.bottom, 60)
                    
                    NavigationLink (destination: CreateGameView(),
                                    label: { AppMainButton(buttonName: "New Game")}).padding()
                    
                    NavigationLink (destination: SavedGamesView(),
                                    label: { AppMainButton(buttonName: "Played Games")})
                }
            }
        }
        .accentColor(.black)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear() {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
    }

struct HomeViewTitle: View {
    var body: some View {
        VStack{
            Text("Welcome to my TicTacToe App :)").font(.title).lineSpacing(10).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
        HomeView()
    }
}

}

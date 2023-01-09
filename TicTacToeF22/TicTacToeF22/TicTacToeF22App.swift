//
//  TicTacToeF22App.swift
//  TicTacToeF22
//
//  Created by Marta  Ossipova on 25.12.2022.
//

import SwiftUI

@main
struct TicTacToeF22App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, DataController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}


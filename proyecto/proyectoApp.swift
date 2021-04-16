//
//  proyectoApp.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import Foundation
import SwiftUI

@main
struct proyectoApp : App{
    @StateObject var userAuth = UserAuth()
    var body: some Scene{
        WindowGroup{
            if userAuth.isAuthorized {
                MainView(userAuth: userAuth)
            } else {
                LoginView(userAuth: userAuth)
            }
        }
    }
}
   	

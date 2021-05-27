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
    @StateObject var userRepository: UserRepository = UserRepository()
    var body: some Scene{
        WindowGroup{
            if userRepository.isAuthorized {
                MainView().environmentObject(userRepository)
            } else {
                LoginView().environmentObject(userRepository)
            }
        }
    }
}
   	

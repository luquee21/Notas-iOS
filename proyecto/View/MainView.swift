//
//  MainView.swift
//  proyecto
//
//  Created by macOS on 24/3/21.
//

import SwiftUI

struct MainView: View {
    @State private var selected: tabs = .mynotes
    @EnvironmentObject var userRepository: UserRepository
    let picker = ImagePicker()
    enum tabs {
        case mynotes
        case sharednotes
        case profile
    }
    
    var body: some View {
        TabView(selection: $selected){
            ListMyNotesView(picker: picker).environmentObject(userRepository)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Mis notas")
                }
                .tag(tabs.mynotes)
            ListSharedNotesView(picker: picker).environmentObject(userRepository)
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Notas compartidas")
                }
                    .tag(tabs.sharednotes)
            ProfileView().environmentObject(userRepository)
                    .tabItem {
                        Image(systemName: "3.circle")
                        Text("Perfil")
                    }
                    .tag(tabs.profile)
        }
    }
}

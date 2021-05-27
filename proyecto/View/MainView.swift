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
                    Image(systemName: "note")
                    Text("Mis notas")
                }
                .tag(tabs.mynotes)
            ListSharedNotesView(picker: picker).environmentObject(userRepository)
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Notas compartidas")
                }
                    .tag(tabs.sharednotes)
            ProfileView().environmentObject(userRepository)
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Perfil")
                    }
                    .tag(tabs.profile)
        }
    }
}

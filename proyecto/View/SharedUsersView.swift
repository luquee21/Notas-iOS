//
//  SharedUsersView.swift
//  proyecto
//
//  Created by macOS on 16/4/21.
//

import SwiftUI

struct SharedUsersView: View {
    var users: Array<User>
    var body: some View {
        ScrollView{
            LazyVStack(alignment: .leading, spacing: 12){
                if !users.isEmpty{
                    Text("Total: \(users.count)")
                        .font(.largeTitle)
                }
                ForEach(users){ u in
                    Text(u.user)
                        .font(.title)
                    Divider()
                }
            }.padding()
        }
    }
}

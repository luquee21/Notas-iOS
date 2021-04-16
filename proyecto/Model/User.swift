//
//  User.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable{
     var id: Int
     var user: String
     var pass: String
    
    init(){
        self.id = -1
        self.user = ""
        self.pass = ""
    }
    
    func getUser() -> User{
        let def = UserDefaults.standard
        if let saved = def.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode(User.self, from: saved){
                return loaded
            }
        }
        return User.init()
    }
}




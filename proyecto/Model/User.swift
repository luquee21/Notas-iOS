//
//  User.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable, Equatable{
     var id: Int?
     var user: String
     var pass: String?
    
    static func == (ln: User, rn: User) -> Bool {
        return (ln.id == rn.id) || (ln.user == rn.user)
        }
    
    init(){
        self.id = -1
        self.user = ""
        self.pass = ""
    }
    
    init(user: String){
        self.user = user
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




//
//  UserAuth.swift
//  proyecto
//
//  Created by macOS on 6/4/21.
//

import SwiftUI

class UserAuth: ObservableObject {
    @Published var isAuthorized: Bool = false
    let def = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var user: User = User.init()
    
    init(){
        if def.value(forKey: "isLogin") != nil {
            if let saved = def.object(forKey: "user") as? Data {
                if let loaded = try? decoder.decode(User.self, from: saved){
                    user = loaded
                    self.isAuthorized = true
                }
            }
        }
    }
    
    func getUser() -> User{
        return self.user
    }
    
    func deauthorize(){
        def.removeObject(forKey: "isLogin")
        def.removeObject(forKey: "user")
        self.user = User.init()
        isAuthorized = false
    }
    
    func authorize(_ user: User){
        self.user = user
        def.set(true, forKey: "isLogin")
        isAuthorized = true
    }
}				

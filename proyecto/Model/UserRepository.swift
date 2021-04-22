//
//  UserAuth.swift
//  proyecto
//
//  Created by macOS on 6/4/21.
//

import SwiftUI
import Alamofire
import SwiftyJSON

class UserRepository: ObservableObject {
    @Published var isAuthorized: Bool = false
    @Published var myNotes : [Note] = []
    @Published var sharedNotes : [Note] = []
    @Published var countMyNotes: Int = 1
    @Published var countSharedNotes: Int = 1

    @Published var initialLoadingMyNotes: Bool = true
    @Published var isLoadedMyNotes: Bool = false
    @Published var isRefreshingMyNotes: Bool = false
    
    @Published var initialLoadingSharedNotes: Bool = true
    @Published var isLoadedSharedNotes: Bool = false
    @Published var isRefreshingSharedNotes: Bool = false
    
    let def = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var user: User = User.init()
    final let limitPerPage = 10
    
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
        myNotes = []
        sharedNotes = []
        isAuthorized = false
    }
    
    func authorize(_ user: User){
        self.user = user
        def.set(true, forKey: "isLogin")
        isAuthorized = true

    }
    
    func refresh(_ tab: MainView.tabs){
        if tab == .mynotes {
            self.isRefreshingMyNotes = true
            getMyNotes()
        } else if tab == .sharednotes {
            self.isRefreshingSharedNotes = true
            getSharedNotes()
        }
    }
    
    
    func getMyNotes(){
        if isRefreshingMyNotes {
            self.countMyNotes = 1
        }
        
        let finalurl = Api.url + "notes/unshared/\(self.user.id!)/page/\(countMyNotes)"
        AF.request(finalurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Api.headers)
            .responseJSON{ response in
                do{
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    let result = json["result"]
                    if serverResponse == 200 {
                        if status == "1"{
                            let notesencoded = try Api.encoder.encode(result)
                            let notes = try Api.decoder.decode([Note].self, from: notesencoded)
                            if notes.isEmpty {
                                self.countMyNotes = -1
                            } else {
                                if self.isRefreshingMyNotes {
                                    self.myNotes = notes
                                } else {
                                    if self.myNotes.count < self.limitPerPage {
                                        self.myNotes = notes
                                        self.countMyNotes = -1
                                    } else {
                                        if notes.count < self.limitPerPage{
                                            self.countMyNotes = -1
                                        } 
                                        self.myNotes += notes
                                    }
                                    
                                }
                            }
                            self.isLoadedMyNotes = true
                        } else {
                            self.countMyNotes = -1
                            self.isLoadedMyNotes = true
                            //alert error status
                        }
                        self.initialLoadingMyNotes = false
                    } else {
                        self.initialLoadingMyNotes = false
                        self.isLoadedMyNotes = true
                        self.countMyNotes = -1
                        //alert error response
                    }
                } catch{
                    self.initialLoadingMyNotes = false
                    self.isLoadedMyNotes = true
                    print(error)
                }
                self.isRefreshingMyNotes = false
        }
    }
    
    
    func getSharedNotes(){
        if isRefreshingSharedNotes {
            self.countSharedNotes = 1
        }
        
        let finalurl = Api.url + "notes/shared/\(self.user.id!)/page/\(countSharedNotes)"
        print(finalurl)
        AF.request(finalurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Api.headers)
            .responseJSON{ response in
                do{
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    let result = json["result"]
                    
                    if serverResponse == 200 {
                        if status == "1"{
                            let notesencoded = try Api.encoder.encode(result)
                            var notes = try Api.decoder.decode([Note].self, from: notesencoded)
                            if notes.isEmpty {
                                //Para que no haga el infinite scroll
                                self.countSharedNotes = -1
                            } else {
                                for var note in notes {
                                    note.date = DateAgo.getTimeAgo(note.date)
                                    note.date_creation = DateAgo.getTimeAgo(note.date_creation)
                                }
                                if self.isRefreshingSharedNotes {
                                    self.sharedNotes = notes
                                } else {
                                    if notes.count < self.limitPerPage{
                                        self.countSharedNotes = -1
                                    }
                                    self.sharedNotes += notes
                                }
                            }
                            self.isLoadedSharedNotes = true
                        } else {
                            self.countSharedNotes = -1
                            self.isLoadedSharedNotes = true
                            //alert error status
                        }
                        self.initialLoadingSharedNotes = false
                    } else {
                        self.initialLoadingSharedNotes = false
                        self.isLoadedSharedNotes = true
                        self.countSharedNotes = -1
                        //alert error response
                    }
                } catch{
                    self.initialLoadingSharedNotes = false
                    self.isLoadedSharedNotes = true
                    self.countSharedNotes = -1
                    print(error)
                }
                self.isRefreshingSharedNotes = false
        }
    }
    

}				

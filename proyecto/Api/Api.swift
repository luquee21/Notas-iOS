//
//  Api.swift
//  proyecto
//
//  Created by macOS on 24/3/21.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Api {
  
    static var loading = false
    static let url = ""
    static let apikey = ""
    static let headers: HTTPHeaders = [
        "apikey": apikey,
    ]
    static let def = UserDefaults.standard
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    static func login(_ user: String, _ pass: String, _ completion: @escaping (User,String) -> ()){
        let finalurl = url + "users/\(user)"
        let params = [
            "pass" : pass
        ]
        AF.request(finalurl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                do{
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    let result = json["result"]
                    
                    
                    if serverResponse == 200 {
                        if status == "1"{
                            let user = try encoder.encode(result)
                            let decode = try decoder.decode(User.self,from: user)
                            UserDefaults.standard.set(user, forKey: "user")
                            completion(decode,"")
                        } else {
                            //alert error status
                            completion(User.init(),"Error, usuario o contraseña incorrecto")
                        }
                    } else {
                        //alert error response
                        completion(User.init(), "Error, el servidor no responde")
                    }
                } catch{
                    print(error)
                }
        }
    }
    
    static func signIn(_ user: String, _ pass: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "users"
        let params = [
            "user": user,
            "pass" : pass
        ]
        AF.request(finalurl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    
                    
                    if serverResponse == 200 {
                        if status == "1"{
                            completion("")
                        } else {
                            //alert error status
                            completion("Error el usuario ya existe")
                        }
                    } else {
                        //alert error response
                        completion("Error, el servidor no responde")
                    }
               
        }
    }
    
    static func updatePassword(_ id_user: String, _ pass: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "users/\(id_user)"
        let params = [
            "pass" : pass
        ]
        AF.request(finalurl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    debugPrint(json)
                    
                    if serverResponse == 200 {
                        if status == "1"{
                            completion("")
                        } else {
                            //alert error status
                            completion("Error, la contraseña no se ha podido cambiar")
                        }
                    } else {
                        //alert error response
                        completion("Error, el servidor no responde")
                    }
               	
        }
    }
    
    
    static func getMyNotes(_ user : User, _ completion: @escaping (String, Array<Note>) -> ()){
        let finalurl = url + "notes/unshared/\(user.id)"
        var notes: [Note] = []
        AF.request(finalurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                do{
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    let result = json["result"]
                    
                    
                    if serverResponse == 200 {
                        if status == "1"{
                            let notesencoded = try encoder.encode(result)
                            notes = try decoder.decode([Note].self, from: notesencoded)
                            completion("", notes)
                        } else {
                            //alert error status
                            completion("No hay ninguna nota", notes)
                        }
                    } else {
                        //alert error response
                        completion("Error, el servidor no responde",notes)
                    }
                } catch{
                    print(error)
                }
        }
    }
    
    static func getSharedNotes(_ user : User, _ completion: @escaping (String, Array<Note>) -> ()){
        let finalurl = url + "notes/shared/\(user.id)"
        var notes: [Note] = []
        AF.request(finalurl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                do{
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    let result = json["result"]
                    
                    
                    if serverResponse == 200 {
                        if status == "1"{
                            let notesencoded = try encoder.encode(result)
                            notes = try decoder.decode([Note].self, from: notesencoded)
                            completion("", notes)
                        } else {
                            //alert error status
                            completion("No hay ninguna nota compartida", notes)
                        }
                    } else {
                        //alert error response
                        completion("Error, el servidor no responde",notes)
                    }
                } catch{
                    print(error)
                }
        }
    }
    
    static func createNote(_ user : User, _ title: String ,_ completion: @escaping (String, Bool) -> ()){
        let finalurl = url + "notes/\(user.id)"
        let  parameters = [
            "title" : title
        ]
        var flag : Bool = false
        AF.request(finalurl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                let data = response.data!
                let serverResponse = response.response!.statusCode
                let json = JSON(data)
                let status = json["status"]
    
                if serverResponse == 200 {
                    if status == "1"{
                        flag.toggle()
                        completion("", flag)
                    } else {
                        //alert error status
                        completion("No se ha podido crear la nota", flag)
                    }
                } else {
                    //alert error response
                    completion("Error, el servidor no responde", flag)
                }
                
        }
    }
    
    
    static func saveNote(_ content: String, _ id_user: String,_ id_note: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "notes/\(id_note)"
        let params = [
            "id_user" : id_user,
            "content" : content
        ]
        
        debugPrint(params)
        debugPrint(id_note)

        AF.request(finalurl, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    if serverResponse == 200 {
                        if status == "1"{
                            completion("")
                        } else {
                            //alert error status
                            completion("No se ha podido guardar la nota")
                        }
                    } else {
                        //alert error response
                        completion("Error, el servidor no responde")
                    }
        }
    }
    
    
}
    
  
        
    
        
    

    
    
   
    




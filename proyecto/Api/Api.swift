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
    
    
    static func getSharedUsers(_ id_note: String, _ completion: @escaping (Array<User>) -> ()){
        let finalurl = url + "notes/shared/users/\(id_note)"
        
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
                            let users = try encoder.encode(result)
                            let decode = try decoder.decode([User].self,from: users)
                            completion(decode)
                        } else {
                            completion(Array<User>())
                        }
                    } else {
                        completion(Array<User>())
                    }
                } catch{
                    print(error)
                }
        }
    }
    
    static func shareNote(_ user: String,_ id_note: String, _ editable: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "notes/shared/to"
        let params = [
            "user": user,
            "id_note": id_note,
            "edit": editable
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
                            completion("No se ha podido compartir la nota")
                        }
                    } else {
                        completion("Error, el servidor no responde")
                    }
        }
    }
    
    static func updateNoteTitle(_ id_note: String, _ title: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "notes/name/\(id_note)"
        let params = [
            "title": title
        ]
        print(finalurl)
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
                            completion("No se ha podido actualizar el título de la nota")
                        }
                    } else {
                        completion("Error, el servidor no responde")
                    }
        }
    }
    
    
    static func deleteNote(_ id_note: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "notes/\(id_note)"
        
        AF.request(finalurl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                print(json)
                    if serverResponse == 200 {
                        if status == "1"{
                            completion("")
                        } else {
                            completion("No se ha podido borrar la nota ")
                        }
                    } else {
                        completion("Error, el servidor no responde")
                    }
               
        }
    }
    
    
    static func unShareNoteTo(_ id_note: String,_ user: String,_ actual_user: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "notes/\(id_note)/unshared/to/\(user)"
        
        AF.request(finalurl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]
                    if serverResponse == 200 {
                        if status == "1"{
                            completion("")
                        } else {
                            if user.compare(actual_user, options: .caseInsensitive) != .orderedSame {
                                completion("No se ha podido dejar de compartir con el usuario \(user)")
                            } else {
                                completion("No se ha podido dejar de compartir la nota")
                            }
                        }
                    } else {
                        completion("Error, el servidor no responde")
                    }
               
        }
    }
    
    static func unShareNoteAll(_ id_note: String, _ completion: @escaping (String) -> ()){
        let finalurl = url + "notes/\(id_note)/unshared/all"
        
        AF.request(finalurl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                    let data = response.data!
                    let serverResponse = response.response!.statusCode
                    let json = JSON(data)
                    let status = json["status"]

                    if serverResponse == 200 {
                        if status == "1"{
                            completion("")
                        } else {
                            completion("No se ha podido dejar de compartir con todos los usuarios")
                        }
                    } else {
                        completion("Error, el servidor no responde")
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
    
    static func createNote(_ user : User, _ title: String ,_ completion: @escaping (String, Bool) -> ()){
        let finalurl = url + "notes/\(user.id!)"
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
    
  
        
    
        
    

    
    
   
    




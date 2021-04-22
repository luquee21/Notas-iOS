//
//  Date.swift
//  proyecto
//
//  Created by macOS on 22/4/21.
//

import SwiftUI


class DateAgo {
    
    static func getTimeAgo(_ dateCreation: String) -> String{
        var aux = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let aux2 = dateFormatter.date(from: dateCreation) {
            aux = aux2.timeAgoDisplay()
        }
        return aux
    }
    
    
    
    
}

 

//
//  Note.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import Foundation
import SwiftUI

struct Note: Identifiable, Codable, Equatable {
     var id: Int
     var user: String
     var title: String
     var content: String
     var date: String
     var date_creation: String
     var shared: Int
     var editable: Int?
     var modified_by: String
    
    static func == (ln: Note, rn: Note) -> Bool {
            return ln.id == rn.id
        }
    
}

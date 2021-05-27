//
//  Note.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import Foundation
import SwiftUI

struct Note: Identifiable, Codable, Equatable {
     var id: Int = -1
     var user: String = ""
     var title: String = ""
     var content: String? = ""
     var date: String = ""
     var date_creation: String = ""
     var shared: Int = -1
     var editable: Int? = -1
     var modified_by: String = ""
     var users_share_note: Array<User>? = []
     var images: Array<ImageModelString>? = []
    
    static func == (ln: Note, rn: Note) -> Bool {
            return ln.id == rn.id
        }

    
    
}

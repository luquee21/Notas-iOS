//
//  NoteRepository.swift
//  proyecto
//
//  Created by macOS on 7/4/21.
//

import Foundation


class NoteRepository: ObservableObject{
    @Published var myNotes : [Note] = []
    @Published var sharedNotes : [Note] = []
        
}

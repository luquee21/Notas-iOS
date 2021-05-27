//
//  RowNoteView.swift
//  proyecto
//
//  Created by macOS on 7/4/21.
//

import SwiftUI

struct RowNoteView: View {
    var note: Note
    var isLast: Bool
    @ObservedObject var userRepository : UserRepository
    @State var date: Date = Date()
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(note.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            if note.shared == 1 {
                if isLast {
                    Text("Últ. vez modificado el \(date.stringToDate(note.date)) por: \(note.modified_by)")
                        .font(.subheadline)
                    ProgressView()
                        .isHidden((self.userRepository.isLoadedSharedNotes))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.orange)

                } else {
                    Text("Últ. vez modificado el \(date.stringToDate(note.date)) por: \(note.modified_by)")
                        .font(.subheadline)
                }
               
            } else {
                if isLast {
                    Text("Últ. vez modificado el \(date.stringToDate(note.date))")
                        .font(.subheadline)
                    ProgressView()
                        .isHidden((self.userRepository.isLoadedMyNotes))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.orange)
                } else {
                    Text("Últ. vez modificado el \(date.stringToDate(note.date))")
                        .font(.subheadline)
                }
                
            }
            Divider()
        }
       
        
        
       
    }
    

   
}



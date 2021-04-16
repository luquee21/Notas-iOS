//
//  RowNoteView.swift
//  proyecto
//
//  Created by macOS on 7/4/21.
//

import SwiftUI

struct RowNoteView: View {
    var note: Note
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(note.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            if note.shared == 1 {
                Text("Últ. vez modificado hace \(note.date) por \(note.modified_by)")
                    .font(.subheadline)

            } else {
                Text("Últ. vez modificado hace \(note.date)")
                    .font(.subheadline)
            }
            Divider()
        }.padding()
    }
}



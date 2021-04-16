//
//  ListSharedNotesView.swift
//  proyecto
//
//  Created by macOS on 12/4/21.
//

import SwiftUI

struct ListSharedNotesView: View {
    @ObservedObject var userAuth: UserAuth = UserAuth()
    @ObservedObject var notes: NoteRepository = NoteRepository()
       
       var body: some View {
           NavigationView{
               ScrollView{
                    LazyVStack{
                        ForEach(0..<notes.sharedNotes.count, id: \.self){i in
                            NavigationLink(destination: NoteView(note: notes.sharedNotes[i], index: i, userAuth: userAuth, noteRepository: notes)){
                                RowNoteView(note: notes.sharedNotes[i])
                            }
                        }
                    }
               }.navigationBarTitle("Notas compartidas")
           }
           
       }
       
       init(){
           getNotes()
       }
       
       func addNote(){
           
       }
       
       func deleteNote(){
           
       }
       
       
       func getNotes(){
           Api.getSharedNotes(userAuth.getUser()){text,list in
               if !list.isEmpty{
                   notes.sharedNotes = list
               } else {
                   //Mostrar toast
               }
           }
       }
}

struct ListSharedNotesView_Previews: PreviewProvider {
    static var previews: some View {
        ListSharedNotesView()
    }
}

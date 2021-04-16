//
//  ListMyNotesView.swift
//  proyecto
//
//  Created by macOS on 7/4/21.
//

import SwiftUI
import ToastUI

struct ListMyNotesView: View {
    @ObservedObject var userAuth: UserAuth = UserAuth()
    @ObservedObject var notes: NoteRepository = NoteRepository()
    @State var showingToast: Bool = false
    @State var hide: Bool = true
    @State var title: String = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack{
                    ForEach(0..<notes.myNotes.count,id: \.self){i in
                        NavigationLink(destination: NoteView(note: self.notes.myNotes[i], index: i, userAuth: userAuth, noteRepository: notes)){
                            RowNoteView(note: self.notes.myNotes[i])
                        }
                    }
                }
            }
            .navigationBarTitle("Mis notas")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        self.showingToast.toggle()
                
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.orange)
                        .isHidden(hide)
                }
            }
          
            .toast(isPresented: $showingToast){
                CustomToastView(title: "Añadir nota", message: "Introduce el título de la nota", negativeButton: "Cancelar", positiveButton: "Añadir", textField: $title, showingToast: $showingToast){
                    addNote()
                }
            }
        }
        
    }
    
    init(){
        getNotes()
    }
    
    func addNote(){
        self.hide = false
        if title.count <= 70{
            
            Api.createNote(userAuth.getUser(), title) { text, bool in
                self.hide = true
                if bool {
                    getNotes()
                    //alert de exito?
                } else {
                    //alert error
                }
            }
        } else {
            // alert no puede tener mas de 70 caracteres
        }
        
    }
    
    func deleteNote(){
        
    }
    
    
    func getNotes(){
        Api.getMyNotes(userAuth.getUser()){text,list in
            if !list.isEmpty{
                notes.myNotes = list
            } else {
                //Mostrar toast
            }
        }
    }
}



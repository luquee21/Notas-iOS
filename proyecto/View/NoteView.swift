//
//  NoteView.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import SwiftUI
import ToastUI

struct NoteView: View {
    var note : Note
    var index: Int
    @State var oldContent: String = ""
    @State var content: String = ""
    @State var save: Bool = false
    @State var isSaving = false
    @State var showShareNote = false
    @State var showUnshareNoteTo = false
    @State var showUnshareNoteAll = false
    @State var showUnshareNote = false
    @State var showChangeTitle = false
    @State var showDeleteNote = false
    @State var showAlert = false
    @State var user_to_share: String = ""
    @ObservedObject var userAuth: UserAuth
    @ObservedObject var noteRepository: NoteRepository
    
    var body: some View {
        VStack{
            TextEditor(text: $content)
                .disabled(note.editable == 0)
                .navigationBarTitle(note.title, displayMode: .automatic)
                .onAppear(){
                    debugPrint(note)
                    content = note.content
                    oldContent = content
                }
        }
       
            .toast(isPresented: $showShareNote){
                CustomToastView(title: "Compartir", message: "Introduce el nombre de usuario", negativeButton: "Cancelar", positiveButton: "Compartir", textField: $user_to_share, showingToast: $showShareNote){
                    shareNote()
                }
            }
            .toast(isPresented: $showUnshareNoteTo){
                CustomToastView(title: "Dejar de compartir", message: "Introduce el nombre de usuario al que desea de dejar de compartir la nota", negativeButton: "Cancelar", positiveButton: "Dejar de compartir",  textField: $user_to_share,  showingToast: $showUnshareNoteTo){
                    
                }
            }

            .toast(isPresented: $showChangeTitle){
                CustomToastView(title: "Cambiar título", message: "Introduce el nuevo título de la nota", negativeButton: "Cancelar", positiveButton: "Cambiar", textField: $user_to_share, showingToast: $showChangeTitle){
                }
            }
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    
                        Button(action: {
                            isSaving = true
                            saveNote()
                        }, label: {
                            Image(systemName: "square.and.arrow.down")
                        })
                       
                        .disabled(isSaving)
                        
                    
                        Button(action: {
                            
                        }, label: {
                            Menu{
                                Button("Información", action: {
                                    
                                    showAlert.toggle()
                                })
                                Button("Cambiar título", action: {showChangeTitle.toggle()}).disabled(note.user != userAuth.getUser().user)
                                Button("Compartir", action: {showShareNote.toggle()}).disabled(note.user != userAuth.getUser().user && note.editable !=  nil && note.editable == 0)
                                Button("Dejar de compartir", action: {showUnshareNote.toggle()
                                    showAlert.toggle()
                                }).disabled((note.user == userAuth.getUser().user) || note.shared == 0)
                                Button("Dejar de compartir a", action: {showUnshareNoteTo.toggle()}).disabled((note.user != userAuth.getUser().user) || note.shared == 0)
                                Button("Dejar de compartir con todos", action: {showUnshareNoteAll.toggle()
                                    showAlert.toggle()
                                }).disabled((note.user != userAuth.getUser().user) || note.shared == 0)
                                Button("Borrar", action: {showDeleteNote.toggle()
                                        showAlert.toggle()}).disabled(note.user != userAuth.getUser().user)
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        })
                    
                }
                        
        }
        .alert(isPresented: $showAlert){
            var alert: Alert = Alert.init(title: Text(""))
            if showDeleteNote {
                alert = Alert(title: Text("Borrar"), message: Text("¿Desea borrar la nota?"), primaryButton: .default(Text("Cancelar")), secondaryButton:  .destructive(Text("Borrar")){})
            } else if (showUnshareNote){
               alert = Alert(title: Text("Dejar de compartir"), message: Text("¿Desea dejar de compartir la nota?"), primaryButton: .default(Text("Cancelar")), secondaryButton:  .destructive(Text("Dejar de compartir")){})
            } else if (showUnshareNoteAll){
                alert = Alert(title: Text("Dejar de compartir"), message: Text("¿Desea dejar de compartir la nota con todos los usuarios?"), primaryButton: .default(Text("Cancelar")), secondaryButton: .destructive(Text("Dejar de compartir")){})
            }
            return alert
        }
        
        
      
                    
    }
    
    func shareNote(){
        
    }
    
    func saveNote(){
        if oldContent.compare(content, options: .caseInsensitive) != .orderedSame {
            Api.saveNote(content,String(userAuth.getUser().id), String(note.id)) { text in
                if text.isEmpty{	
                    oldContent = content
                    debugPrint("Guardado")

                    if note.shared == 1{
                       self.noteRepository.sharedNotes[index].content = content
                    } else {
                        self.noteRepository.myNotes[index].content = content
                        debugPrint(self.noteRepository.myNotes[index].content)
                    }
                } else {
                    //alert de error?
                    debugPrint(text)
                }
                isSaving = false
            }
        } else {
            debugPrint("No se guarda, son iguales")
            isSaving = false

        }
    }

    func showInfo(){
            
    }
}


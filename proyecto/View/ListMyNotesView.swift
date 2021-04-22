//
//  ListMyNotesView.swift
//  proyecto
//
//  Created by macOS on 7/4/21.
//

import SwiftUI
import ToastUI

struct ListMyNotesView: View {
    @EnvironmentObject var userRepository: UserRepository
    @State var showingToast: Bool = false
    @State var hide: Bool = true
    @State var title: String = ""
    @State var isLoading: Bool = true
    let picker: ImagePicker
    
    var body: some View {
        NavigationView{
            ScrollView{
                Refresher(coordinateSpace: .named("Refresher"), isLoaded: $userRepository.isLoadedMyNotes) {
                    self.userRepository.refresh(.mynotes)
                }
                
                LazyVStack(alignment: .leading){
                    if userRepository.myNotes.isEmpty {
                        Text("No hay ninguna nota creada")
                            .font(.title)
                            .padding(.top, 15)
                    }
                    ForEach(0..<userRepository.myNotes.count,id: \.self){i in
                        NavigationLink(destination: NoteView(note: userRepository.myNotes[i], index: i, picker: picker, userRepository: userRepository)){
                            RowNoteView(note: self.userRepository.myNotes[i],isLast: i == self.userRepository.myNotes.count - 1,userRepository: userRepository)
                                .onAppear{
                                    if i == userRepository.myNotes.count - 1  && i >= userRepository.limitPerPage-1 {
                                        self.userRepository.isLoadedMyNotes = false
                                        if self.userRepository.countMyNotes != -1{
                                            self.userRepository.countMyNotes += 1
                                            self.userRepository.getMyNotes()
                                        } else {
                                            self.userRepository.isLoadedMyNotes = true
                                        }
                                    }
                                }
                        }.foregroundColor(.white)
                    }
                }
                .padding()
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
                CustomToastView(title: "Añadir nota", message: "Introduce el título de la nota", negativeButton: "Cancelar", positiveButton: "Añadir", textField: $title, showingToast: $showingToast, edit: $showingToast, isSharing: false){
                    addNote()
                }
            }
    
            
        }
        
    }
    
    
    func addNote(){
        self.hide = false
        if title.count <= 50{
            Api.createNote(userRepository.getUser(), title) { text, bool in
                self.hide = true
                if bool {
                    userRepository.refresh(MainView.tabs.mynotes)
                    //alert de exito?
                } else {
                    //alert error
                }
            }
        } else {
            // alert no puede tener mas de 50 caracteres
        }
        
    }
    
}



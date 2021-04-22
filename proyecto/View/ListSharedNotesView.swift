//
//  ListSharedNotesView.swift
//  proyecto
//
//  Created by macOS on 12/4/21.
//

import SwiftUI

struct ListSharedNotesView: View {
    @EnvironmentObject var userRepository: UserRepository
    @State var bool: Bool = false
    let picker: ImagePicker
       var body: some View {
           NavigationView{
               ScrollView{
                Refresher(coordinateSpace: .named("Refresher"), isLoaded: $userRepository.isLoadedSharedNotes) {
                        self.userRepository.refresh(.sharednotes)
                    }
                LazyVStack(alignment: .leading){
                        if userRepository.sharedNotes.isEmpty {
                            Text("No hay ninguna nota compartida")
                                .font(.title)
                                .padding(.top, 15)
                        }
                        ForEach(0..<userRepository.sharedNotes.count, id: \.self){ i in
                            NavigationLink(destination: NoteView(note: userRepository.sharedNotes[i], index: i, picker: picker, userRepository: userRepository)){
                                RowNoteView(note: userRepository.sharedNotes[i],isLast: i == self.userRepository.sharedNotes.count - 1,userRepository: userRepository)
                                    .onAppear{
                                        //Compruebo que es el último del array de notas compartidas
                                        if i == userRepository.sharedNotes.count - 1 && i >= userRepository.limitPerPage-1{
                                            print(self.userRepository.countSharedNotes)
                                            self.userRepository.isLoadedSharedNotes = false
                                            if self.userRepository.countSharedNotes != -1 {
                                                self.userRepository.countSharedNotes += 1
                                                self.userRepository.getSharedNotes()
                                            } else {
                                                self.userRepository.isLoadedSharedNotes = true
                                            }
                                    }
                                }
                        }.foregroundColor(.white)
            
                    }
                }.navigationBarTitle("Notas compartidas")
                    .padding()
            }
        
           
        }

       }
    
}

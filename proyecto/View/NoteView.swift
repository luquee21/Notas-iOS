//
//  NoteView.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//


import SwiftUI
import ToastUI
import YPImagePicker

struct NoteView: View {
    @Binding var note : Note
    let index: Int
    let picker: ImagePicker
    @State var date = Date()
    @State var i: Int = 0
    @State var oldContent: String = ""
    @State var content: String = ""
    @State var dateCreation: String = ""
    @State var dateLastModified: String = ""
    @State var title: String = ""
    @State var newtitle: String = ""
    @State var save: Bool = false
    @State var edit: Bool = true
    @State var isSaving = false
    @State var showShareNote = false
    @State var showUnshareNoteTo = false
    @State var showUnshareNoteAll = false
    @State var showUnshareNote = false
    @State var showChangeTitle = false
    @State var showDeleteNote = false
    @State var showDeleteImage = false
    @State var showAlert = false
    @State var showInfo = false
    @State var showImages = false
    @State var canEdit = true
    @State var showInfoShared = false
    @State var user_to_share: String = ""
    @State var user_to_unshare: String = ""
    @State var usersShared: Array<User> = []
    @State var images: Array<UIImage> = []
    @ObservedObject var userRepository: UserRepository
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{                              
                TextEditor(text: $content)
                    .disabled(note.editable == 0 || !canEdit)
                    .onAppear{
                        if note.shared == 1 {
                            getSharedUsers()
                        }
                        title = note.title
                        content = note.content ?? ""
                        oldContent = content
                        getPhotos()
                    }
                    .padding(.horizontal, 5)
            }
            .navigationBarTitle(title, displayMode: .large)

            .toast(isPresented: $showShareNote){
                CustomToastView(title: "Compartir", message: "Introduce el nombre de usuario", negativeButton: "Cancelar", positiveButton: "Compartir", textField: $user_to_share, showingToast: $showShareNote, edit: $edit, isSharing: true){
                    shareNote()
                }
            }
            .toast(isPresented: $showUnshareNoteTo){
                CustomToastView(title: "Dejar de compartir", message: "Introduce el nombre de usuario al que desea de dejar de compartir la nota", negativeButton: "Cancelar", positiveButton: "Dejar de compartir",  textField: $user_to_unshare,  showingToast: $showUnshareNoteTo, edit: $edit, isSharing: false){
                    unShareNoteTo(false)
                }
            }

            .toast(isPresented: $showChangeTitle){
                CustomToastView(title: "Cambiar título", message: "Introduce el nuevo título de la nota", negativeButton: "Cancelar", positiveButton: "Cambiar", textField: $newtitle, showingToast: $showChangeTitle, edit: $edit, isSharing: false){
                    updateTitleNote()
                }
            }
            
            .sheet(isPresented: $showInfoShared){
                SharedUsersView(users: userRepository.sharedNotes[index].users_share_note!)
            }
            .sheet(isPresented: $showImages){
                ImageRowView(note: $note)
            }
            
            .toolbar{
                ToolbarItemGroup(placement: .bottomBar){
                    Button(action: {
                        showDeleteNote = true
                        showAlert.toggle()
                    }, label: {
                        Image(systemName: "trash")
                    })
                    .disabled(note.user != userRepository.getUser().user)
                    
                    Spacer()
                    Button(action: {
                        canEdit.toggle()
                    }, label: {
                        Image(systemName: canEdit ? "pencil" : "pencil.slash")
                    })
                    
                    Spacer()
                    Button(action: {
                        showImages.toggle()
                    }, label: {
                        Image(systemName: "list.bullet")
                    })
                   
                    Spacer()
                    Button(action: {
                        getPhoto()
                    }, label: {
                        Image(systemName: "camera")
                    })
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button(action: {
                            
                        }, label: {
                            Menu{
                                Button("Información", action: {
                                    showInfo = true
                                    showAlert.toggle()
                                })
                                Button("Cambiar título", action: {showChangeTitle.toggle()}).disabled(note.user != userRepository.getUser().user)
                                Button("Compartir", action: {showShareNote.toggle()}).disabled(note.user != userRepository.getUser().user && note.editable !=  nil && note.editable == 0)
                                Button("Usuarios que comparten la nota", action: {
                                    showInfoShared = true
                                })
                                .disabled(usersShared.isEmpty)
                                Button("Dejar de compartir", action: {showUnshareNote = true
                                    showAlert.toggle()
                                }).disabled((note.user == userRepository.getUser().user) || note.shared == 0)
                                Button("Dejar de compartir a", action: {showUnshareNoteTo.toggle()}).disabled((note.user != userRepository.getUser().user) || note.shared == 0)
                                Button("Dejar de compartir con todos", action: {showUnshareNoteAll = true
                                    showAlert.toggle()
                                }).disabled((note.user != userRepository.getUser().user) || note.shared == 0)
                            
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        })
                    
                        Button(action: {
                           UIApplication.shared.endEditing()
                            isSaving = true
                            saveNote()
                        }, label: {
                            Text("OK")
                        }).disabled(isSaving || oldContent.compare(content, options: .caseInsensitive) == .orderedSame)
                        
                       
                    
                }
                        
        }
        .alert(isPresented: $showAlert){
            var alert: Alert = Alert.init(title: Text(""))
            if showDeleteNote {
                alert = Alert(title: Text("Borrar"), message: Text("¿Desea borrar la nota?"), primaryButton: .default(Text("Cancelar")){showDeleteNote = false}, secondaryButton:  .destructive(Text("Borrar")){deleteNote()})
            } else if (showUnshareNote){
                alert = Alert(title: Text("Dejar de compartir"), message: Text("¿Desea dejar de compartir la nota?"), primaryButton: .default(Text("Cancelar")){showUnshareNote = false}, secondaryButton:  .destructive(Text("Dejar de compartir")){unShareNoteTo(true)})
            } else if (showUnshareNoteAll){
                alert = Alert(title: Text("Dejar de compartir"), message: Text("¿Desea dejar de compartir la nota con todos los usuarios?"), primaryButton: .default(Text("Cancelar")){showUnshareNoteAll = false}, secondaryButton: .destructive(Text("Dejar de compartir")){unShareNoteAll()
                })
            } else if (showInfo){
                if (note.shared == 1) {
                    alert = Alert(title: Text("Información"), message:
                                    Text("Creado por: \(note.user) \n Últ. vez modificado por: \(note.modified_by) el \(date.stringToDate(note.date)) \n Creado: \(date.stringToDate(note.date_creation))"))
                } else {
                    alert = Alert(title: Text("Información"), message:
                    Text("Creado por: \(note.user) \n Creado: \(date.stringToDate(note.date_creation))"))
                }
            } else if showDeleteImage {
                alert = Alert(title: Text("Borrar"), message: Text("¿Desea borrar la foto?"), primaryButton: .default(Text("Cancelar")){showDeleteImage = false}, secondaryButton:  .destructive(Text("Borrar")){
                    
                })
            }
            return alert
        }
        
        
      
                    
    }

    func getPhoto(){
        let picker = self.picker.getPicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                uploadPhoto(photo.image)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        self.picker.rootViewController().present(picker, animated: true, completion: nil)
    }
    
    
    func uploadPhoto(_ image: UIImage){
        Api.uploadPhoto(image, userRepository.user.id!, note.id){error in
            if error.isEmpty{
                print("Foto subida")
                getPhotos()
            } else {
                //error
                print("Foto no subida")
            }
        }
    }
    
    
    func getSharedUsers(){
        if note.shared == 1 {
            if self.userRepository.sharedNotes[index].users_share_note == nil || self.userRepository.sharedNotes[index].users_share_note!.isEmpty{
                print("getting users shared")
                Api.getSharedUsers(String(note.id)){ users in
                    self.userRepository.sharedNotes[index].users_share_note = users
                    usersShared = users
                }
            } else {
                usersShared = self.userRepository.sharedNotes[index].users_share_note!
            }
        }
    }
    
    //falta añadir al array de compartidos el usuario que se acaba de compartir y eliminar del array la si antes no habia sido compartida para pasarla al array de sharednotes
    func shareNote(){
        var editable: String = "1"
        if !edit {
            editable = "0"
        }
        let user: User = User(user: user_to_share)
        
        if note.shared == 0 {
            if  userRepository.myNotes[index].users_share_note != nil && !userRepository.myNotes[index].users_share_note!.isEmpty {
                if userRepository.myNotes[index].users_share_note!.contains(user){
                    //alert error el usuario ya comparte esta nota
                    print("already shared this user")
                } else {
                    Api.shareNote(user_to_share, String(note.id), editable) { text in
                        if text.isEmpty {
                            print("entre")
                            self.userRepository.myNotes[index].users_share_note?.insert(user, at: 0)
                            self.userRepository.myNotes[index].shared = 1
                            self.userRepository.sharedNotes.insert(self.userRepository.myNotes[index], at: 0)
                            self.userRepository.myNotes.remove(at: index)
                        } else {
                            
                        }
                    }
                }
            } else {
                Api.shareNote(user_to_share, String(note.id), editable) { text in
                    if text.isEmpty {
                        self.userRepository.myNotes[index].users_share_note?.insert(user, at: 0)
                        self.userRepository.myNotes[index].shared = 1
                        self.userRepository.sharedNotes.insert(self.userRepository.myNotes[index], at: 0)
                        self.userRepository.myNotes.remove(at: index)
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        
                    }
                }
            }
        } else {
            if  userRepository.sharedNotes[index].users_share_note != nil && !userRepository.sharedNotes[index].users_share_note!.isEmpty {
                if userRepository.sharedNotes[index].users_share_note!.contains(user){
                    //alert error el usuario ya comparte esta nota
                    print("already shared this user")
                } else {
                    Api.shareNote(user_to_share, String(note.id), editable) { text in
                        if text.isEmpty {
                            print("entre")
                            self.userRepository.sharedNotes[index].users_share_note?.insert(user, at: 0)
                        } else {
                            
                        }
                    }
                }
            } else {
                Api.shareNote(user_to_share, String(note.id), editable) { text in
                    if text.isEmpty {
                        self.userRepository.sharedNotes[index].users_share_note?.insert(user, at: 0)
                    } else {
                        
                    }
                }
            }
        }
       
    }
    
    func unShareNoteAll(){
        Api.unShareNoteAll(String(note.id)){ text in
            if text.isEmpty {
                //Alert se ha dejado de compartir con exito
                self.userRepository.sharedNotes[index].users_share_note = []
                self.userRepository.sharedNotes[index].shared = 0
                self.userRepository.myNotes.insert(self.userRepository.sharedNotes[index], at: 0)
                self.userRepository.sharedNotes.remove(at: index)
                self.presentationMode.wrappedValue.dismiss()
            } else {
                //Alert del error
            }
        }
    }
    
    func unShareNoteTo(_ isYourself: Bool){
        let user: User = User(user: user_to_unshare.lowercased())
        if !self.userRepository.sharedNotes[index].users_share_note!.isEmpty {
            if !user_to_unshare.isEmpty {
                if isYourself {
                    Api.unShareNoteTo(String(note.id), userRepository.getUser().user, userRepository.getUser().user){text in
                        if !text.isEmpty {
                            //alert del error
                        } else {
                            //quitar del array de notas
                            self.userRepository.sharedNotes.remove(at: index)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    if self.userRepository.sharedNotes[index].users_share_note!.contains(user){
                        Api.unShareNoteTo(String(note.id),user_to_unshare, userRepository.getUser().user){text in
                            if text.isEmpty {
                                if let i = self.userRepository.sharedNotes[index].users_share_note?.firstIndex(of: user){
                                    self.userRepository.sharedNotes[index].users_share_note?.remove(at: i)
                                    if self.userRepository.sharedNotes[index].users_share_note!.isEmpty {
                                        self.userRepository.sharedNotes[index].shared = 0
                                        self.userRepository.myNotes.insert(self.userRepository.sharedNotes[index], at: 0)
                                        self.userRepository.sharedNotes.remove(at: index)
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                               
                            } else {
                                //alert del error

                            }
                        }
                    } else {
                        print("no lo contiene")
                        //alert el usuario no comparte esta nota
                    }
                }
            } else {
                print("vacio")
            }
        
        }
    }
    
    func updateTitleNote(){
        if newtitle.count <= 50 {
            if newtitle.compare(title, options: .caseInsensitive) != .orderedSame {
                Api.updateNoteTitle(String(note.id), newtitle){ text in
                    print(text)
                    if text.isEmpty {
                        title = newtitle
                        if note.shared == 1{
                           self.userRepository.sharedNotes[index].title = title
                        } else {
                            self.userRepository.myNotes[index].title = title
                        }
                    } else {
                        //alert del error
                    }
                }
            } else {
                //alert no puedes cambiar el titulo es el mismo que el anterior
            }
        } else {
            //alert no puede ser mas de 50 el titulo
        }
    }
    
    func getPhotos(){   
        Api.getPhotos(note.id){image, error in
            if error.isEmpty{
                self.note.images = image.result!
            }
        }
    }
    

    
    func closeView(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func deleteNote(){
        Api.deleteNote(String(note.id)){text in
            if !text.isEmpty {
                if note.shared == 1 {
                    userRepository.sharedNotes.remove(at: index)
                } else {
                    userRepository.myNotes.remove(at: index)
                }
                closeView()
            } else {
                //Alert del error?
            }
        }
    }
    

    
    func saveNote(){
        
        if oldContent.compare(content, options: .caseInsensitive) != .orderedSame {
            Api.saveNote(content,String(userRepository.getUser().id!), String(note.id)) { text in
                if text.isEmpty{	
                    oldContent = content
                    if note.shared == 1{
                       self.userRepository.sharedNotes[index].content = content
                    } else {
                        self.userRepository.myNotes[index].content = content
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

   
}



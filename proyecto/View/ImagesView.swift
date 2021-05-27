//
//  ImagesView.swift
//  proyecto
//
//  Created by macOS on 21/4/21.
//

import SwiftUI
import SwURL

struct ImagesView: View {
    @Binding var note: Note
    @Binding var i: Int
    @State var showDeleteImage: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack{
                
                if note.images != nil && !note.images!.isEmpty{
                    TabView(selection: $i){
                        ForEach(0..<note.images!.count) { i in
                            RemoteImageView(
                                url:  URL(string: "\(Api.urlImage)\(note.images![i].photo)")!
                                        ).imageProcessing({ image in
                                            return image
                                                .resizable()
                                                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
                                                .tag(i)

                                        })
                                
                        }
                            
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .padding()
                } else {
                    Text("No hay ninguna imágen en la nota")
                        .bold()
                }
               
            }
            .toolbar{
               ToolbarItem(placement: .navigationBarLeading){
                   Button(action: {
                       self.presentationMode.wrappedValue.dismiss()
                   }, label: {
                       Text("OK")
                   })
               }
               
               ToolbarItem(placement: .principal){
                   Button(action: {
                       
                   }, label: {
                    Text("\(i+1) de \(note.images!.count)")
                   })
               }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        showDeleteImage = true
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
           }
            
            .alert(isPresented: $showDeleteImage){
                Alert(title: Text("Borrar"), message: Text("¿Desea borrar la foto?"), primaryButton: .default(Text("Cancelar")){showDeleteImage = false}, secondaryButton:  .destructive(Text("Borrar")){
                    
                })
            }
        }
        
    }
}

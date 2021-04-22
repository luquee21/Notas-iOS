//
//  ImagesView.swift
//  proyecto
//
//  Created by macOS on 21/4/21.
//

import SwiftUI

struct ImagesView: View {
    let images: Array<UIImage>
    @Binding var i: Int
    @State var showDeleteImage: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack{
                TabView(selection: $i){
                    ForEach(0..<images.count) { i in
                        Image(uiImage: images[i])
                            .resizable()
                            .scaledToFill()
                            .tag(i)
                           
                            
                    }
                   
                        
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding()
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
                       Text("\(i+1) de \(images.count)")
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

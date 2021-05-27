//
//  ImageRowView.swift
//  proyecto
//
//  Created by macOS on 22/4/21.
//

import SwiftUI
import SwURL

struct ImageRowView: View {
    @Binding var note: Note
    @Environment(\.presentationMode) var presentationMode
    @State var showImages: Bool = false
    @State var i: Int = 0
    @State var date: Date = Date()
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 12){
                    if note.images != nil && !note.images!.isEmpty{
                        Text("Total \(note.images!.count)")
                            .font(.system(size: 18))
                            .bold()
                            .padding(.bottom, 25)
                            .frame(maxWidth: .infinity, alignment: .center)
                        ForEach(note.images!.indices, id: \.self){i in
                            HStack(spacing: 12){
                                RemoteImageView(
                                    url:  URL(string: "\(Api.urlImage)\(note.images![i].photo)")!
                                            ).imageProcessing({ image in
                                                return image
                                                    .resizable()
                                                    .clipped()
                                                    .clipShape(Circle())
                                                    .frame(width: 72, height: 72)
                                            })
                                
                                Text("\(date.stringToDate(note.images![i].date))")
                            }.onTapGesture {
                                self.i = i
                                showImages = true
                            }
                            Divider()
                        }
                    } else {
                        Text("No hay ninguna imágen en la nota")
                            .bold()
                    }
                    
                    Spacer()
                    Spacer()
                } .padding()
            }
           
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("OK")
                    })
                }
            }
            .fullScreenCover(isPresented: $showImages){
                ImagesView(note: $note, i: $i)
            }
        }
       
    }
}

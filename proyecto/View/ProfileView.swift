//
//  ProfileView.swift
//  proyecto
//
//  Created by macOS on 24/3/21.
//

import SwiftUI

struct ProfileView: View {
    @State private var showingAlert = false
    @State private var showDetail = false
    @State private var isPresented = false
    @ObservedObject var userAuth: UserAuth
    var body: some View {
                    List{
                        HStack{
                            Text("Usuario")
                            Divider()
                            Text(userAuth.getUser().user)
                        }
                        Button(action: {
                            self.isPresented.toggle()
                        }, label: {
                            Text("Cambiar contraseña")
                        })
            
                        Button(action: {
                            self.showingAlert.toggle()
                        }, label: {
                            Text("Cerrar sesión")
                        })
                        .alert(isPresented: $showingAlert){
                            Alert(title: Text("Cerrar sesión")
                                   ,
                                message: Text("¿Desea cerrar sesión?")
                                  ,
                                primaryButton: .default(Text("Cancelar")),
                                secondaryButton:  .destructive(
                                    Text("Cerrar sesión")
                                ){
                                        userAuth.deauthorize()
                                            
                                }
                                
                            )
                        }
                }
                    .sheet(isPresented: $isPresented){
                        ChangePasswordView(userAuth: userAuth)
                    }
        }
    }

//
//  ChangePasswordView.swift
//  proyecto
//
//  Created by macOS on 25/3/21.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var pass: String = ""
    @State private var pass2: String = ""
    @State private var changingPassword: Bool = false
    @ObservedObject var userRepository: UserRepository
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center){
            Text("Cambiar contraseña")
                .font(.title)
                .padding(20)
            VStack(alignment: .leading){
                Text("Contraseña")
                    .font(.headline)
                SecureField("", text: $pass)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                Text("Repetir contraseña")
                    .font(.headline)
                SecureField("", text: $pass2)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
               
            }.padding()
            
            ProgressView()
                .isHidden(!changingPassword)
                .foregroundColor(.orange)
                .padding(.vertical, 10)
            
            HStack(){
                Button(action: {
                    self.changingPassword = true
                    changePassword()
                }, label: {
                    Text("Cambiar contraseña")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .accentColor(.black)
                        .padding()
                }).disabled(changingPassword)
            }
            Spacer()
        }
    }
    
    func changePassword(){
        if self.pass.compare(self.pass2, options: .caseInsensitive) == .orderedSame  {
            if pass.count >= 8 {
                Api.updatePassword(String(self.userRepository.getUser().id!), self.pass){ text in
                    if text.isEmpty {
                        self.presentationMode.wrappedValue.dismiss()
                        self.userRepository.deauthorize()
                    } else {
                        //alert error al cambiar contraseña
                    }
                    self.changingPassword = false
                }
            } else {
                self.changingPassword = false
                debugPrint("Tiene que tener 8 o mas caracteres")
                //alert mas de 8 la contraseña
            }
        } else {
            self.changingPassword = false
            //alert son iguales?
            debugPrint("No son iguales")
        }
    }
}



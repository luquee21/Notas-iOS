//
//  RegisterView.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import SwiftUI

struct SignInView: View {
    @State private var user: String = ""
    @State var pass: String = ""
    @State var pass2: String = ""
    @State private var hide = true
    @State private var showPassword: Bool = false
    @State private var signIn: Bool = false
    @State private var showingToast : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center){
            Text("Registro")
                .font(.title)
                .padding(20)
            VStack(alignment: .leading){
                Text("Usuario")
                    .font(.headline)
                    .autocapitalization(.none)
                TextField("", text: $user)
                    .disableAutocorrection(true)
                    .border(Color(UIColor.separator))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
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
                .isHidden(hide)
                .foregroundColor(.orange)
                .padding(.vertical, 10)
            
            HStack(){
                Button(action: {
                    self.hide = false
                    self.signIn = true
                    checkPass(self.user, self.pass,self.pass2)
                }, label: {
                    Text("Regístrate")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .accentColor(.black)
                        .padding()
                        
                }).disabled(signIn || pass.isEmpty || pass2.isEmpty || user.isEmpty || pass.count < 8  || pass2.count < 8 || pass.count > 50 || pass.count > 50 )
            }
            Spacer()
        }
    }
    
    func checkPass(_ user: String, _ pass: String, _ pass2: String){
        if pass == pass2{
                    Api.signIn(user, pass){ text in
                        self.hide = true
                        self.signIn = false
                        if !text.isEmpty{
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            //alert usuario ya existe
                        }
                    }
                
            } else {
                self.hide = true
                self.signIn = false
                //alert pass no iguales
            }
    }
    
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

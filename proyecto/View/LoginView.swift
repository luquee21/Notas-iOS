//
//  ContentView.swift
//  proyecto
//
//  Created by macOS on 23/3/21.
//

import SwiftUI
import ToastUI

struct LoginView: View {
    @EnvironmentObject var userRepository: UserRepository
    @State private var foo: String? = nil
    @State private var user: String = ""
    @State private var pass: String = ""
    @State private var showPassword: Bool = false
    @State private var showingMain : Bool = false
    @State private var showingToast : Bool = false
    @State private var hide = true
    @State private var isLogin = false
    @State private var msg: String = ""
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                Text("Bienvenido")
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
                    ZStack{
                        HStack{
                            
                            if showPassword {
                                TextField("",text: $pass)
                                    .border(Color(UIColor.separator))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("", text: $pass)
                                    .border(Color(UIColor.separator))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Button(action: {
                                self.showPassword.toggle()
                            }){
                                Image(systemName: self.showPassword ? "eye.fill": "eye.slash.fill")
                                    .foregroundColor((self.showPassword) ? Color.green : Color.secondary)
                            }
                                
                        }
                    }

                }.padding(.horizontal)
                
                ProgressView()
                    .isHidden(hide)
                    .foregroundColor(.orange)
                    .padding(.vertical, 10)
                
                Button(action:  {
                    self.checkForm(self.user, self.pass)
                    self.isLogin = true
                }, label: {
                        Text("Iniciar sesión")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .accentColor(.black)
                            .padding()
                            .toast(isPresented: $showingToast, dismissAfter: 2.0){
                                ToastView(self.msg).toastViewStyle(ErrorToastViewStyle())
                            }
                }).disabled(user.isEmpty || pass.isEmpty || pass.count < 8 || isLogin)

                
                HStack(){
                    VStack{
                        Text("¿Aún no dispones de cuenta?")
                        NavigationLink(destination: SignInView()){
                            Text("Regístrate")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .accentColor(.black)
                                .padding()
                        }
                    }
                }
                Spacer()
            }
            
        }
        
    }
    
    func checkForm(_ user: String, _ pass: String){
        self.hide.toggle()
            Api.login(user,pass){result,message  in
                self.hide.toggle()
                self.isLogin = false
                if(result.id != -1){
                    self.userRepository.authorize(result)
                } else {
                    self.msg = message
                    self.showingToast.toggle()
                }
            }
    }

}







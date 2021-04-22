//
//  ToastView.swift
//  proyecto
//
//  Created by macOS on 15/4/21.
//

import SwiftUI
import ToastUI

struct CustomToastView: View {
    var title: String
    var message: String
    var negativeButton: String
    var positiveButton: String
    @Binding var textField: String
    @Binding var showingToast: Bool
    @Binding var edit: Bool
    var isSharing: Bool
    var start: () -> Void
    
    var body: some View {
        ToastView{
            VStack{
                Text(title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 5)
                   Text(message)
                    .font(.body)
                    .padding(.vertical, 5)
                    TextField("", text: $textField)
                        .border(Color(UIColor.separator))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    if isSharing {
                        Toggle("¿Desea que el usuario pueda editar la nota?", isOn: $edit)
                            .toggleStyle(SwitchToggleStyle(tint: .orange))
                    }
                    Divider()
                HStack{
                    Spacer()
                    Button(action: {
                        self.showingToast.toggle()
                    }, label: {
                        Text(negativeButton)
                    })
                    Spacer()
                    Button(action: {
                        self.showingToast.toggle()
                        start()
                    }, label: {
                        Text(positiveButton)
                    })
                    Spacer()
                }
                .padding()
            }.padding()
            
        }
    }
}



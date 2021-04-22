//
//  Keyboard.swift
//  proyecto
//
//  Created by macOS on 21/4/21.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

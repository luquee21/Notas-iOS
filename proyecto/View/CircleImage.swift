//
//  CircleImage.swift
//  proyecto
//
//  Created by macOS on 24/3/21.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var body: some View {
        image
            .resizable()
            .frame(width: 140.0,height: 140.0)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.orange,lineWidth: 4))
            .shadow(radius: 3)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("notas"))
    }
}

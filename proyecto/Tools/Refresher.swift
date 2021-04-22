//
//  Refresher.swift
//  proyecto
//
//  Created by macOS on 20/4/21.
//

import SwiftUI

struct Refresher: View {
    var coordinateSpace: CoordinateSpace
    @State var refresh: Bool = false
    @Binding var isLoaded: Bool
    var onRefresh: () -> Void
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: coordinateSpace).midY > 100) {
                Spacer()
                    .onAppear {
                        print("appear refresh")
                        if !refresh {
                            ///call refresh once if pulled more than 50px
                            isLoaded = false
                            onRefresh()
                        }
                        refresh = true
                    }
                    .onDisappear{
                        print("disappear refresh")
                        if isLoaded {
                            refresh = false
                        }
                    }
    
            }
            ZStack(alignment: .center) {
                if refresh && !isLoaded { ///show loading if refresh called
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.orange))
                        .onDisappear{
                            if isLoaded {
                                refresh = false
                            }                        }
                } 
            }.frame(width: geo.size.width)
        }
        .padding(.top, isLoaded ? -150 : 0)
        .padding(.bottom, isLoaded ? 0 : 0)
        .animation(isLoaded ? .easeOut(duration: 0.4) : .none)
        
    }
}




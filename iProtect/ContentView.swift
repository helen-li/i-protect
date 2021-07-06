//
//  ContentView.swift
//  iProtect
//
//  Created by Helen Li on 7/5/21.
//

import SwiftUI

let defaultTimeRemaining: CGFloat = 10
let lineWith: CGFloat = 30
let radius: CGFloat = 50

struct ContentView: View {
    
    @State private var isActive = false
    @State private var timeRemaining: CGFloat = defaultTimeRemaining
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2),
                            style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                
                Circle()
                    .stroke(Color.green,
                            style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                
                Text("\(timeRemaining)")
            }.frame(width: radius * 8, height: radius * 8)
            
            Button("Start") {
                isActive.toggle()
            }
            
            if isActive {
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


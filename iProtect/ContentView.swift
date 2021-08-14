//
//  ContentView.swift
//  iProtect
//
//  Created by Helen Li on 7/5/21.
//

import SwiftUI
import AVKit

let defaultTimeRemaining: CGFloat = 10
let lineWith: CGFloat = 30
let radius: CGFloat = 50

struct ContentView: View {
    
    @State var isActive = false
    @State var timeRemaining: CGFloat = defaultTimeRemaining
    @State var audioPlayer: AVAudioPlayer!
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func timePadding(time: Int) -> String {
        if time < 10 {
            return "0\(time)"
        } else {
            return "\(time)"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2),
                            style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                Circle()
                    .trim(from: 0, to: 1 - ((defaultTimeRemaining - timeRemaining) / defaultTimeRemaining))
                    .stroke(Color.green,
                            style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                Text(timePadding(time: (Int(timeRemaining) / 60)) + ":" + timePadding(time: (Int(timeRemaining) % 60))).font(.largeTitle)
            }.frame(width: radius * 8, height: radius * 8)
            
            HStack(spacing: 30) {
                Button(isActive ? "Pause" : "Start") {
                    isActive.toggle()
                }.onReceive(timer, perform: { _ in
                    guard isActive else { return }
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        let sound = Bundle.main.path(forResource: "song", ofType: "mov")
                        self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                        self.audioPlayer.play()
                        isActive = false
                        timeRemaining = defaultTimeRemaining
                    }
                    
                })
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

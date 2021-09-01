//
// ContentView.swift
// iProtect
//
// Created by Helen Li on 7/5/21.
// Last edited by Helen Li on 9/1/21.
//
// Following the golden 20-20-20 rule to avoid overusig digital devices and
// straining your eyes, this app sets a default timer of 20 minutes and plays
// the music stored in song.mov file for 20 seconds as soon as the time is up.
// During this 20-second-long period, you will be unable to relaunch the timer,
// and the music should serve as a reminder for you to focus on an item
// approximately 20 feet away to rest your eyes.
//
// As an additional functionality, you can input cutomized minutes and seconds
// to the timer. Make sure to click a spot outside of the input boxes before you
// click the "Change Time" button in order to ensure that the app will take your
// inputted values promptly and correctly.
//
// The song.mov file stores a 20-second-long clip of the flute version of the
// a Chinese song called "Wu Ji." An hour-long version of the song can be found
// at https://www.youtube.com/watch?v=bNlC0pB8a8s.
//

import SwiftUI
import AVKit

struct global {
     static var defaultTimeRemaining: CGFloat = 1200
}
let lineWith: CGFloat = 30
let radius: CGFloat = 50

struct ContentView: View {
    
    @State var isActive = false
    @State var audioPlayer: AVAudioPlayer!
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var timeRemaining: CGFloat = global.defaultTimeRemaining

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func timePadding(time: Int) -> String {
        if time < 10 {
            return "0\(time)"
        } else {
            return "\(time)"
        }
    }
    
    func timeChange(minutes: Int, seconds: Int) -> Void {
        if Int(minutes) != 20 || Int(seconds) != 0 {
            global.defaultTimeRemaining = (CGFloat) ((minutes * 60) + seconds)
        } else {
            global.defaultTimeRemaining = 1200
        }
    }
    
    var body: some View {
            
        VStack(spacing: 30) {
            HStack(alignment: .center) {
                Text("Minutes:")
                    .font(.callout)
                    .bold()
                TextField("Enter minutes...", value: $minutes, formatter: NumberFormatter()).textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Seconds:")
                    .font(.callout)
                    .bold()
                TextField("Enter seconds...", value: $seconds, formatter: NumberFormatter()).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    timeChange(minutes: minutes, seconds: seconds)
                    timeRemaining = global.defaultTimeRemaining
                }) {
                    Text("Change Time")
                }
            }.padding()
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2),
                            style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                Circle()
                    .trim(from: 0, to: 1 - (global.defaultTimeRemaining - timeRemaining) / global.defaultTimeRemaining)
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
                        while self.audioPlayer.isPlaying {
                            isActive = false
                        }
                        timeRemaining = global.defaultTimeRemaining
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

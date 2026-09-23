//
//  BottomBar.swift
//  100LinesOfCode
//
//  Created by Luca Rocchi on 29/11/22.
//

import Foundation
import SwiftUI
import AudioKit
import AudioKitUI
import AudioToolbox
import Controls

struct LoopBar:View {
    @Binding var isPlaying:Bool
    @EnvironmentObject var mtSequencer: MTSequencer
    @State private var loopLength = 16
    @State private var loopStart = 0

    var body: some View {
        HStack{
            Button() {
                loopStart = mtSequencer.beat
                mtSequencer.loopStart = Double(loopStart);
                mtSequencer.loopActive = true
            } label: {
                Text("TAP").font(.headline)
            }.frame(width: 60).buttonStyle(.borderedProminent)
          
         
            Spacer()
            
            VStack(alignment: .center){
                 //Text("\(Int(mtSequencer.loopStart))").font(.headline)
                
                Picker(selection: $loopStart,label:Text("START")) {
                    ForEach(0..<Int(mtSequencer.originalLength),id:\.self) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(.automatic) .onChange(of: loopStart) {
                    mtSequencer.loopStart = Double(loopStart)
                    mtSequencer.loopChanged()
                    //NotificationCenter.default.post(name: Notification.Name.init("loopstart_changed"),object: nil, userInfo: [:])
                }
                Text("LOOP START").font(.caption)
             
            }.frame(width: 70)
            
            Button() {
                //let isPlaying = mtSequencer.sequencer.isPlaying
                isPlaying.toggle()
                if isPlaying {
                    mtSequencer.play()
                } else {
                    mtSequencer.stop()
                }
            } label: {
                //let isPlaying = mtSequencer.sequencer.isPlaying
            
                if !isPlaying {
                    Image(systemName: "play.circle")
                        .modifier(PlayerButton())
                        .frame(width: 50)
                        //.foregroundColor(Color(uiColor: .label))
                    
                }else{
                    Image(systemName: "pause.circle")
                        .modifier(PlayerButton())
                        .frame(width: 50)
                        //.foregroundColor(Color(uiColor: .label))
                }
            }
            
            
            VStack(alignment: .center){
                //Text("\(Int(mtSequencer.loopLength))").font(.headline)
                
                Picker(selection: $loopLength,label:Text("LENGTH")) {
                    ForEach([8,16,32],id:\.self) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(.automatic) .onChange(of: loopLength) { 
                    mtSequencer.loopLength = Double(loopLength)
                    mtSequencer.loopChanged()
                    //NotificationCenter.default.post(name: Notification.Name.init("looplength_changed"),object: nil, userInfo: [:])
                }
                Text("LOOP LENGTH").font(.caption)
             
            }.frame(width: 70)
            
            Spacer()
            
            Button() {
            
            } label: {
                Text("").font(.headline)
            }.frame(width: 80).buttonStyle(.borderedProminent)
            /*VStack(){
                if let ts = mtSequencer.sequencer.getTimeSignature(at: 0){
                    
                    //Text("SIGN.").font(.subheadline)
                    //sequencer.sequencer.currentPosition
                    Text(String(format: "%d/4", ts.topValue)) .font(.title)
                }
            }*/
        } 
        
    }
    
}

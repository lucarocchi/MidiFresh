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

struct BottomBar:View {
    @Binding var isPlaying:Bool
    @Binding var showLoop:Bool
    @EnvironmentObject var mtSequencer: MTSequencer
    @State var showInfo:Bool
    
    var body: some View {
        HStack{
            
            Button() {
                 showInfo = true
            } label: {
                Text("INFO")//.font(.headline)
            }.buttonStyle(.bordered)
            
            
            
            /*VStack(){
                Text("TEMPO").font(.caption)
                  SmallKnob(value: $mtSequencer.tempo,range: Float(5)...Float(240)).frame(width: 50,height: 50)
               
                Text(String(format: "%.1f", mtSequencer.tempo)) .font(.headline)
            }*/
            Spacer()
            
            Button() {
                mtSequencer.backward()
            } label: {
                Image(systemName: "gobackward.10")
                    .modifier(PlayerButton())
                  
                    .frame(width: 50)
                    //.foregroundColor(Color(uiColor: .label))
            }
            
            
            Button() {
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
            
            
            Button() {
                mtSequencer.forward()
            
            
            } label: {
                Image(systemName: "goforward.10")
                    .modifier(PlayerButton())
                    .frame(width: 50)
                    //.foregroundColor(Color(uiColor: .label))
            }
            
            Spacer()
           
            Button() {
                //print(DisplayLink.sharedInstance.beat)
                mtSequencer.loopMode = true
                showLoop = true
            } label: {
                Text("LOOP")//.font(.headline)
            }.buttonStyle(.bordered)
          
            
        }.sheet(isPresented: self.$showInfo){
            InfoView()
        }
        
    }
    
}

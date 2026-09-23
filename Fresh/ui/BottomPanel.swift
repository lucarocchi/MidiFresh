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

struct BottomPanel:View {
    @Binding var isPlaying:Bool
    @EnvironmentObject var mtSequencer: MTSequencer
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack{
            if (isPlaying && scenePhase == .active){
                FFTView(mtSequencer.mixer).frame(maxHeight: 60, alignment: .center)
                //NodeOutputView(mtSequencer.mixer,color: Color.green).frame(maxHeight: 60, alignment: .center)
            }else{
                EmptyView()
                //Rectangle().frame(maxHeight: 60, alignment: .center).background(Color.black).foregroundColor(Color.black)
            }
            
          
             HStack(){
                 if mtSequencer.sequencer.length.beats > 0 {
                     let ts0 = Float(mtSequencer.elapsedBeats * 60)/mtSequencer.tempo
                     let minutes = Int(ts0) / 60
                     let seconds = Int(ts0) % 60
                     Text(String(String(format: "%.02d:%02d", minutes,seconds))).font(.headline).monospaced()
                     //Text(String(String(format: "%.03d", Int(mtSequencer.elapsedTime)))).font(.caption)
                     Slider(
                        value: $mtSequencer.elapsedBeats,
                        in: 0...mtSequencer.sequencer.length.beats,
                        step: 1,
                        onEditingChanged: { editing in
                            if !mtSequencer.loopMode {
                                mtSequencer.sequencer.setTime(mtSequencer.elapsedBeats)
                            }
                        }
                     )
                     let ls0 = Float(mtSequencer.sequencer.length.beats * 60)/mtSequencer.tempo
                     
                     let minutes2 = Int(ls0) / 60
                     let seconds2 = Int(ls0) % 60
                     
                     //Text(String(String(format: "%.03d", Int(mtSequencer.length)))).font(.caption)
                     Text(String(String(format: "%.02d:%02d", minutes2,seconds2))).font(.headline).monospaced()
                 }
            }
           
     
            
            
            //SmallKnob(value: Double(tempo))
        }.padding()
            .modifier(PanelColor())
            
    }
    
}

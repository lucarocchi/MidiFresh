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

struct LoopPanel:View {
    @EnvironmentObject var mtSequencer: MTSequencer
    @Environment(\.scenePhase) var scenePhase
    
    @State private var loopLength = 16
    @State private var loopStart:Float = 0
    @Binding var isPlaying:Bool
    
    
    var body: some View {
        
        NavigationView {
            List {
                Section() {
                    VStack(){
                        HStack(){
                            
                            Toggle("Active", isOn: $mtSequencer.loopActive)
                                .onChange(of: mtSequencer.loopActive) { 
                                    if mtSequencer.loopActive {
                                        mtSequencer.stop()
                                        mtSequencer.sequencer.setTime(0)
                                        mtSequencer.setLoop()
                                        mtSequencer.play()
                                    }else{
                                        mtSequencer.undoLoop()
                                        mtSequencer.stop()
                                    }
                                }
                            
                        }
                        
                        
                    }
                    
                    
                    Group(){
                        VStack(alignment: .leading){
                            
                            Text("loop start at bar").font(.headline)
                            HStack{
                                
                                Button() {
                                    if loopStart >= 1 {
                                        loopStart = loopStart - 1
                                        mtSequencer.loopStart = Double(loopStart);
                                        mtSequencer.loopChanged()
                                        
                                    }
                                    //mtSequencer.loopActive = true
                                } label: {
                                    Image(systemName: "minus.circle.fill").font(.headline)
                                }.frame(width: 30).buttonStyle(.bordered)
                                    .padding(5)
                                
                                Slider(
                                    value: $loopStart,
                                    in: 0...Float(mtSequencer.originalLength),
                                    step: 1,
                                    onEditingChanged: { editing in
                                        mtSequencer.loopStart = Double(loopStart)
                                        mtSequencer.loopChanged()
                                    }
                                )
                                
                                
                                Button() {
                                    if loopStart < mtSequencer.originalLength {
                                        loopStart = loopStart + 1
                                        mtSequencer.loopStart = Double(loopStart);
                                        mtSequencer.loopChanged()
                                        
                                    }
                                    //mtSequencer.loopActive = true
                                } label: {
                                    Image(systemName: "plus.circle.fill").font(.headline)
                                }.frame(width: 30).buttonStyle(.bordered)
                                    .padding(5)
                                    //.monospaced()
                            }
                            
                            Text("BAR \(String(format: "%d", Int(loopStart)))").font(.caption)
                         
                            HStack(alignment: .center){
                                Button {
                                    loopStart = Float(mtSequencer.beat)
                                    mtSequencer.loopStart = Double(loopStart);
                                    mtSequencer.loopActive = true
                                    mtSequencer.loopChanged()
                                } label: {
                                    Text("TAP").font(.headline).padding(20)
                                }.buttonStyle(.borderedProminent)
                            }.frame(maxWidth: .infinity)
                            
                        }
                        VStack(alignment: .leading){
                            Picker(selection: $loopLength,label:Text("loop length in beats").font(.headline)) {
                                ForEach([8,16,32],id:\.self) { number in
                                    Text("\(number)")
                                }
                            }.pickerStyle(.automatic) .onChange(of: loopLength) { 
                                mtSequencer.loopLength = Double(loopLength)
                                mtSequencer.loopChanged()
                            }
                            
                        }
                        
                        VStack(){
                            let rows = Int(mtSequencer.loopLength / 8)
                            ForEach(0..<rows,id: \.self) { x in
                                HStack(){
                                    ForEach(0..<8) { y in
                                        SequencerLed(id: y + (x * 8))
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading){
                            let elapsedBeats = Int(mtSequencer.elapsedBeats)
                            
                            Slider(
                                value: $mtSequencer.elapsedBeats,
                                in: 0...mtSequencer.sequencer.length.beats,
                                step: 1,
                                onEditingChanged: { editing in
                                    //mtSequencer.sequencer.setTime(mtSequencer.elapsedBeats)
                                }
                            )
                            Text("BEAT \(String(format: "%d",elapsedBeats+1))").font(.caption)
                            
                        }
                    }
                    //SmallKnob(value: Double(tempo))
                    //LoopBar(isPlaying: $isPlaying)
                }.padding()
                //.modifier(PanelColor())
                    .frame(maxHeight:nil)
                    .navigationTitle("Loop editor")
                    .onAppear(){
                    }
                    .onDisappear(){
                        if !mtSequencer.loopActive {
                            mtSequencer.loopMode = false
                            mtSequencer.undoLoop()
                        }
                    }
                
            }
            
            
        }
    }
    
}


/*Button() {
 //print(mtSequencer.beat)
 } label: {
 if let ts = mtSequencer.sequencer.getTimeSignature(at: 0){
 //Text("SIGN.").font(.subheadline)
 //sequencer.sequencer.currentPosition
 Text(String(format: "%d/4", ts.topValue)) //.font(.title)
 }
 }*/

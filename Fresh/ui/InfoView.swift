//
//  InfoView.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 28/01/23.
//

import SwiftUI
import AudioToolbox

struct InfoView: View {
    @EnvironmentObject var mtSequencer: MTSequencer
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationView {
            List {
                
                Section(header: Text("BPM").font(.headline).bold()) {
                    Group(){
                        
                        VStack(alignment: .leading){
                            
                            Text("beats per minute").font(.headline)
                            HStack{
                                Button() {
                                    if mtSequencer.tempo > 50 {
                                        mtSequencer.tempo = mtSequencer.tempo - 1
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill").font(.headline)
                                }.frame(width: 30).buttonStyle(.bordered)
                                    .padding(5)
                          
                                Slider(
                                    value: $mtSequencer.tempo,
                                    in: 50...240,
                                    step: 1,
                                    onEditingChanged: { editing in
                                        
                                    }
                                )
                                Button() {
                                    if mtSequencer.tempo < 240 {
                                        mtSequencer.tempo = mtSequencer.tempo + 1
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill").font(.headline)
                                }.frame(width: 30).buttonStyle(.bordered)
                                    .padding(5)
                          
                            }
                            Text("\(String(format: "%.03d", Int(mtSequencer.tempo)))").font(.caption)
                        
                            /*Button() {
                                //print(mtSequencer.beat)
                            } label: {
                                if let ts = mtSequencer.sequencer.getTimeSignature(at: 0){
                                    //Text("SIGN.").font(.subheadline)
                                    //sequencer.sequencer.currentPosition
                                    Text(String(format: "%d/4", ts.topValue)) //.font(.title)
                                }
                            }*/
                        }
                    }
                }
                
                if let sequence = mtSequencer.sequencer.sequence {
                    if let dict =  MusicSequenceGetInfoDictionary(sequence) as? [String:Any] {
                        let keys = dict.keys.sorted() as [String]
                        Section(header: Text("Info").font(.headline).bold()) {
                            Group(){
                                ForEach(keys,id: \.self ) { key in
                                    VStack(alignment: .leading){
                                        Text(key).font(.headline)
                                        if let number = dict[key]! as? Double {
                                            let s = String(format:"%.02f",number)
                                            Text(s)  .font(.subheadline)
                                    
                                        }else{
                                            Text(String(describing: dict[key]!))  .font(.subheadline)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                
            }
            .frame(maxHeight:nil)
            .navigationTitle("Midifile info")
        }
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

//
//  MusicTrackEditor.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 21/01/23.
//

import SwiftUI
import Controls

struct MusicTrackEditor: View {
    @Binding var track:MTSequencerTrack
    @State private var showEditor = false
    @EnvironmentObject var mtSequencer: MTSequencer
    
    var body: some View {
        List(){
            VStack(alignment: .leading){
                Text("Volume").font(.headline)
                
                HStack(alignment:.center){
                    Button() {
                        if track.volume > 0 {
                            track.volume = track.volume - 0.1
                            track.setTrackVolume(volume: track.volume)
                            track.getMIDIVolumeController()
                   
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill").font(.headline)
                    }.frame(width: 30).buttonStyle(.bordered)
                        .padding(5)
                    
                    Slider(
                        value: $track.volume,
                        in: 0.0...1,
                        step: 0.1,
                        onEditingChanged: { editing in
                            print("Volume onEditingChanged \(editing)")
                            if !editing {
                                track.setTrackVolume(volume: track.volume)
                                track.getMIDIVolumeController()
                            }
                        }
                    ).padding()
                    
                    Button() {
                        if track.volume < 1 {
                            track.volume = track.volume + 0.1
                            track.setTrackVolume(volume: track.volume)
                            track.getMIDIVolumeController()
                   
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.headline)
                    }.frame(width: 30).buttonStyle(.bordered)
                        .padding(5)
                    
                }.frame(maxWidth: .infinity , alignment: .leading)
                
                Text("Value \(String(format: "%.2f", track.volume))").font(.subheadline)
                
                /*Button {
                    showEditor.toggle()
                } label: {
                    Text("View Volume Controllers").font(.headline)
                }.frame(maxWidth: 300,maxHeight: 60 , alignment: .center)
                    .buttonStyle(.bordered)
                 */
                
            }
            VStack(alignment: .leading){
                Text("Pan").font(.headline)
                
                HStack(alignment:.center){
                    
                    Button() {
                        if track.pan > -1 {
                            track.pan = track.pan - 0.1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill").font(.headline)
                    }.frame(width: 30).buttonStyle(.bordered)
                        .padding(5)
                    
                    SmallKnob(value: $track.pan,range: Float(-1)...Float(1))
                        .onChange(of: track.pan) {
                        }
                        .frame(width: 100,height: 100)
                    
                    
                    Button() {
                        if track.pan < 1 {
                            track.pan = track.pan + 0.1
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.headline)
                    }.frame(width: 30).buttonStyle(.bordered)
                        .padding(5)
                }.frame(maxWidth: .infinity , alignment: .center)
                
                Text("Value \(String(format: "%.2f", track.pan))").font(.subheadline)
                
            }
            
        }
        .frame(maxHeight:nil)
        .navigationTitle(track.name)
        .onAppear(){
            track.getMIDIVolumeController()
        }.sheet(isPresented: self.$showEditor){
            ListControllers(track: $track)
        }
        
        Button {
            mtSequencer.saveToFile()
        } label: {
            Text("Save a file copy").font(.headline)
        }.frame(width: 300,height: 60,alignment: .center)
            .buttonStyle(.borderedProminent)
    }
    
}



//
//  GridView.swift
//  Landmarks
//
//  Created by Luca Rocchi on 07/07/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
import AudioKitUI

struct DrumkitView:  View {
    @EnvironmentObject var mtSequencer: MTSequencer
    @State private var showDocumentPicker = false
    @State private var selectedKey:Int = 0
    var body: some View {
        
        List(mtSequencer.drumkit.drumSamples)  { sample in
            let key = sample.midiNote
            HStack{
                SampleView(sample: sample)
                
                Spacer()
                if let _ = sample.url {
                    Button {
                        selectedKey = Int(key)
                    } label: {
                        let icon = "play.fill"
                        Image(systemName: icon)
                            .imageScale(.large)
                    }
                }
                
                Button {
                    selectedKey = Int(key)
                    showDocumentPicker.toggle()
                } label: {
                    let icon = "waveform.badge.plus"
                    Image(systemName: icon)
                        .imageScale(.large)
                }
              
            }.navigationTitle("Drumkit")
        }.sheet(isPresented: self.$showDocumentPicker){
#if os(iOS)
            DocumentPicker(ext:"wav")
#else
            EmptyView()
#endif
        }   .onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("documentAvailable")))
        { obj in
            if let userInfo = obj.userInfo, let url = userInfo["url"] as? URL,let type = userInfo["type"] as? String {
                //print(selectedKey)
                if type.lowercased() != "wav" {
                    return
                }
                do {
                    let fileContent = try Data(contentsOf: url)
                    
                    let _ = WavFile(data: fileContent)
                }catch let error {
                    print (error.localizedDescription)
                }
              
                if let sample = mtSequencer.drumkit.getSampleAtKey(key: selectedKey){
                    mtSequencer.drumkit.setAudioFile(sample,url: url)
                    
                }
            }
        }.onAppear(){
            mtSequencer.drumkit.load() 
        }
    }
}

struct SampleView : View {
    @ObservedObject var sample:Sample
    var body: some View {
        let key = sample.midiNote
        let name = MusicModel.shared.getNoteNames(key: Int(key))
        
        
        VStack(alignment: .leading){
            Text(sample.name).font(.headline)
            HStack() {
                Text("\(key)")
                Text(name)
            }
            if let url = sample.url {
                VStack(alignment: .leading){
                    Text(url.lastPathComponent).font(.caption)
                    AudioFileWaveform(url: url)
                }
            }
        }
    }
}

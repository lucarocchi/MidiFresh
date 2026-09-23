//
//  Drumkit.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 08/03/23.
//

import Foundation
import SwiftUI
import AudioKit
import AudioToolbox

class Drumkit: ObservableObject {
    @Published var drumSamples: [Sample] = []
    
    var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var name = "drumkit"
    //let drums = AppleSampler()
    //let engine = AudioEngine()
    var loaded = false
    init() {
        let _ = GM1SoundSet.PercussionKeyMap.sorted(by: <).map{
            let sample = Sample($0.value, note: Int($0.key))
            drumSamples.append(sample)
        }
        //print(drumSamples)
        //loadFromFile()
    }
    
    func getSampleAtKey(key : Int) -> Sample? {
        let samples = drumSamples.filter{
            $0.midiNote == key
        }
        if samples.count == 1 {
            let sample = samples[0]
            return sample
        }
        return nil
    }
    
    func saveToFile(){
        let encoder = JSONEncoder()
        var samples:[Sample] = []
        let _ =  drumSamples.map{
            if $0.filename != "" {
                samples.append($0)
            }
        }
        if let encoded = try? encoder.encode(samples) {
            
            var fileURL = documentDirectory.appendingPathComponent(name)
            fileURL = fileURL.appendingPathExtension("json")
            try? encoded.write(to: fileURL, options: [.atomicWrite])
            
            
            // save `encoded` somewhere
        }
    }
    
    func loadFromFile() -> [Sample] {
        var fileURL = documentDirectory.appendingPathComponent(name)
        fileURL = fileURL.appendingPathExtension("json")
        if let data = try? Data(contentsOf: fileURL) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Sample].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    func setAudioFile(_ sample :Sample,  url:URL){
        sample.setAudioFile(url)
        saveToFile()
    }
    
    func loadAudioFiles(){
        let _ = drumSamples.map{
            $0.filename = $0.filename
        }
    }
    
    func initSampler(sampler:AppleSampler){
        do {
            let files = drumSamples.filter{
                $0.audioFile != nil
            }.map {
                $0.audioFile!
            }
            try sampler.loadAudioFiles(files)

        } catch {
            Log("Files Didn't Load")
        }
        loaded = true
    }
    
    func load(){
        if !loaded {
            let samples = loadFromFile()
            let _ = samples.map{
                let sample = getSampleAtKey(key: $0.midiNote)
                sample?.filename = $0.filename
            }
            //initSampler()
            self.loaded = true
        }
   
    }
}

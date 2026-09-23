//
//  DisplayLink.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 21/12/22.
//

// DisplayLink.swift
import SwiftUI

class DisplayLink: NSObject, ObservableObject {
    @Published var frameDuration: CFTimeInterval = 0
    @Published var frameChange: Bool = false
    //var beat = 0
    static let sharedInstance: DisplayLink = DisplayLink()
    
    func start() {
        let displaylink = CADisplayLink(target: self, selector: #selector(frame))
        displaylink.add(to: .current, forMode: RunLoop.Mode.default)
    }
    
    @objc func frame(displaylink: CADisplayLink) {
        /*
        //frameDuration = displaylink.targetTimestamp - displaylink.timestamp
        //frameChange.toggle()
        let seq = MTSequencer.sharedInstance
        let beats = MTSequencer.sharedInstance.sequencer.currentPosition.beats
        beat = Int(beats)
        //print (displaylink.timestamp)
        //print (beats)
        
        seq.elapsedBeats = Double(Int(seq.sequencer.currentPosition.beats))
        if seq.loopActive {
            seq.elapsedBeats = Double(Int(seq.elapsedBeats) % Int(seq.loopLength))
            //seq.elapsedBeats = seq.elapsedBeats + seq.loopStart
        }
        if seq.scenePhase != .active {
            DispatchQueue.main.async {
                seq.nowPlaying.update()
            }
        }
         */
   }
    
}

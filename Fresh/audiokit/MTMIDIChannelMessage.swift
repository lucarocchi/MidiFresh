//
//  MTMIDIChannelMessage.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 22/01/23.
//

import Foundation
import AudioKit
import AudioToolbox
import AVFoundation

struct MTMIDIChannelMessage:Hashable,Identifiable{
  
    var time:MusicTimeStamp
    var msg:MIDIChannelMessage
    let id = UUID()
    static func == (lhs: MTMIDIChannelMessage, rhs: MTMIDIChannelMessage) -> Bool {
          return lhs.time == rhs.time
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
}

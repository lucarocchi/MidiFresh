//
//  SequencerLed.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 28/12/22.
//

import SwiftUI

struct SequencerLed: Identifiable, View {
    @EnvironmentObject var sequencer: MTSequencer
    var id: Int
    //@State var isActive = false
    var body: some View {
        let isActive = id == Int(sequencer.elapsedBeats)
        Rectangle().fill(isActive ? Color.orange : Color.orange.opacity(0.4))
            .border(.secondary)
            .frame(width: 30,height: 15)
            //.opacity(0.4)
            
    }
}

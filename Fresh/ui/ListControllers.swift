//
//  MusicTrackEditor.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 21/01/23.
//

import SwiftUI
import Controls

struct ListControllers: View {
    @Binding var track:MTSequencerTrack
    var body: some View {
        NavigationView {
            List(track.CCVolumes) {  volume in
                HStack(alignment:.center){
                    Text("\(volume.time)")
                    Text("\(volume.msg.data1)")
                    Text("\(volume.msg.data2)")
                }.frame(maxWidth: .infinity , alignment: .leading)
            }
            .frame(maxHeight:nil)
            .navigationTitle("Controller messages")
            .onAppear(){
            }
        }
        
    }
    
}


/*
 //https://developer.apple.com/documentation/audiotoolbox/cabarbeattime?changes=l_3_8
 //https://gist.github.com/armadsen/0164408942aaa30e5cf2599bdcbe8b88
 - (CABarBeatTime)barBeatTimeForTimeStamp:(MusicTimeStamp)timeStamp error:(NSError **)error
 {
     error = error ?: &(NSError *__autoreleasing){ nil };
     UInt32 timeResolution = 0;
     UInt32 propertyLength = 0;
     OSStatus err = MusicTrackGetProperty(self.tempoTrack.musicTrack,
                                          kSequenceTrackProperty_TimeResolution,
                                          NULL,
                                          &propertyLength);
     if (err != noErr) {
         *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
         return (CABarBeatTime){0};
     }
     err = MusicTrackGetProperty(self.tempoTrack.musicTrack,
                           kSequenceTrackProperty_TimeResolution,
                           &timeResolution,
                           &propertyLength);
     if (err != noErr) {
         *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
         return (CABarBeatTime){0};
     }
     
     CABarBeatTime barBeatTime = {0};
     err = MusicSequenceBeatsToBarBeatTime(self.musicSequence, timeStamp, timeResolution, &barBeatTime);
     if (err != noErr) {
         *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:err userInfo:nil];
         return (CABarBeatTime){0};
     }
     return barBeatTime;
 }

 */

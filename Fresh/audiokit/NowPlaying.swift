//
//  NowPlaying.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 07/12/22.
//

import Foundation
import MediaPlayer

class NowPlaying : NSObject {
#if os(iOS)
    var nowPlayingInfo:[String:Any]=[:]
    var mpRemoteCommandCenter = MPRemoteCommandCenter.shared()
    
    override init() {
        super.init()
    }
    
    func setupRemote(){
        self.mpRemoteCommandCenter = MPRemoteCommandCenter.shared()
        self.mpRemoteCommandCenter.playCommand.addTarget(self, action: #selector(remotePlay))
        self.mpRemoteCommandCenter.pauseCommand.addTarget(self, action: #selector(remotePause))
        self.mpRemoteCommandCenter.skipForwardCommand.addTarget(self, action: #selector(remoteNextTrack))
        self.mpRemoteCommandCenter.skipBackwardCommand.addTarget(self, action: #selector(remotePreviousTrack))
    }
    
    
    @objc func remotePlay() -> MPRemoteCommandHandlerStatus{
        let mtSequencer = MTSequencer.sharedInstance
        mtSequencer.sequencer.play()
        return MPRemoteCommandHandlerStatus.success
    }
    @objc func remotePause() -> MPRemoteCommandHandlerStatus{
        let mtSequencer = MTSequencer.sharedInstance
        mtSequencer.sequencer.stop()
        return MPRemoteCommandHandlerStatus.success
    }
    @objc func remoteNextTrack() -> MPRemoteCommandHandlerStatus{
        let mtSequencer = MTSequencer.sharedInstance
        mtSequencer.forward()
        return MPRemoteCommandHandlerStatus.success
    }
    @objc func remotePreviousTrack() -> MPRemoteCommandHandlerStatus{
        let mtSequencer = MTSequencer.sharedInstance
        mtSequencer.backward()
        return MPRemoteCommandHandlerStatus.success
    }
    
    
    func update(){
        let mtSequencer = MTSequencer.sharedInstance
        let npic = MPNowPlayingInfoCenter.default()
        let title = mtSequencer.songName
        if let image = UIImage(named: "MidiTrackNP") {
            let size = CGSize(width: 60,height: 60)
            
            let albumArt = MPMediaItemArtwork(boundsSize:size) { sz in
                return image
            }
            
            let  time0 = Float(mtSequencer.elapsedBeats);
            let duration = Float(mtSequencer.sequencer.length.beats)
            
            nowPlayingInfo = [MPMediaItemPropertyArtist:"Midi file",
                               MPMediaItemPropertyTitle:title,
                          MPMediaItemPropertyAlbumTitle:"Midi file",
                      MPNowPlayingInfoPropertyMediaType:MPNowPlayingInfoMediaType.audio.rawValue,
                             MPMediaItemPropertyArtwork:albumArt
                              ,MPNowPlayingInfoPropertyElapsedPlaybackTime:time0,
                    MPMediaItemPropertyPlaybackDuration:duration]
            
            
            
            npic.nowPlayingInfo = nowPlayingInfo
        }
        
    }
    #endif
}

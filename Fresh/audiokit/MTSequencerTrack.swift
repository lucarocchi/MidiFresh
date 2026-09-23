//
//  MTSequencerTrack.swift
//  100LinesOfCode
//
//  Created by Luca Rocchi on 27/11/22.
//

import Foundation
import AudioKit
import AudioToolbox
import AVFoundation



class MTSequencerTrack: ObservableObject,Identifiable {
    static var mtSequencer:MTSequencer!
    
    var musicTrackManager:MusicTrackManager
    //var midiCallbackInstrument:MIDICallbackInstrument
    var midiCallbackInstrument = MIDICallbackInstrument()
    var appleSampler:AppleSampler?
    var note0 : UInt8?
    var channel0 : UInt8 = 0
    var patchNumber:UInt8 = 0
    var programChange:MIDIProgramChangeEvent?
    var name = "MidiTrack" 
    var originalContents:[MIDINoteData] = []
    var CCVolumes:[MTMIDIChannelMessage] = []
  
    var isDrumkit:Bool {
        get{
            return channel0 == 9
        }
    }
    @Published var volume:Float = 1.0 {
        didSet {
            if let sampler = appleSampler {
                sampler.volume = volume
            }
        }
    }
    
    @Published var pan:Float = 0.0 {
        didSet {
            if let sampler = appleSampler {
                sampler.pan = pan
            }
        }
    }
    
    init(_ track:MusicTrackManager) {
        musicTrackManager = track
         
        let seq = MTSequencerTrack.mtSequencer!
        
        setCallback()
        
        if let noteData = musicTrackManager.noteData {
            if noteData.isNotEmpty {
                let note = noteData[0]
                let data = note.data?.bindMemory(to: MIDINoteMessage.self, capacity: 1)
                
                if let channel = data?.pointee.channel,
                   let note = data?.pointee.note,
                   let _ = data?.pointee.velocity,
                   let _ = data?.pointee.duration
                {
                    appleSampler = AppleSampler()
                    note0 = note
                    channel0 = channel
                    if let pc = seq.channelProgramChange[channel0]{
                        patchNumber = pc.number
                        if (!seq.isMidifileFormat0()){
                            let patchName = GM1SoundSet.getPatchName(channel: channel,program: patchNumber)
                            name = patchName;
                            musicTrackManager.setTrackName(name);
                        }
                    }
                    if channel0 == 9 {
                        name = GM1SoundSet.getPatchName(channel: channel0,program: 0)
                        musicTrackManager.setTrackName(name);
                    }
                    loadSound()
                }
            }
            originalContents = track.getMIDINoteData()
        }
        
        print (CCVolumes)
    }
    
    func setTrackVolume(volume:Float){
        let v = volume * 127
        musicTrackManager.setMIDIVolumeController(volume: UInt8(v))
    }
    
    func getMIDIVolumeController(){
        CCVolumes = musicTrackManager.getMIDIVolumeController()
    }

    func loadSound(){
        let sm = SettingManager.sharedInstance
        //https://www.vogons.org/viewtopic.php?t=48207&start=460
        let kAUSampler_DefaultBankLSB = 0
        let kAUSampler_DefaultMelodicBankMSB = 0x79
        let kAUSampler_DefaultPercussionBankMSB = 0x78
        //let kAUSampler_DefaultPercussionBankMSB = 0x0
    
        let url = isDrumkit ? sm.drumkitSoundfont.Url : sm.gmSoundfont.Url
        let bankMSB = isDrumkit ? kAUSampler_DefaultPercussionBankMSB:kAUSampler_DefaultMelodicBankMSB
        let program = isDrumkit ? 0 : patchNumber
        print ("loadSoundBankInstrument \(String(describing: url))")
        
        /*if isDrumkit {
            MTSequencerTrack.mtSequencer.drumkit.initSampler(sampler: appleSampler!)
            return
        }*/
        
        if let url = url {
            do {
                try appleSampler?.samplerUnit.loadSoundBankInstrument(at: url, program: program, bankMSB: UInt8(bankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB))
            }catch {
                let url = sm.defGmSoundfont.Url!
                do{
                    try appleSampler?.samplerUnit.loadSoundBankInstrument(at: url, program: program, bankMSB: UInt8(bankMSB), bankLSB: UInt8(kAUSampler_DefaultBankLSB))
                }catch {
                    print ("ERROR loadSoundBankInstrument \(error)")
             
                }
                
            }
        }else{
            print ("URL ERROR loadSoundBankInstrument")
  
        }
    }
    
    func setMidiOut(){
        musicTrackManager.setMIDIOutput(midiCallbackInstrument.midiIn)
    }
    
    func setSolo(solo:Bool) {
        var soloStatus = solo
        let size:UInt32 = UInt32(MemoryLayout<Bool>.size)
        if let track = musicTrackManager.internalMusicTrack  {
            MusicTrackSetProperty(track, kSequenceTrackProperty_SoloStatus, &soloStatus, size )
        }
    }
    
    func setSoftLength(beat:Int) {
        var beat = beat
        var size:UInt32 = UInt32(MemoryLayout<Int>.size)
        if let track = musicTrackManager.internalMusicTrack  {
            let result = MusicTrackSetProperty(track, kSequenceTrackProperty_TrackLength, &beat, size )
            print ("kSequenceTrackProperty_TrackLength rc = \(result)")
            let result1 = MusicTrackGetProperty(track, kSequenceTrackProperty_TrackLength, &beat, &size )
            print ("kSequenceTrackProperty_TrackLength  = \(result1) \(beat)")
         }
    }
    
    func setOffset(beat:Int) {
        var beat = beat
        var size:UInt32 = UInt32(MemoryLayout<Int>.size)
        if let track = musicTrackManager.internalMusicTrack  {
            let result = MusicTrackSetProperty(track, kSequenceTrackProperty_OffsetTime, &beat, size )
            print ("setOffset rc = \(result)")
            let result1 = MusicTrackGetProperty(track, kSequenceTrackProperty_OffsetTime, &beat, &size )
            print ("getOffset rc = \(result1) \(beat)")
         }
    }
    
    
    func setMute(mute:Bool) {
        var muteStatus = mute
        let size:UInt32 = UInt32(MemoryLayout<Bool>.size)
        if let track = musicTrackManager.internalMusicTrack  {
            MusicTrackSetProperty(track, kSequenceTrackProperty_MuteStatus, &muteStatus, size )
        }
    }
    
    func getMute()-> Bool{
        var muteStatus = false
        var size:UInt32 = UInt32(MemoryLayout<Bool>.size)
        if let track = musicTrackManager.internalMusicTrack  {
            MusicTrackGetProperty(track, kSequenceTrackProperty_MuteStatus, &muteStatus, &size )
        }
        return muteStatus
    }
    
    func setCallback(){
        let midi_callback:MIDICallback = { status, byte1, byte2 in
            guard let instrument = self.appleSampler else {
                return
            }
            
            let seq = MTSequencerTrack.mtSequencer!
            seq.processMidiEvent(self,instrument:instrument, status: status, byte1: byte1, byte2: byte2)
        }
        midiCallbackInstrument.callback = midi_callback
        
    }
    
    func setLoop(loopStart:Double,loopLength:Double){
        let track = musicTrackManager
        
        // isolate the segment for looping and shift it to the start of the track
        let loopSegment = originalContents.filter { loopStart ..< (loopStart + loopLength) ~= $0.position.beats }
        let shiftedSegment = loopSegment.map { MIDINoteData(noteNumber: $0.noteNumber,
                                                            velocity: $0.velocity,
                                                            channel: $0.channel,
                                                            duration: $0.duration,
                                                            position: Duration(beats: $0.position.beats - loopStart))
        }
        
        // replace the track contents with the loop, and assert the looping behaviour
        track.replaceMIDINoteData(with: shiftedSegment)
    
    }
    
    func undoLoop(){
        // and to get back to the original:
        let track = musicTrackManager
        track.replaceMIDINoteData(with: originalContents)
    }
}

extension MusicTrackManager {
    func setTrackName (_ name : String){
        let data = [MIDIByte](name.utf8)
        
        
        let metaEventPtr = allocate(metaEventType: 3, data: data)
        defer { metaEventPtr.deallocate() }

        let result = MusicTrackNewMetaEvent(internalMusicTrack!, MusicTimeStamp(0), metaEventPtr)
        if result != 0 {
            Log("Unable to name Track")
        }
    }
    
    func allocate(metaEventType: MIDIByte, data: [MIDIByte]) -> UnsafeMutablePointer<MIDIMetaEvent> {
        let size = MemoryLayout<MIDIMetaEvent>.size + data.count
        let mem = UnsafeMutableRawPointer.allocate(byteCount: size,
                                                   alignment: MemoryLayout<Int8>.alignment)
        let ptr = mem.bindMemory(to: MIDIMetaEvent.self, capacity: 1)

        ptr.pointee.metaEventType = metaEventType
        ptr.pointee.dataLength = UInt32(data.count)

        withUnsafeMutablePointer(to: &ptr.pointee.data) { pointer in
            for i in 0 ..< data.count {
                pointer[i] = data[i]
            }
        }

        return ptr
    }

    public func setMIDIVolumeController(volume:UInt8)  {
        //https://developer.apple.com/documentation/audiotoolbox/1503101-musiceventiteratorseteventinfo
        
  
        guard let track = internalMusicTrack else {
            Log("internalMusicTrack does not exist")
            return
        }
        iterate(track) { iterator, eventTime, eventType, eventData, _, isReadyForNextEvent in
            guard eventType == kMusicEventType_MIDIChannelMessage else { return }
            let data = eventData?.bindMemory(to: MIDIChannelMessage.self, capacity: 1)

            guard let status = data?.pointee.status,
                  let data1 = data?.pointee.data1,
                  let data2 = data?.pointee.data2
            else {
                Log("Problem with raw midi channel message")
                return
            }
            
            let message = status>>4
            //let channel = status & 0x0F
            if (message == 0xb){ //CC
                if data1 == 0x7 { // volume
                    var controllerDetails = MIDIChannelMessage(status: status,
                                                               data1: data1,
                                                               data2: data2,
                                                               reserved:0)
                    
                    
                    controllerDetails.data2 = volume
                    let status: OSStatus = MusicEventIteratorSetEventInfo(iterator, eventType, &controllerDetails)
                    if status != OSStatus(noErr) {
                        Log("error reading midi data, read status: \(status)")
                    }
                    isReadyForNextEvent = false
                    
                }
            }
        }

    }

    
    func getMIDIVolumeController() -> [MTMIDIChannelMessage] {
        //https://developer.apple.com/documentation/audiotoolbox/1503101-musiceventiteratorseteventinfo
        
        var controllerData = [MTMIDIChannelMessage]()

        guard let track = internalMusicTrack else {
            Log("internalMusicTrack does not exist")
            return []
        }
        iterate(track) { iterator, eventTime, eventType, eventData, _, isReadyForNextEvent in
            guard eventType == kMusicEventType_MIDIChannelMessage else { return }
            let data = eventData?.bindMemory(to: MIDIChannelMessage.self, capacity: 1)

            guard let status = data?.pointee.status,
                  let data1 = data?.pointee.data1,
                  let data2 = data?.pointee.data2
            else {
                Log("Problem with raw midi channel message")
                return
            }
            
            let message = status>>4
            //let channel = status & 0x0F
            if (message == 0xb){ //CC
                if data1 == 0x7 { // volume
                    let controllerDetails = MIDIChannelMessage(status: status,
                                                               data1: data1,
                                                               data2: data2,
                                                               reserved:0)
                    let mtMessage = MTMIDIChannelMessage( time: eventTime, msg: controllerDetails)
                    controllerData.append(mtMessage)
                }
            }
        }

        return controllerData
    }
    
    func iterate(_ track: MusicTrack,
                                 midiEventHandler: (MusicEventIterator,
                                                    MusicTimeStamp,
                                                    MusicEventType,
                                                    UnsafeRawPointer?,
                                                    UInt32,
                                                    inout Bool) -> Void)
    {
        var tempIterator: MusicEventIterator?
        NewMusicEventIterator(track, &tempIterator)
        guard let iterator = tempIterator else {
            Log("Unable to create iterator")
            return
        }
        var eventTime = MusicTimeStamp(0)
        var eventType = MusicEventType()
        var eventData: UnsafeRawPointer?
        var eventDataSize: UInt32 = 0
        var hasNextEvent: DarwinBoolean = false
        var isReadyForNextEvent = true

        MusicEventIteratorHasCurrentEvent(iterator, &hasNextEvent)
        while hasNextEvent.boolValue {
            MusicEventIteratorGetEventInfo(iterator,
                                           &eventTime,
                                           &eventType,
                                           &eventData,
                                           &eventDataSize)

            midiEventHandler(iterator,
                             eventTime,
                             eventType,
                             eventData,
                             eventDataSize,
                             &isReadyForNextEvent)

            if isReadyForNextEvent {
                MusicEventIteratorNextEvent(iterator)
            }else{
                break
            }
            MusicEventIteratorHasCurrentEvent(iterator, &hasNextEvent)
        }
        DisposeMusicEventIterator(iterator)
    }


}

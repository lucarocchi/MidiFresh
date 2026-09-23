import SwiftUI
import AudioKit
import AudioToolbox


//https://itnext.io/add-a-now-playing-bar-with-swiftui-to-your-app-d515b03f05e3

//https://stackoverflow.com/questions/44908391/how-can-i-send-a-midi-poly-pressure-message-using-audiokit
//https://capps.tech/blog/read-files-with-documentpicker-in-swiftui
//https://developer.apple.com/documentation/audiotoolbox/music_player/1515456-music_track_properties
//http://www.music.mcgill.ca/~ich/classes/mumt306/StandardMIDIfileformat.html#BM1_1

class MTSequencer: ObservableObject {
    //let SF = "Korg_M1_General_Midi"
    //let SF = "Yamaha_XG_Sound_Set"
    //let SF = "GeneralUser_GS_SoftSynth"
    
    //let SF_EXT = ".sf2"
    //let SF = "Sounds/gs_instruments"
    //let SF_EXT = ".dls"
    
    static var _sharedInstance = MTSequencer()
    class var sharedInstance: MTSequencer {
        return _sharedInstance
    }
    
    var engine = AudioEngine()
    
    var instruments : [AppleSampler] = []
    //var midiHardware = MIDIHardwareListener.instance
    //var midiCallback = MIDICallbackInstrument()
    //var midi_callback:MIDICallback!
    
    @Published var mixer = Mixer()
    @Published var sequencer = AppleSequencer()

    //var channelInstruments:[MIDIChannel:AppleSampler] = [:]
    var channelProgramChange: [MIDIChannel:MIDIProgramChangeEvent] = [:]
    
    @Published var mtTracks = [MTSequencerTrack]()
    
    @Published var songName = "Untitled"
    @Published var tempo: Float = 120 {
        didSet {
            sequencer.setTempo(BPM(tempo))
        }
    }
    
    //@Published var length: MusicTimeStamp = 1
    @Published var elapsedBeats: MusicTimeStamp = 0 
    
    @Published var isPlaying = false
    var fileFormat:UInt = 0
    
    #if os(iOS)
    var nowPlaying=NowPlaying()
    #endif
    @Published var soundfonts:[Soundfont]=[]
    @Published var gmSoundfonts:[Soundfont]=[]
    @Published var drumkitSoundfonts:[Soundfont]=[]
    @Published var pianoSoundfonts:[Soundfont]=[]
    @Published var bassSoundfonts:[Soundfont]=[]
    @Published var guitarSoundfonts:[Soundfont]=[]

    
    var originalLength:Float = 16.0
    @Published var loopMode = false
    @Published var loopActive = false
    @Published var loopStart = 0.0
    @Published var loopLength = 16.0
    var beat = 0
 
    var scenePhase = ScenePhase.active
    var timer : Timer?
   
    @ObservedObject var drumkit = Drumkit()
    
    init() {
        
        MTSequencerTrack.mtSequencer = self
        
        loadRecentFile()
        #if os(iOS)
        nowPlaying.setupRemote()
        #endif
        
        let _ = Drumkit()
        //DisplayLink.sharedInstance.start()
    }
    
    func setLoop(){
        // keep track of the original track contents
        for track in mtTracks {
            track.setLoop(loopStart: loopStart, loopLength: loopLength)
        }
        sequencer.setLength(Duration(beats: loopLength))
        sequencer.enableLooping()
        sequencer.setLoopInfo(Duration(beats: loopLength), loopCount: 16)
   
    }

    func undoLoop(){
        // keep track of the original track contents
        for track in mtTracks {
            track.undoLoop()
        }
        sequencer.setLength(Duration(beats: Double(originalLength)))
        sequencer.disableLooping()
    }

    
    public func loadRecentFile(){
        let settings = SettingManager.sharedInstance
        if let data = settings.recentUrlData, let rurl = settings.recentUrl {
            loadFrom(data:data)
            
            if let url = URL(string: rurl){
                songName = url.lastPathComponent
                songName = songName.replacingOccurrences(of: "_", with: " ")
                songName = songName.replacingOccurrences(of: "-", with: " ")
                songName = songName.replacingOccurrences(of: ".mid", with: "")
                songName = songName.replacingOccurrences(of: ".MID", with: "")
           }
        }else{
            //let url = Bundle.main.url(forResource: "Sounds/Fresh", withExtension: ".mid")
            //if let url = url {
            //    loadFrom(url:url)
            //}
        }
        
    }
    
    public func processMidiEvent(_ track:MTSequencerTrack, instrument:AppleSampler,status:MIDIByte,byte1:MIDIByte,byte2:MIDIByte){
        
        let message = status>>4
        let channel = status & 0x0F
        
        if message == 9 { //Note On
            instrument.play(noteNumber: byte1, velocity: byte2, channel: channel)
        } else if message == 8 { //Note Off
            instrument.stop(noteNumber: byte1, channel: channel)
            
        } else if message == 0xe { //Pitch bend
            let b1 = byte1 & 0x7f
            var word = UInt16(b1);
            word = word << 8
            word = word | UInt16(byte2)
            //print ("pitch bend  \(byte1) \(byte2)")
            //print ("pitch bend  \(word) channel \(channel)")
            /*let x = MIDIWord(byte1)
             let y = MIDIWord(byte2) << 7
             let word = y + x
             */
            instrument.setPitchbend(amount: word, channel: channel)
        }else if (message == 0xb){ //CC
            if byte1 == 7 { // volume
                //https://www.vsl.co.at/community/posts/m305197findlastpost-A-Graph-of-MIDI-CC-vs-dB-for-Vol-and-Expr-Faders#post305470
                //1.   dB = 40*log(CCval/127)
                //2.   CCval = 127*(10^(dB/40))
                //print ("MIDI CC VOLUME  \(message) \(channel) \(byte1) \(byte2)")
                let db = byte2 > 0 ? 40*log(Float(byte2)/Float(127)) : 0
                //print ("db \(db)" )
                let normalized = Float(db + 90)/Float(90)
                //print ("normalized \(normalized)" )
                track.volume = normalized
            }
            if byte1 == 10 { // pan
                //https://www.vsl.co.at/community/posts/m305197findlastpost-A-Graph-of-MIDI-CC-vs-dB-for-Vol-and-Expr-Faders#post305470
                //1.   dB = 40*log(CCval/127)
                //2.   CCval = 127*(10^(dB/40))
                print ("MIDI CC PAN  \(message) \(channel) \(byte1) \(byte2)")
                
                let pan = Float(Float(byte2) - 64)/Float(64)
                
                //let normalized = Float(db + 90)/Float(100)
                print ("pan \(pan)" )
                track.pan = pan
            }
        }else{
            print ("MIDI MSG  \(message) \(channel) \(byte1) \(byte2)")
        }
        
        
    }
    /*func loadFrom(url:URL){
        print (url)
        songName = url.lastPathComponent
        sequencer = AppleSequencer(fromURL: url)
        //sequencer.loadMIDIFile(fromURL: url)
        prepareSong()
    }*/
    
    func loadFrom(data:Data){
        fileFormat = UInt(data[9])
        //sequencer = AppleSequencer(fromData: data)
        stop()
        sequencer = AppleSequencer()
        sequencer.loadMIDIFileEx(fromData: data)
        prepareSong()
    }
    
    func stop(){
        sequencer.stop()
        isPlaying = sequencer.isPlaying
        timerStop()
    }
    
    func play(){
        sequencer.play()
        isPlaying = sequencer.isPlaying
        timerStart()
    }
    
    func timerStart(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            //print("Timer fired!")
            
            let beats = self.sequencer.currentPosition.beats
            self.beat = Int(beats)
            //print (displaylink.timestamp)
            //print (beats)
            
            self.elapsedBeats = Double(Int(self.sequencer.currentPosition.beats))
            if self.loopActive {
                self.elapsedBeats = Double(Int(self.elapsedBeats) % Int(self.loopLength))
                //seq.elapsedBeats = seq.elapsedBeats + seq.loopStart
            }
#if os(iOS)
            if self.scenePhase != .active {
                if self.isPlaying {
                    DispatchQueue.main.async {
                        self.nowPlaying.update()
                        
                    }
                }
            }
#endif
        }
 
    }
    func timerStop(){
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
 
    func prepareSong(){
        engine.stop()
        engine = AudioEngine()
        
        mtTracks = []
        instruments = []
        //channelInstruments = [:]
        channelProgramChange = [:]
        prepareProgramChanges()
        prepareInstruments()
        
        mixer = Mixer(instruments)
        //reverb = Reverb(mix)
        engine.output = mixer
        //engine.rebuildGraph()
        tempo = Float(sequencer.getTempo(at: 0))
        //length = sequencer.length.beats
        try? engine.start()
        
        for track in mtTracks {
            track.setMidiOut()
            //track.musicTrackManager.setMIDIOutput(midiCallback.midiIn)
        }
        sequencer.preroll()
        
       
        
        originalLength = Float(sequencer.length.beats)
        print("originalLength \(originalLength)")
    
        //setLoop();
        //undoLoop()
    }
    
    func saveToFile (){
        let filename = songName + " - (copy).mid"
        sequencer.saveToFile(name: filename)
    }
    
    func loopChanged(){
        if (loopActive){
            undoLoop()
            setLoop()
        }
    }
    
    func isMidifileFormat0()->Bool {
        //return sequencer.tracks.count == 1 ;
        return false //fileFormat == 0 ;
    }
    
    func prepareProgramChanges(){
        for track in sequencer.tracks {
            if track.programChangeEvents.isNotEmpty {
                for pc in track.programChangeEvents {
                    if pc.channel != 9 {
                        channelProgramChange[pc.channel] = pc
                    }
                    //print ("ProgramChange  \(pc) ")
                    
                }
            }
        }
    }
    
    func prepareInstruments(){
        var dkTrackCount = 0
        for track in sequencer.tracks {
            let mtTrack = MTSequencerTrack(track)
            mtTracks.append(mtTrack)
            if mtTrack.isDrumkit {
                dkTrackCount = dkTrackCount+1
            }
            if let sampler = mtTrack.appleSampler {
                instruments.append(sampler)
            }
        }
        if mtTracks.count > 1 {
            
            var tempoTrack: MusicTrack?
            if let existingSequence = sequencer.sequence {
                MusicSequenceGetTempoTrack(existingSequence, &tempoTrack)
                if let tempoTrack = tempoTrack {
                    for track in mtTracks {
                        if track.musicTrackManager.initMusicTrack! == tempoTrack {
                            track.name = "Tempo Track"
                            track.musicTrackManager.setTrackName(track.name)
                            break;
                        }
                    }
                    
                    
                    /*
                     var index : UInt32 = 0
                     
                     let status:OSStatus = MusicSequenceGetTrackIndex(existingSequence, tempoTrack, &index);
                    if status == 0 {
                        let track = mtTracks[Int(index)]
                        track.name = "Tempo Track"
                        track.musicTrackManager.setTrackName(track.name)
                    }*/
                }
            }
          
        }
        if (dkTrackCount > 2){
            for track in mtTracks {
                if track.isDrumkit {
                    track.name = GM1SoundSet.getDrumkitName(note:track.note0!)
                    track.musicTrackManager.setTrackName(track.name)
                }
             }
        }
    }
    
    func forward(){
        var t0 = sequencer.currentPosition.beats + 8
        if t0 > sequencer.length.beats {
            t0 = sequencer.length.beats
        }
        sequencer.setTime(t0)
    }
    
    func backward(){
        var t0 = sequencer.currentPosition.beats - 8
        if t0 < 0 {
            t0 = 0
        }
        sequencer.setTime(t0)
    }
    
    func initSoundfont(){
        let ssff = soundfonts.filter { $0.found }
        gmSoundfonts = ssff.filter { $0.instrument == "GMIDI"}
        drumkitSoundfonts = ssff.filter{["GMIDI","Drum"].contains($0.instrument)}
        pianoSoundfonts = ssff.filter{$0.instrument == "Piano"}
        bassSoundfonts = ssff.filter{ $0.instrument == "Bass"}
        guitarSoundfonts = ssff.filter{$0.instrument == "Guitar"}

    }
    
    
    public func setOffset(_ beat: Int) {
        for track in mtTracks {
            track.setOffset(beat: beat)
        }
    }
    
    public func setSoftlength(_ beat: Int) {
        for track in mtTracks {
            track.setSoftLength(beat: beat)
        }
    }
}

extension AppleSequencer {
    /// Load a MIDI file given its data representation (removes old tracks, if present)
    ///
    func saveToFile(name:String){
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentDirectory.appendingPathComponent(name)
        
        if let existingSequence = sequence {
            let status: OSStatus = MusicSequenceFileCreate(existingSequence,fileURL as CFURL,.midiType,.eraseFile,0)
            if status != OSStatus(noErr) {
                Log("error reading midi data, read status: \(status)")
            }
        }
    }
    
    func seqToData() -> NSData {
        let data = genData()
        
        //debug()
        
        
        return data! as NSData
    }
    
    public func loadMIDIFileEx(fromData data: Data) {
        let fileFormat = UInt(data[9])
        
        removeTracksEx()
        if let existingSequence = sequence {
            let flag = fileFormat == 0 ? MusicSequenceLoadFlags.smf_ChannelsToTracks :MusicSequenceLoadFlags()
            let status: OSStatus = MusicSequenceFileLoadData(existingSequence, data as CFData,  .midiType, flag)
            if status != OSStatus(noErr) {
                Log("error reading midi data, read status: \(status)")
            }
        }
        
        initTracksEx()
        //print (seqToData())
    }
    
    func initTracksEx() {
        var count: UInt32 = 0
        if let existingSequence = sequence {
            MusicSequenceGetTrackCount(existingSequence, &count)
        }
        
        for i in 0 ..< count {
            var musicTrack: MusicTrack?
            if let existingSequence = sequence {
                MusicSequenceGetIndTrack(existingSequence, UInt32(i), &musicTrack)
            }
            if let existingMusicTrack = musicTrack {
                tracks.append(MusicTrackManager(musicTrack: existingMusicTrack, name: "InitializedTrack"))
            }
        }
        
        //if loopEnabled {
        //    enableLooping()
        //}
    }
    
    ///  Dispose of tracks associated with sequence
    func removeTracksEx() {
        if let existingSequence = sequence {
            var tempoTrack: MusicTrack?
            MusicSequenceGetTempoTrack(existingSequence, &tempoTrack)
            if let track = tempoTrack {
                MusicTrackClear(track, 0, length.musicTimeStamp)
                //clearTimeSignatureEvents(track)
                //clearTempoEvents(track)
            }
            
            for track in tracks {
                if let internalTrack = track.internalMusicTrack {
                    MusicSequenceDisposeTrack(existingSequence, internalTrack)
                }
            }
        }
        tracks.removeAll()
    }
    
    func reverse(){
        //https://stackoverflow.com/questions/55161566/how-to-set-a-loop-not-at-the-end-of-track-using-audiokit-sequencer
        if let existingSequence = sequence {
            MusicSequenceReverse(existingSequence)
        }
    }
}

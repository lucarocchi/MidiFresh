import SwiftUI
import AudioKit
import AudioKitUI
import Controls
import UniformTypeIdentifiers


//https://www.hackingwithswift.com/books/ios-swiftui/how-layout-works-in-swiftui
struct SequencerView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var mtSequencer: MTSequencer
    
    //@StateObject var mtSequencer:MTSequencer = MTSequencer.sharedInstance
    @State var elapsedTime = 0.0
    @State private var showingPicker = false
    @State private var showLoop = false

    @State private var showDocumentPicker = false
    //@State private var showSoundfontPicker = false
    
    @State private var fileContent  = Data()
    @State private var presentationDetent:PresentationDetent = .medium
    
    let network = NetworkAsync<[Soundfont]>()
    
    
    var body: some View {
        NavigationStack {
            VStack{
                //Text().font(.headline)
                ScrollView {
                    VStack(alignment: .leading) {
                        
                             ForEach(0..<mtSequencer.mtTracks.count,id: \.self ) { trackIndex in
                                
                                 NavigationLink {
                                     //let track = mtSequencer.mtTracks[trackIndex]
                                     MusicTrackEditor(track:$mtSequencer.mtTracks[trackIndex] )
                                 } label: {
                                    MusicTrackRow(track: mtSequencer.mtTracks[trackIndex],trackIndex: trackIndex, isPlaying: $mtSequencer.isPlaying)
                                 }
                                 
                            }
                        
                    }
                }
                BottomPanel(isPlaying: $mtSequencer.isPlaying)
                BottomBar(isPlaying: $mtSequencer.isPlaying,showLoop: $showLoop,showInfo: false) 
     
            }.padding() //.background(Color(.redZone))
#if os(iOS)
            //https://sarunw.com/posts/custom-navigation-bar-title-view-in-swiftui/
            //Text(mtSequencer.songName).font(.headline)
                .navigationBarTitle(mtSequencer.songName, displayMode: .inline)
#else
                .navigationTitle(mtSequencer.songName)
#endif

                .toolbar {
                  
                    ToolbarItem(placement: .automatic) {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large).onTapGesture {
#if os(iOS)
                                showDocumentPicker.toggle()
#else
                                openMidiFile()
#endif
                            }
                        
                    }
                }
                .sheet(isPresented: self.$showDocumentPicker){
#if os(iOS)
                    DocumentPicker(ext:"mid")
#else
                    EmptyView()
#endif
                }
                .sheet(isPresented: self.$showLoop){
                    LoopPanel(isPlaying: $mtSequencer.isPlaying)
                }
             /*.sheet(isPresented: self.$showingPicker){
             Spacer()
             .presentationDetents(undimmed: [.height(100),.medium,.large],largestUndimmed: .height(100),selection: $presentationDetent).interactiveDismissDisabled()
             //.presentationDetents([.height(200),.medium,.large])
             }*/
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("sf_changed")))
        { obj in
            self.mtSequencer.prepareSong()
            //if let userInfo = obj.userInfo, let info = userInfo["info"] {
            //   print(info)
            //}
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("documentAvailable")))
        { obj in
            if let userInfo = obj.userInfo, let url = userInfo["url"] as? URL,let type = userInfo["type"] as? String {
                //print(url)
                if type != "mid" {
                    return
                }
                do {
                    let fileContent = try Data(contentsOf: url)
                    let settings = SettingManager.sharedInstance
                    settings.recentUrl = url.absoluteString
                    settings.recentUrlData = fileContent
                    MTSequencer.sharedInstance.loadRecentFile()
                }catch let error {
                    print (error.localizedDescription)
                }
            }
        }
        .onAppear(){
            Task {
                //do {
                    let sm = SettingManager.sharedInstance
                    mtSequencer.soundfonts.removeAll()
                    mtSequencer.soundfonts.append(sm.defGmSoundfont)
                    if sm.defGmSoundfont != sm.defDrumkitSoundfont{
                        mtSequencer.soundfonts.append(sm.defDrumkitSoundfont)
                    }
                    /*let url = "https://www.laziomatica.com/audio/"
                    try await network.getData(url: url)
                    if let sf = network.result{
                        mtSequencer.soundfonts.append(contentsOf: sf)
                        mtSequencer.initSoundfont()
                    }*/
                     
                //} catch {
                //    print("Error", error)
                //}
            }
            mtSequencer.drumkit.load()
        }
        .onChange(of: scenePhase) { 
            self.mtSequencer.scenePhase = scenePhase
            if scenePhase == .active {
                print("Active")
            } else if scenePhase == .inactive {
                print("Inactive")
            } else if scenePhase == .background {
                print("Background")
            }
        }.onDisappear() {
            //self.mtSequencer.sequencer.stop()
            //self.mtSequencer.engine.stop()
        }.environmentObject(mtSequencer)
        
    }
    
    func openMidiFile(){
#if os(macOS)
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        let type = UTType(filenameExtension: "mid")
      
        panel.allowedContentTypes = [type!]
        if panel.runModal() == .OK {
            DispatchQueue.main.async  {
                guard let url = panel.url else {
                    return
                }
                
                do {
                    let fileContent = try Data(contentsOf: url)
                    let settings = SettingManager.sharedInstance
                    settings.recentUrl = url.absoluteString
                    settings.recentUrlData = fileContent
                    MTSequencer.sharedInstance.loadRecentFile()
                    
                    
                    
                }catch let error {
                    print (error.localizedDescription)
                }
            }
        }
    #endif
    }
}



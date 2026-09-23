import SwiftUI
import AudioKit
import AudioKitUI
import Controls

struct MusicTrackRow: View {
    @ObservedObject var track:MTSequencerTrack
    @Environment(\.scenePhase) var scenePhase
    
    var trackIndex:Int
    @Binding var isPlaying:Bool
    @State var isMute = false
    @State var isSolo = false
     
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let sampler = track.appleSampler {
                    if scenePhase == .active{ //isPlaying &&
                        VStack(alignment: .leading){
                            NodeOutputView(sampler,color: Color.orange).frame(maxWidth: 50,maxHeight: 50 , alignment: .center)
                        }
                    }else{
                        Rectangle().frame(maxWidth: 50,maxHeight: 50, alignment: .trailing).background(Color.black).foregroundColor(Color.black)
                    }
                }
                VStack(alignment: .leading){
                    Text("\(trackIndex+1) \(track.name)").font(.headline).foregroundStyle(.foreground).multilineTextAlignment(.leading).padding(2).frame(maxWidth: .infinity , alignment: .leading)
                    HStack(){
                        Text("ch. \(track.channel0)").font(.subheadline).multilineTextAlignment(.leading)
                        Button() {
                            isMute.toggle()
                            track.setMute(mute: isMute)
                        } label: {
                            Image(systemName: "speaker.slash.fill").foregroundColor(isMute ? .accentColor :.gray)
                        }.frame(maxWidth: 80 , alignment: .trailing)
                        
                        Button() {
                            isSolo.toggle()
                            track.setSolo(solo: isSolo)
                        } label: {
                            Image(systemName: "headphones").foregroundColor(isSolo ? .accentColor :.gray)
                        }.frame(maxWidth: 80 , alignment: .trailing)
                    }.padding(2)
                }
                //Spacer()
                
            }
            
            
        }.padding()
            .modifier(PanelColor())
            .cornerRadius(10)
            .frame(maxWidth: .infinity , alignment: .leading)
    }
}

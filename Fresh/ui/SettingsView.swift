

import SwiftUI
import StoreKit
import AudioKit
import CoreMIDI

struct SettingsView: View {
    @ObservedObject var settings = SettingManager()
    @EnvironmentObject var mtSequencer: MTSequencer
    
    var body: some View {
        NavigationStack {
            List {
                
                Section(header: Text("Instruments")
                    .font(.headline)
                    .bold()
                    //.foregroundColor(Color(uiColor: .label))
                ) {
                    Group(){
                        SoundFontPicker(soundfont: $settings.gmSoundfont, title: "General Midi", list: mtSequencer.gmSoundfonts)
                        SoundFontPicker(soundfont: $settings.drumkitSoundfont, title: "Drumkit", list: mtSequencer.drumkitSoundfonts)
                        SoundFontPicker(soundfont: $settings.pianoSoundfont, title: "Piano", list: mtSequencer.pianoSoundfonts)
                        SoundFontPicker(soundfont: $settings.bassSoundfont, title: "Bass", list: mtSequencer.bassSoundfonts)
                        SoundFontPicker(soundfont: $settings.guitarSoundfont, title: "Guitar", list: mtSequencer.guitarSoundfonts)
                     }
                    
                }
                /*Section(){
                    Group(){
                        NavigationLink("Download more", destination: ListSoundFontView()
                        )
                        
                    }
                }*/
                
            }
            .navigationTitle("Settings")
            //.navigationBarTitle("Settings", displayMode: .inline)
        }
        //.background(Color(uiColor: .systemGroupedBackground))
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(settings: Settings())
//    }
//}


struct SoundFontPicker:View {
    @Binding var soundfont:Soundfont
    var title:String
    var list:[Soundfont]
    //@EnvironmentObject var mtSequencer: MTSequencer
    
    var body: some View {
        //let sf = mtSequencer.soundfonts
       
        Picker(selection: $soundfont, label: Text(title).tag("").font(.headline)) {
            ForEach(list,id: \.self) { soundfont  in
                Text(soundfont.namePart).font(.subheadline)//.foregroundColor(Color(uiColor: .label))
            }
            
        }.pickerStyle(.automatic) .onChange(of: soundfont) { 
            NotificationCenter.default.post(name: Notification.Name.init("sf_changed"),object: nil, userInfo: [:])
        }.onAppear(perform: {
           
     
        })
        
    }
    
}

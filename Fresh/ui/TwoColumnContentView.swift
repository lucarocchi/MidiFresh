/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The content view for the two-column navigation split view experience.
 */

import SwiftUI
import PDFKit

struct TwoColumnContentView: View {
    @State var tag:Int? = nil
    var body: some View {
        NavigationSplitView(
            //columnVisibility: .doubleColumn
        ) {
            ScrollView(){
                Group(){
                    NavigationLink {
                        SequencerView()
                    } label: {
                        
                        MenuRow(title: "Midifile player",subtitle: "load midifile and manage tracks",image:"pianokeys")
                     
                    }
                    NavigationLink {
                        ListSoundFontView()
                    } label: {
                        MenuRow(title: "Sound fonts",subtitle: "download soundfonts",image:"waveform.path")
                     
                       
                    }
                    
                    NavigationLink {
                        DrumkitView()
                    } label: {
                        MenuRow(title: "Sample Drumkit",subtitle: "configure sample based drumkit",image:"waveform.circle")
                     
                       
                    }
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        MenuRow(title: "Instruments",subtitle: "assign sounds to instruments",image:"guitars")
                 
                        
                    }
                    
                    NavigationLink {
                        MusicSheetView()
                    } label: {
                        MenuRow(title: "Music Sheet",subtitle: "load auxiliary pdf music sheet ",image:"music.note.list")
                        
                    }
                    
                }
            }.padding()
                .navigationTitle("MidiTrack")
                .buttonStyle(.borderless)
        } detail: {
            SequencerView()
            /*NavigationStack(path: $navigationModel.recipePath) {
                RecipeGrid(category: navigationModel.selectedCategory)
            }*/
        }
    }
}

struct PlayerButton: ViewModifier {
    func body(content: Content) -> some View {
        
        content
#if os(iOS)
            .font(.title)
#else
#endif
    }
}

struct PanelColor: ViewModifier {
    func body(content: Content) -> some View {
        
        content
#if os(iOS)
        .background(Color(uiColor: .secondarySystemBackground))
        //.cornerRadius(20)
#else
#endif
    }
}

/*
struct TwoColumnContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TwoColumnContentView(
                showExperiencePicker: .constant(false),
                dataModel: .shared)
            .environmentObject(NavigationModel(columnVisibility: .doubleColumn))
            TwoColumnContentView(
                showExperiencePicker: .constant(false),
                dataModel: .shared)
            .environmentObject(NavigationModel(
                columnVisibility: .doubleColumn,
                selectedCategory: .dessert))
            TwoColumnContentView(
                showExperiencePicker: .constant(false),
                dataModel: .shared)
            .environmentObject(NavigationModel(
                columnVisibility: .doubleColumn,
                selectedCategory: .dessert,
                recipePath: [.mock]))
        }
    }
}
*/

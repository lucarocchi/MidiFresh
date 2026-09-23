/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The app's navigation with a configuration that offers a sidebar, content list, and detail pane.
 */

import SwiftUI

struct AppSidebarNavigation: View {
    @ObservedObject var settings = SettingManager()
    let title1 = "\("Exercise".localize) #1"
    let title2 = "\("Exercise".localize) #2"
    let title3 = "\("Exercise".localize) #3"
    var body: some View {
        NavigationView {
            
            List {
                
                //
                Section() {
                    NavigationLink {
                        SequencerView()
                    } label: {
                        HStack {
                            Image(systemName: "music.quarternote.3")
                                .font(.largeTitle)
                                .frame(width: 50)
                                .foregroundColor(Color.accentColor)
                            
                            VStack(alignment: .leading) {
                                //GPSAccuracyMessage
                                Text("Sequencer".localize)
                                    .font(.headline)
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                //
                Section() {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                                .font(.largeTitle)
                                .frame(width: 50)
                                .foregroundColor(Color.accentColor)
                            
                            VStack(alignment: .leading) {
                                //GPSAccuracyMessage
                                Text("Settings".localize)
                                    .font(.headline)
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                    .fixedSize(horizontal: false, vertical: true)
                              
                                
                                
                            }
                            
                            
                        }
                    }.navigationBarTitle("MidiTrack".localize,displayMode: .inline)
                        .navigationViewStyle(StackNavigationViewStyle())
                    
                }
               
                
            }
            .padding([.top])
            .onAppear(){
                //UITableView.appearance().backgroundColor = .clear
            }
            
            SequencerView()
        
        }
        
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
        
    }
}

/*
 struct AppSidebarNavigationPocket_Previews: PreviewProvider {
 static var previews: some View {
 
 }
 }
 */

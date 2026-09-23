//
//  ContentView.swift
//  Altered
//
//  Created by Luca Rocchi on 07/08/22.
//

import SwiftUI

struct AppTabNavigation: View {
    var body: some View {
        TabView {
            
            SequencerView()
                .tabItem {
                    Label("Sequencer".localize, systemImage: "music.quarternote.3")
                }
            
       

            /*RankingView()
                .tabItem {
                    Label("Ranking".localize, systemImage: "checkmark.seal")
                }*/
            SettingsView()
                .tabItem {
                    Label("Settings".localize, systemImage: "gear")
                }
        }
    }

}

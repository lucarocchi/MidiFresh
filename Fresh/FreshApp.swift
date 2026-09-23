//
//  FreshApp.swift
//  Fresh
//
//  Created by Luca Rocchi on 01/05/24.
//

import SwiftUI
import AVFoundation
import AudioKit

@main
struct FreshApp: App {
    init() {
#if os(iOS)
        do {
            Settings.bufferLength = .medium
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.allowAirPlay, .allowBluetooth])
            //, .allowBluetooth, .allowBluetoothA2DP
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                #if os(macOS)
                .frame(minWidth: 800, minHeight: 600)
                #endif
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}

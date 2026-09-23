//
//  GridView.swift
//  Landmarks
//
//  Created by Luca Rocchi on 07/07/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI
struct ListSoundFontView:  View {
    @EnvironmentObject var mtSequencer: MTSequencer
    //@State var dkSF: Soundfont
    //@State var gmSF: Soundfont
    
    
    
    var body: some View {
        //NavigationView {
            
            List(mtSequencer.soundfonts) {  soundfont in
                //Group(){
                    
                    HStack() {
                        VStack(alignment: .leading) {
                            Text("\(soundfont.instrument)").font(.headline)
                            Text(soundfont.name)
                                .font(.callout)
                            Text(soundfont.size).font(.callout)
                            
                            //Text(user.phone)
                        }
                        Spacer()
                        
                        
                        Button {
                            if !soundfont.found {
                                soundfont.download()
                            }
                            
                        } label: {
                            if !soundfont.bundle {
                                if soundfont.downloading {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                }else{
                                    let icon = soundfont.found ? "checkmark.icloud.fill" : "icloud.and.arrow.down"
                                    Image(systemName: icon)
                                        .imageScale(.large)
                                }
                                
                            }
                        }
                        
                    }.frame(maxWidth: .infinity , alignment: .leading)
                //}
            }
            .frame(maxHeight:nil)
            .navigationTitle("Soundfonts")
            //.navigationBarTitle("Soundfonts", displayMode: .inline)
            .onAppear(){
                
            }
        //}
    }
    
}

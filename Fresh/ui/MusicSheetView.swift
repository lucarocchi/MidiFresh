//
//  InfoView.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 28/01/23.
//

import SwiftUI
import AudioToolbox
import PDFKit
//https://github.com/music-notation-swift
struct MusicSheetView: View {
    @EnvironmentObject var mtSequencer: MTSequencer
    @Environment(\.scenePhase) var scenePhase
    @State private var showPDFPicker = false
    @State var pdfDoc = PDFDocument()
 
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                PDFKitView(pdfDocument: $pdfDoc)
            }
            
        }
        .frame(maxHeight:nil)
        .navigationTitle("Music Sheet")
        .toolbar {
          
            ToolbarItem(placement: .automatic) {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large).onTapGesture {
#if os(iOS)
                        showPDFPicker.toggle()
#else
                        //openMidiFile()
#endif
                    }
            }
        }
        .sheet(isPresented: self.$showPDFPicker){
#if os(iOS)
            DocumentPicker(ext:"pdf")
#else
            EmptyView()
#endif
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name.init("documentAvailable")))
        { obj in
            if let userInfo = obj.userInfo, let url = userInfo["url"] as? URL,let type = userInfo["type"] as? String {
                if type != "pdf" {
                    return
                }
                pdfDoc = PDFDocument(url: url)!
                if let data = pdfDoc.dataRepresentation() {
                    let settings = SettingManager.sharedInstance
                    settings.pdfData = data        // 
                }
                
               
            }
        }.onAppear(){
            let settings = SettingManager.sharedInstance
            if let data = settings.pdfData {
                if let doc = PDFDocument(data: data){
                    pdfDoc = doc
                }
            }
        }
    }
    
}

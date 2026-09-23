//
//  Sample.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 08/03/23.
//


import AudioKit
import AudioKitUI
import AVFoundation
import Combine
import SwiftUI

class Sample : ObservableObject , Identifiable, Hashable, Codable{
    
    var name: String
    var midiNote: Int
    
    var filename: String {
        didSet {
            if let decoded = Data(base64Encoded: filename)  {
               do {
                    let url = try NSURL.init(resolvingBookmarkData: decoded, options: .withoutUI, relativeTo: nil, bookmarkDataIsStale: nil) as URL
                    let _ = url.startAccessingSecurityScopedResource()
                    print("bookmark url = \(url)")
                    
                    self.url = url
                    do {
                        let isReachable = try url.checkResourceIsReachable()
                        audioFile = try AVAudioFile(forReading: url)
                    } catch {
                        print(error)
                    }
                } catch let error as NSError {
                    print("Bookmark Access Fails: \(error.description)")
                }
            }
            
            //if let url = URL(string: filename){
            //}
        }
    }
    @Published var url: URL?
    @Published var audioFile: AVAudioFile?
    //var color = UIColor.red
    
    init(_ name: String, note: Int) {
        self.name = name
        filename = ""
        midiNote = note
    }
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        midiNote = try values.decode(Int.self, forKey: .midiNote)
        filename = try values.decode(String.self, forKey: .filename)
        //print ("Sample \(midiNote) \(filename)")
        //print("----")
    }
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case filename
        case midiNote
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(midiNote)
    }
    
    static func == (lhs: Sample, rhs: Sample) -> Bool {
        return lhs.midiNote == rhs.midiNote
    }
    
    func setAudioFile(_ url:URL){
        
        if let urlBookmark = try? url.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil) {
            let data64 = urlBookmark.base64EncodedString()
            self.filename = data64
            //print("bookmark = \(data64)")
        }
         
    }
    
}

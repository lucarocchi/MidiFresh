//
//  Soundfont.swift
//  Soundfont
//
//  Created by Luca Rocchi on 08/07/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftUI

class Soundfont: Identifiable, Codable,Hashable,ObservableObject  {
    //{"url":"http:\/\/www.laziomatica.com\/audio\/soundfont\/909_Drum_sf.sf2","size":"1.5MB","type":"sf","instrument":"Drum","name":"909_Drum_sf.sf2"},
    var id: String {name}
    var url: String
    var size: String
    var type: String
    var instrument: String
    var name: String
    var bundle:Bool = false;
    @Published var downloading:Bool = false;

    enum CodingKeys:String,CodingKey {
        case url
        case size
        case type
        case instrument
        case name
  
    }
    
    var ext:String  {
        get {
            let ext = (name as NSString).pathExtension
            //let ext = name.split(separator: ".")[1]
            return String("."+ext)
        }
    }
    var namePart:String  {
        get {
            let ext0 = (name as NSString).pathExtension
            let ext =  String("."+ext0)
            let np = name.replacingOccurrences(of: ext, with: "")
            return String(np)
        }
    }
    
    /*var urlPart:String  {
        get {
            let np = url.replacingOccurrences(of: ext, with: "")
            return String(np)
        }
    }*/
    
    var Url:URL?  {
        get {
           
            if bundle {
                let ee = ext
                let uu = url.replacingOccurrences(of: ee, with: "")
                
                if let url = Bundle.main.url(forResource: String(uu), withExtension: ee) {
                    return url
                }
            }else{
                let dm = DownloadManager.sharedInstance
                let found = dm.fileExist(url)
                if found {
                    if let fp = dm.getLocalPath(url) {
                        let url = URL(filePath: fp)
                        return url
                    }
                }
          
            }
            return nil
        }
    }
    
    var found: Bool {
        get{
            if bundle {
                return true
            }
            let dm = DownloadManager.sharedInstance
            let found = dm.fileExist(url)
            return found
        }
    }
    
    init(url:String){
        self.url = url
        name = url
        instrument = "GMIDI"
        size = "2MB"
        type = "sf"
        bundle = true
        downloading = false
    }
    
  
    static func == (lhs: Soundfont, rhs: Soundfont) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    
     func download(){
        let dm = DownloadManager.sharedInstance
        downloading = true
        dm.download(url,soundfont: self)
    }
}

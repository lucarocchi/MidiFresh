//
//  DownloadManager.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 09/12/22.
//

import Foundation
class DownloadManager : ObservableObject {
    var documentDirectory :URL!
    //let folderPath = "MidiTrack"
    
    static var _sharedInstance = DownloadManager()
    class var sharedInstance: DownloadManager {
        return _sharedInstance
    }
    
    
    init() {
         
        documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //let dataPath = directory.appendingPathComponent(folderPath)
        /*if !FileManager.default.fileExists(atPath: dataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        documentDirectory = dataPath
         */
    }
    
    func getLocalPath(_ urlString:String) -> String?{
        if let url = URL(string: urlString) {
            let name = url.lastPathComponent
            let filename = documentDirectory.appendingPathComponent(name)
            return filename.path()
        }
        return nil
    }
    
    func fileExist(_ urlString:String) -> Bool{
        if let url = URL(string: urlString) {
            let name = url.lastPathComponent
            let filename = documentDirectory.appendingPathComponent(name)
            print (filename)
            let fn = filename.path()
            if FileManager.default.fileExists(atPath: fn) {
                print ("EXIST")
                return true
            }
            
        }
        print ("! EXIST")
        return false
    }
    
    func download(_ urlString:String,soundfont:Soundfont){
        if let url = URL(string: urlString) {
            let name = url.lastPathComponent
            let filename = documentDirectory.appendingPathComponent(name)
     
            URLSession.shared.downloadTask(with: url) { (tempFileUrl, response, error) in
                
                if let tempFileUrl = tempFileUrl {
                    do {
                        let data = try Data(contentsOf: tempFileUrl)
                        try data.write(to: filename)
                        soundfont.downloading = false
                    } catch {
                        soundfont.downloading = false
                        print(error)
                    }
                }else{
                    soundfont.downloading = false
                }
            }.resume()
        }

    }
    
}

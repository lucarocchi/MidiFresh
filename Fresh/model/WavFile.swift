//
//  WavFile.swift
//  MidiTrack
//
//  Created by Luca Rocchi on 26/03/23.
//

import Foundation
class WavFile{
    var data = Data()
    init() {
        
    }
    
    init(data:Data) {
        self.data = data
        
        // update RIFF chunk size
        let fileLength = data.count
        let riffChunkSize = UInt32(fileLength - 8)
        //let riffChunkSizeRange = NSMakeRange(4, 4)
        //data.replaceBytes(in: riffChunkSizeRange, withBytes: &riffChunkSize)
        print("riffChunkSize \(riffChunkSize)")

        // find data subchunk
        var subchunkID: String?
        var subchunkSize = 0
        var fieldOffset = 12
        let fieldSize = 4
        while true {
            
            if fieldOffset + 2*fieldSize >= data.count {
               break
            }
            
            // read subchunk ID
            subchunkID = dataToUTF8String(data: data as NSData, offset: fieldOffset, length: fieldSize)
            fieldOffset += fieldSize
            
            /*if subchunkID == "data" {
                break
            }
            
            if subchunkID == "fmt " {
                break
            }*/
            
            // read subchunk size
            subchunkSize = dataToUInt32(data: data as NSData, offset: fieldOffset)
            print(subchunkID!)
            print("\(subchunkSize)")
           
            fieldOffset += fieldSize + subchunkSize
            
        }
        
        //let rllrRange = NSMakeRange(0, fieldOffset)

        //data.replaceBytes(in: rllrRange, withBytes: nil, length: 0)
        //newData = newWavHeader(pcmDataLength: data.length)
        //newData.append(data as Data)
    }
    
    
    private func dataToUTF8String(data: NSData, offset: Int, length: Int) -> String? {
        let range = NSMakeRange(offset, length)
        let subdata = data.subdata(with: range)
        return String(data: subdata, encoding: String.Encoding.utf8)
    }
     
    private func dataToUInt32(data: NSData, offset: Int) -> Int {
        var num: UInt32 = 0
        let length = 4
        let range = NSMakeRange(offset, length)
        data.getBytes(&num, range: range)
        return Int(num)
    }
}

//
//  MusicModel.swift
//  Altered
//
//  Created by Luca Rocchi on 09/08/22.
//

import Foundation

// https://en.wikipedia.org/wiki/Dominant_seventh_sharp_ninth_chord

public typealias Note = (name:String,semitones:Int,type:NoteType,natural:NoteNatural)

public typealias NoteInterval = (name:String,shortname:String,semitones:Int,ordinal:Int)

public enum NoteType: Int, CustomStringConvertible {
    case natural,flat,sharp
    
    public var description: String {
        switch self.rawValue {
        case 0: return ""
        case 1: return "flat".localize
        case 2: return "sharp".localize
        default: return ""
        }
    }
}

public enum NoteNatural: Int, CustomStringConvertible {
    case C ,D, E,F, G,A,B
    public var description: String {
        switch self.rawValue {
        case 0: return "C"
        case 1: return "D"
        case 2: return "E"
        case 3: return "F"
        case 4: return "G"
        case 5: return "A"
        case 6: return "B"
        default: return ""
        }
    }
    
}

class MusicModel: NSObject,ObservableObject {
    static let _sharedInstance = MusicModel()
    
    internal let defaults = UserDefaults.standard;
    
    @objc class var shared: MusicModel {
        return _sharedInstance
    }
    
    //b \u{266D}  \u{266F}
    let bemolle = "\u{266D}" //♭
    let diesis = "\u{266F}" //♯
    
    public var noteIntervals : [NoteInterval] = [
        ("flat 2nd","♭2",1,2),
        ("2nd","2",2,2),
        ("minor 3rd","♭3",3,3),
        ("major 3rd","3",4,3),
        ("4th","4",5,4),
        ("sharp 4th","♯4",6,4),
        ("flat 5th","♭5",6,5),
        ("5th","5",7,5),
        ("sharp 5th","♯5",8,5),
        ("6th","6",9,6),
        ("flat 7th","♭7",10,7),
        ("7th","7",11,7),
        ("flat 9th","♭9",13,9),
        ("9th","9",14,9),
        ("sharp 9th","♯9",15,10),
        ("sharp 11th","♯11",18,11),
        ("flat 13th","♭13",20,13),
        ("13th","13",21,13)
    ]
    
    public var baseNotes : [Note] = [
        ("C",0,.natural,.C),
        ("C♯",1,.sharp,.C),
        ("D♭",1,.flat,.D),
        ("D",2,.natural,.D),
        ("D♯",3,.sharp,.D),
        ("E♭",3,.flat,.E),
        ("E",4,.natural,.E),
        ("F",5,.natural,.F),
        ("F♯",6,.sharp,.F),
        ("G♭",6,.flat,.G),
        ("G",7,.natural,.G),
        ("G♯",8,.sharp,.G),
        ("A♭",8,.flat,.A),
        ("A",9,.natural,.A),
        ("A♯",10,.sharp,.A),
        ("B♭",10,.flat,.B),
        ("B",11,.natural,.B)
   
    ]
    
    public var notFoundNote:Note = ("Error",0,.natural,.C)
    
    public var allNotes : [Note] = [
        ("C",0,.natural,.C),
        ("C♯",1,.sharp,.C),
        ("D♭",1,.flat,.D),
        ("D",2,.natural,.D),
        ("D♯",3,.sharp,.D),
        ("E♭",3,.flat,.E),
        ("E",4,.natural,.E),
        ("F",5,.natural,.F),
        ("F♯",6,.sharp,.F),
        ("G♭",6,.flat,.G),
        ("G",7,.natural,.G),
        ("G♯",8,.sharp,.G),
        ("A♭",8,.flat,.A),
        ("A",9,.natural,.A),
        ("A♯",10,.sharp,.A),
        ("B♭",10,.flat,.B),
        ("B",11,.natural,.B),
        ("C",0,.natural,.C)
    ]
    
    
    func randomNote() -> Note {
        // pick and return a new value
        let rand = Int.random(in: 0..<baseNotes.count)
        return baseNotes[rand] //15Bb   9 Gb
    }
    
    func randomInterval() -> NoteInterval {
        // pick and return a new value
        let rand = Int.random(in: 0..<noteIntervals.count)
        return noteIntervals[rand] //3 3M   15 11#
    }
    
    func findTarget(note:Note,interval:NoteInterval) -> Note {
        
        let naturalOrdinal = note.natural.rawValue
        let targetNaturalIndex = (naturalOrdinal + (interval.ordinal-1)) % 7
        let targetNatural = NoteNatural(rawValue: targetNaturalIndex)
        //if note.type == .flat && interval.semitones == 13 {
        //    targetNatural = note.natural
        //}
        //if note.type == .sharp && interval.semitones == 21 { //13th
        //    targetNatural = note.natural
        //}
        let semitonesOffset = note.semitones + interval.semitones
        let semitones = semitonesOffset % 12
        
        let result = allNotes.filter{ note in
            return note.semitones == semitones
        }
        
        if result.count == 1 {
            return result[0]
        }
        
        if result.count == 2 {
            
            if result[0].natural == targetNatural {
                return result[0]
            }
            if result[1].natural == targetNatural {
                return result[1]
            }
            
            if note.type == .sharp {
                if result[0].type == .sharp {
                    return result[0]
                }
                if result[1].type == .sharp {
                    return result[1]
                }
                
            }
            if note.type == .flat {
                if result[0].type == .flat {
                    return result[0]
                }
                if result[1].type == .flat {
                    return result[1]
                }
            }
            return result[0]
            
            
        }
        /*for n in allNotes {
         let r1 = n.natural.rawValue
         let r2 = targetNatural?.rawValue
         let st = n.semitones
         if r1 == r2 && st == semitones {
         return n
         }
         }*/
        return notFoundNote
    }
    
    func getNoteNames(key:Int) -> String {
        let offset = key % 12
        let octave = (key - 24 ) / 12
        let filtered = baseNotes.filter{
            $0.semitones == offset
        }.map {return $0.name+String(octave)}
        let names = filtered.joined(separator: "/")
        return names
    }
}


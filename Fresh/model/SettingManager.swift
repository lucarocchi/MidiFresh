//
//  Settings.swift

//

import Foundation

class SettingManager: ObservableObject {
    
    static let _sharedInstance = SettingManager()
    
    internal let defaults = UserDefaults.standard;
    
    class var sharedInstance: SettingManager {
        return _sharedInstance
    }
    
    @Published var midiInput: String {
        didSet {
            let key="midiInput";
            defaults.set(midiInput, forKey:key);
            
        }
    }
    
    //var defGmSoundfont = Soundfont(url: "GeneralUser_GS_MuseScore.sf2")
    var defGmSoundfont = Soundfont(url: "Yamaha_XG_Sound_Set.sf2")
    //var defDrumkitSoundfont = Soundfont(url: "Arachno_SoundFont_v1.0_GM.sf2")
    var defDrumkitSoundfont = Soundfont(url: "Yamaha_XG_Sound_Set.sf2")

    @Published var gmSoundfont : Soundfont {
        didSet {
            let key="gmSoundfont";
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(gmSoundfont) {
                defaults.set(encoded, forKey:key);
            }
        }
    }
    
    @Published var bassSoundfont : Soundfont {
        didSet {
            let key="bassSoundfont";
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(bassSoundfont) {
                defaults.set(encoded, forKey:key);
            }
        }
    }
    @Published var drumkitSoundfont : Soundfont {
        didSet {
            let key="drumkitSoundfont";
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(drumkitSoundfont) {
                defaults.set(encoded, forKey:key);
            }
        }
    }
    
    @Published var pianoSoundfont : Soundfont {
        didSet {
            let key="pianoSoundfont";
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(pianoSoundfont) {
                defaults.set(encoded, forKey:key);
            }
        }
    }
    @Published var guitarSoundfont : Soundfont {
        didSet {
            let key="guitarSoundfont";
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(guitarSoundfont) {
                defaults.set(encoded, forKey:key);
            }
        }
    }
    
    @Published var pdfData: Data? {
        didSet {
            let key="pdfData";
            defaults.set(pdfData, forKey:key);
        }
    }
    @Published var recentUrl: String? {
        didSet {
            let key="recentUrl";
            defaults.set(recentUrl, forKey:key);
            
        }
    }
    @Published var recentUrlData: Data? {
        didSet {
            let key="recentUrlData";
            defaults.set(recentUrlData, forKey:key);
            
        }
    }
    
    
    @Published var languageId: Int = 0 {
        didSet {
            let key="languageId";
            defaults.set(languageId, forKey:key);
            NotificationCenter.default.post(name: Notification.Name(rawValue: key), object: nil)
        }
    }
    
    
    
    
    @Published var publishMode: Bool = false {
        didSet {
            let key="publishMode";
            defaults.set(publishMode, forKey:key);
            //NotificationCenter.default.post(name: Notification.Name(rawValue: key), object: nil)
        }
    }
    
    
    @Published var showKeyboard: Bool = true {
        didSet {
            let key="showKeyboard";
            defaults.set(showKeyboard, forKey:key);
            //NotificationCenter.default.post(name: Notification.Name(rawValue: key), object: nil)
        }
    }
    
    
    
    
    init() {
        showKeyboard = defaults.bool(forKey: "showKeyboard")
        publishMode = defaults.bool(forKey: "publishMode")
        languageId = defaults.integer(forKey: "languageId")
        midiInput = defaults.string(forKey: "midiInput" ) ?? ""
        pdfData = defaults.data(forKey: "pdfData" )
        recentUrl = defaults.string(forKey: "recentUrl" )
        recentUrlData = defaults.data(forKey: "recentUrlData")
        gmSoundfont = defGmSoundfont
        drumkitSoundfont = defDrumkitSoundfont
        bassSoundfont = defDrumkitSoundfont
        guitarSoundfont = defDrumkitSoundfont
        pianoSoundfont = defDrumkitSoundfont
        
        load(name: "gmSoundfont",soundfont: &gmSoundfont)
        load(name: "drumkitSoundfont",soundfont: &drumkitSoundfont)
        load(name: "bassSoundfont",soundfont: &bassSoundfont)
        load(name: "guitarSoundfont",soundfont: &guitarSoundfont)
        load(name: "pianoSoundfont",soundfont: &pianoSoundfont)

    }
    
    func load (name:String, soundfont:inout Soundfont){
        if let sf = defaults.object(forKey: name) as? Data {
            let decoder = JSONDecoder()
            if let loadedSf = try? decoder.decode(Soundfont.self, from: sf) {
                if loadedSf != defGmSoundfont {
                    soundfont = loadedSf
                }
            }
        }
    }
}

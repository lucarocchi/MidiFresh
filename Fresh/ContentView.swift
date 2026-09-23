import SwiftUI
/*struct ContentView: View {
    var body: some View {
        SequencerView()
            //.background(Color(uiColor:.systemBackground))
    }
}*/

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    @StateObject var mtSequencer:MTSequencer = MTSequencer.sharedInstance

    var body: some View {
        SequencerView().environmentObject(mtSequencer)
        //TwoColumnContentView().environmentObject(mtSequencer)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

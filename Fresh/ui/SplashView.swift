import SwiftUI

public struct SplashView: View {
    @State private var isContentReady = false
    @State private var shouldChange = false

    public init() {}

    public var body: some View {
        ZStack {
            if self.isContentReady {
                ContentView()
            } else {
                VStack(spacing: 0) {
                    Spacer()
                    Text("MidiFresh").font(shouldChange ? .largeTitle :.headline).bold()
                    
                    Text("midifile player")
                        .font(.headline).italic()
                        
                    /*
                    Image("audiokit-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 217,
                               height: 120)
                     */
                    Spacer()
                    HStack(alignment:.bottom){
                        Text("powered by Audiokit ©").font(.caption)
                        
                    } .padding(10)
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                ) //.background(Image("fresh_splash"))
               
            }
        }
        .onAppear(){
            withAnimation(.linear(duration: 1.0)) {
                shouldChange.toggle()
            }
        }
        .onAppear {
           
            DispatchQueue.main
                .asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        self.isContentReady.toggle()
                    }
                }
        }
    }
}

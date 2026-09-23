import SwiftUI
import AudioKit
import AudioKitUI
import Controls

struct MenuRow: View {
    //@Environment(\.scenePhase) var scenePhase
    
    var title:String
    var subtitle:String
    var image:String
   
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: image) .resizable()
                    .modifier(MenuImage())
                
                VStack(alignment: .leading){
                    Text("\(title)").font(.headline).foregroundStyle(.foreground).multilineTextAlignment(.leading).frame(maxWidth: .infinity , alignment: .leading)
                    Text("\(subtitle)").font(.subheadline).foregroundStyle(.foreground).multilineTextAlignment(.leading).frame(maxWidth: .infinity , alignment: .leading)
                }
            }
            //Spacer()
            
        }.padding()
            .modifier(PanelColor())
            .cornerRadius(10)
            .frame(maxWidth: .infinity , alignment: .leading)
           
    }
}


struct MenuImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(5)
            .scaledToFit()
            .frame(width:40, height: 40)
            .background(Color.black)
            .foregroundColor(Color.white)
    }
}

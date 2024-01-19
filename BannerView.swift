import SwiftUI

struct BannerView: View {
    @State var isOnScreen: Bool = false
    var body: some View {
        VStack {
            Spacer()
            Text("Palabra no existe")
                .foregroundColor(.white)
                .padding()
                .background(.red)
                .cornerRadius(12)
            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .animation(.easeInOut(duration: 0.3), value: isOnScreen)
        .offset(y: isOnScreen ? -350 : -500)
        .onAppear {
            isOnScreen = true
        }
    }
}

import SwiftUI

struct ModalView: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            Text("")
            Button("Juega otra vez") {
                showModal = false
            }
        }
    }
}

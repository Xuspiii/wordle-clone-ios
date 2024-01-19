import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                GameView(viewModel: viewModel)
                KeyboardView(viewModel: viewModel)
            }
            if viewModel.isWordIncorrect {
                BannerView()
            }
        }
        .sheet(isPresented: $viewModel.gameOver) {
            VStack {
                Text(viewModel.userWin ? "¡Has ganado!" : "Has perdido :(")
                Button("Juega otra vez") {
                    viewModel.startNewGame()
                }
            }
        }
    }
}

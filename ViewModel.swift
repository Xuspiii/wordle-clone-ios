import Foundation
import UIKit

final class ViewModel: ObservableObject {
    
    private let words = ["REINA", "ABEJA", "PLAYA", "MANGO", "SIGLO", "REGLA", "LAPIZ", "RATON", "MOVIL", "SALIR", "BAILE", "FRUTA", "CARNE", "BRAZO", "CINTA"]
    
    var numOfRow: Int = 0
    @Published var isWordIncorrect = false
    @Published var userWin = false
    @Published var gameOver = false
    @Published var result: String = "ARBOL"
    @Published var word: [LetterModel] = []
    @Published var gameData: [[LetterModel]] = [
        [.init(""), .init(""), .init(""), .init(""), .init("")],
        [.init(""), .init(""), .init(""), .init(""), .init("")],
        [.init(""), .init(""), .init(""), .init(""), .init("")],
        [.init(""), .init(""), .init(""), .init(""), .init("")],
        [.init(""), .init(""), .init(""), .init(""), .init("")],
        [.init(""), .init(""), .init(""), .init(""), .init("")]
    ]
    
    func addNewLetter(letterModel: LetterModel) {
        if letterModel.name == "" {
            return
        }
        
        if letterModel.name == "⬅️" {
            tapOnRemove()
            return
        }
        
        if word.count < 5 {
            let letter = LetterModel(letterModel.name)
            word.append(letter)
            gameData[numOfRow][word.count-1] = letter
            if word.count == 5 {
                tapOnSend()
            }
        }
    }
    
    private func tapOnSend() {
        
        let finalStringWord = word.map { $0.name }.joined()
        
        if wordIsReal(word: finalStringWord) {
            for (index, _) in word.enumerated() {
                let currentCharacter = word[index].name
                var status: Status
                
                if result.contains(where: { String($0) == currentCharacter}) {
                    status = .appear
                    
                    if currentCharacter == String(result[result.index(result.startIndex, offsetBy: index)]) {
                        status = .match
                    }
                } else {
                    status = .dontAppear
                }
                
                var updateGameBoardCell = gameData[numOfRow][index]
                updateGameBoardCell.status = status
                gameData[numOfRow][index] = updateGameBoardCell
                
                let indexToUpdate = keyboardData.firstIndex(where: { $0.name == word[index].name })
                var keyboardKey = keyboardData[indexToUpdate!]
                if keyboardKey.status != .match {
                    keyboardKey.status = status
                    keyboardData[indexToUpdate!] = keyboardKey
                }
            }
            
            let isUserWinner = gameData[numOfRow].reduce(0) { partialResult, letterModel in
                if letterModel.status == .match {
                    return partialResult + 1
                }
                return 0
            }
            
            if isUserWinner == 5 {
                userWin = true
                gameOver = true
            } else {
                word = []
                numOfRow += 1
                if numOfRow == 6 {
                    userWin = false
                    gameOver = true
                }
            }
        } else {
            isWordIncorrect = true
        }
    }
    
    private func tapOnRemove() {
        guard word.count > 0 else {
            return
        }
        isWordIncorrect = false
        gameData[numOfRow][word.count-1] = .init("")
        word.removeLast()
    }
    
    private func wordIsReal(word: String) -> Bool {
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word)
    }
    
    func startNewGame() {
        numOfRow = 0
        isWordIncorrect = false
        userWin = false
        gameOver = false
        result = words.randomElement()!
        word = []
        gameData = [
            [.init(""), .init(""), .init(""), .init(""), .init("")],
            [.init(""), .init(""), .init(""), .init(""), .init("")],
            [.init(""), .init(""), .init(""), .init(""), .init("")],
            [.init(""), .init(""), .init(""), .init(""), .init("")],
            [.init(""), .init(""), .init(""), .init(""), .init("")],
            [.init(""), .init(""), .init(""), .init(""), .init("")]
        ]
        
        for index in keyboardData.indices {
            keyboardData[index].status = .normal
        }
    }
}


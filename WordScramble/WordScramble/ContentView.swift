//
//  ContentView.swift
//  WordScramble
//
//  Created by Groo on 5/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addWord)
            .onAppear(perform: startGame)
        }
    }
    
    func addWord() {
        let word = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard word.count > 0 else { return }
        withAnimation {
            usedWords.insert(word, at: 0)
        }
        newWord = ""
    }
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWordsString = try? String(contentsOf: startWordsURL) {
                let startWords = startWordsString.components(separatedBy: "\n")
                rootWord = startWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
}

#Preview {
    ContentView()
}

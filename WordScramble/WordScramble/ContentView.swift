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
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingAlert = false
    @State private var score = 0
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section("Your score") {
                    Text(score, format: .number)
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
            .alert(errorTitle, isPresented: $showingAlert) { } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button(action: {
                    startGame()
                }, label: {
                    Text("New Word")
                })
            }
        }
    }
    
    func addWord() {
        let word = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard word.count > 0 else { return }
        guard isNotRootWord(word: word) else {
            wordError(title: "Root word is not possible", message: "Use another word")
            return
        }
        guard isLonggerThan3(word: word) else {
            wordError(title: "Word is too short", message: "Input the word longer than 3")
            return
        }
        guard isOriginal(word: word) else {
            wordError(title: "Word used already", message: "Use another original word")
            return
        }
        guard isPossible(word: word) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'")
            return
        }
        guard isReal(word: word) else {
            wordError(title: "Word not recognized", message: "You have to use existing words")
            return
        }
        withAnimation {
            usedWords.insert(word, at: 0)
            score += word.count
        }
        newWord = ""
    }
    func startGame() {
        score = 0
        usedWords.removeAll()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWordsString = try? String(contentsOf: startWordsURL) {
                let startWords = startWordsString.components(separatedBy: "\n")
                rootWord = startWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    func isNotRootWord(word: String) -> Bool {
        !(rootWord == word)
    }
    func isLonggerThan3(word: String) -> Bool {
        word.count > 3
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
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingAlert = true
    }
}

#Preview {
    ContentView()
}

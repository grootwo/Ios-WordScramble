//
//  ContentView.swift
//  WordScramble
//
//  Created by Groo on 5/12/24.
//

import SwiftUI

struct ContentView: View {
    let cats = ["cheese", "tabby", "tuxedo", "chaos"]
    var body: some View {
        List{
            Section("cats") {
                ForEach(cats, id: \.self) {
                    Text($0)
                }
            }
            Section("numbers") {
                Text("1")
                Text("2")
                Text("3")
            }
        }
        .listStyle(.grouped)
    }
    
    func testBundles() {
        if let fileUrl = Bundle.main.url(forResource: "somefile", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileUrl) {
                // file is loaded into a string
            }
        }
    }
    func testStrings() {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound
        print(allGood)
    }
}

#Preview {
    ContentView()
}

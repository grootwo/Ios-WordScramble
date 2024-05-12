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
}

#Preview {
    ContentView()
}

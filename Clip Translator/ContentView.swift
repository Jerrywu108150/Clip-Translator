//
//  ContentView.swift
//  Clip Translator
//
//  Created by jerry wu on 2025/6/20.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var translator = ClipboardTranslator()

    var body: some View {
        VStack(spacing: 12) {
            Text("Clipboard Translation")
                .font(.headline)
            Text(translator.translatedText)
                .multilineTextAlignment(.center)
                .padding()
            Button("Refresh") {
                translator.refresh()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

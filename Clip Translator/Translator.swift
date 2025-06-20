import Foundation
import UIKit

/// Simple offline translator using a small dictionary.
struct Translator {
    /// Dictionary containing example translations from English to Japanese.
    private static let dictionary: [String: String] = [
        "hello": "こんにちは",
        "world": "世界",
        "good": "良い",
        "morning": "朝",
        "cat": "猫",
        "dog": "犬"
    ]

    /// Translates a phrase. Returns the original text if no translation exists.
    static func translate(_ text: String) -> String {
        let lowercased = text.lowercased()
        if let translated = dictionary[lowercased] {
            return translated
        }
        return text
    }
}

/// Helper object that reads clipboard and publishes translated text.
final class ClipboardTranslator: ObservableObject {
    @Published var translatedText: String = ""

    init() {
        refresh()
    }

    /// Reads the current clipboard string and updates ``translatedText``.
    func refresh() {
        if let value = UIPasteboard.general.string, !value.isEmpty {
            translatedText = Translator.translate(value)
        } else {
            translatedText = "(clipboard empty)"
        }
    }
}

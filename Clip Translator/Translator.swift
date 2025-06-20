import Foundation
import UIKit

/// Result returned by the LibreTranslate API.
private struct TranslateResult: Decodable {
    let translatedText: String
}

/// Translator using the open source LibreTranslate API.
struct Translator {
    /// Performs an asynchronous translation request.
    static func translate(_ text: String,
                          from source: String = "auto",
                          to target: String = Locale.current.languageCode ?? "en",
                          completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://libretranslate.de/translate") else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "q": text,
            "source": source,
            "target": target,
            "format": "text"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let result = try? JSONDecoder().decode(TranslateResult.self, from: data) else {
                completion(nil)
                return
            }
            completion(result.translatedText)
        }.resume()
    }

    /// Synchronous helper used by widgets to fetch a translation.
    static func translateSync(_ text: String,
                              from source: String = "auto",
                              to target: String = Locale.current.languageCode ?? "en") -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var output: String?
        translate(text, from: source, to: target) { result in
            output = result
            semaphore.signal()
        }
        semaphore.wait()
        return output
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
            translatedText = "Translating..."
            Translator.translate(value) { [weak self] result in
                DispatchQueue.main.async {
                    self?.translatedText = result ?? "(error)"
                }
            }
        } else {
            translatedText = "(clipboard empty)"
        }
    }
}

import WidgetKit
import SwiftUI
import UIKit

struct ClipboardEntry: TimelineEntry {
    let date: Date
    let translatedText: String
}

struct ClipboardProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClipboardEntry {
        ClipboardEntry(date: Date(), translatedText: "example")
    }

    func getSnapshot(in context: Context, completion: @escaping (ClipboardEntry) -> Void) {
        let entry = ClipboardEntry(date: Date(), translatedText: ClipboardTranslator().translatedText)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClipboardEntry>) -> Void) {
        let translator = ClipboardTranslator()
        let entry = ClipboardEntry(date: Date(), translatedText: translator.translatedText)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct ClipboardWidgetEntryView: View {
    var entry: ClipboardProvider.Entry

    var body: some View {
        Text(entry.translatedText)
            .padding()
    }
}

struct ClipboardWidget: Widget {
    let kind: String = "ClipboardWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClipboardProvider()) { entry in
            ClipboardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Clipboard Translator")
        .description("Displays translation of clipboard text.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    ClipboardWidget()
} timeline: {
    ClipboardEntry(date: .now, translatedText: "こんにちは")
}

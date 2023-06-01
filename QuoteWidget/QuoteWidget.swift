//
//  QuoteWidget.swift
//  QuoteWidget
//
//  Created by Dorukhan Demir on 30.03.2023.
//


import SwiftUI
import WidgetKit
  
class QuoteStore {
    static let shared = QuoteStore()
    
    var currentQuote: Quote?

    private init() {}
    
    func fetchRandomQuote(completion: @escaping (Quote) -> ()) {
        guard let url = URL(string: "https://api.quotable.io/random") else {
      return
      }

      URLSession.shared.dataTask(with: url) { (data, response, error) in
          guard let data = data else { return }
          if let decodedResponse = try? JSONDecoder().decode(Quote.self, from: data) {
              DispatchQueue.main.async {
                 self.currentQuote = decodedResponse
                 completion(decodedResponse)
             }
          }
      }.resume()
  }
}

struct QuoteEntry: TimelineEntry {
    let quote: Quote
    let date: Date
}

struct QuoteWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(quote: Quote(content: "Loading...", author: ""), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = QuoteEntry(quote: QuoteStore.shared.currentQuote ?? Quote(content: "Loading...", author: ""), date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        QuoteStore.shared.fetchRandomQuote { (quote) in
            let entry = QuoteEntry(quote: quote, date: currentDate)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct QuoteWidget: Widget {
    let kind: String = "QuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteWidgetProvider()) { entry in
            QuoteWidgetView(quote: entry.quote)
        }
        .configurationDisplayName("Quote of the Day")
        .description("Displays a random quote every 5 minutes.")
        .supportedFamilies([.systemSmall,.systemMedium, .systemLarge])
    }
}

struct QuoteWidgetView: View {
    
    let quote: Quote

    var body: some View {
        VStack {
            Text(quote.content)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("- " + quote.author)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)

            Spacer()
        }
        .padding()
    }
}
     
struct QuoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        QuoteWidgetView(quote: Quote(content: "Do not go where the path may lead, go instead where there is no path and leave a trail.", author: "Ralph Waldo Emerson"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

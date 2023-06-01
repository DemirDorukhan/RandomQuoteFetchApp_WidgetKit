//
//  ContentView.swift
//  D'quoteNew1
//
//  Created by Dorukhan Demir on 30.03.2023.
//
import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var quote: Quote?
    @State private var lastSwipeDate: Date = Date()
    
    var body: some View {
        VStack {
            
            Mark()
            
            if let quote = quote {
                Text(quote.content)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("- " + quote.author)
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
                
                
            } else {
                Text("Loading...")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }

            Mark()
                .rotationEffect(.degrees(180))
             
        }
        .padding()
        
        .onAppear {
            API.shared.fetchRandomQuote { result in
                switch result {
                case .success(let quote):
                    DispatchQueue.main.async {
                        self.quote = quote
                        //++
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            API.shared.startTimer {
                if Date().timeIntervalSince(lastSwipeDate) > 1 * 60 {
                    API.shared.fetchRandomQuote { result in
                        switch result {
                        case .success(let quote):
                            DispatchQueue.main.async {
                                self.quote = quote
                                //++
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .global)
                .onEnded { value in
                    let dx = value.translation.width
                    if dx > 0 {
                        API.shared.fetchRandomQuote { result in
                            switch result {
                            case .success(let quote):
                                DispatchQueue.main.async {
                                    self.quote = quote
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } else if dx < 0 {
                        API.shared.fetchRandomQuote { result in
                            switch result {
                            case .success(let quote):
                                DispatchQueue.main.async {
                                    self.quote = quote
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                    }
                }
            }
        )
    }
}
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
    

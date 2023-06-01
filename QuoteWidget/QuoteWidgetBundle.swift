//
//  QuoteWidgetBundle.swift
//  QuoteWidget
//
//  Created by Dorukhan Demir on 30.03.2023.
//

import WidgetKit
import SwiftUI

@main
struct QuoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuoteWidget()
        QuoteWidgetLiveActivity()
    }
}

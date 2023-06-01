//
//  Mark.swift
//  D'quoteNew1
//
//  Created by Dorukhan Demir on 30.03.2023.
//

import SwiftUI

struct Mark: View {
    var body: some View {
        VStack {
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            VStack {
                Text("''")
                    .font(.largeTitle)
            }
            .padding()
        }
    }
}

struct Mark_Previews: PreviewProvider {
    static var previews: some View {
        Mark()
    }
}


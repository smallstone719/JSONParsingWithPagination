//
//  ContentView.swift
//  JSONParsingWithPagination
//
//  Created by Thach Nguyen Trong on 3/22/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
           HomeView()
                .navigationTitle("JSON Parsing")
        }
    }
}

#Preview {
    ContentView()
}

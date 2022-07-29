//
//  ContentView.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ConnectView()
            .environment(\.colorScheme, .light)
#if os(macOS)
    .frame(minWidth: 340, maxWidth: 340, minHeight: 570, maxHeight: 570)

#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

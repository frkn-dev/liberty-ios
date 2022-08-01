//
//  ProtocolSelectionScreen.swift
//  Liberty
//
//  Created by Алексей Агеев on 02.08.2022.
//

import SwiftUI

struct ProtocolSelectionScreen: View {
    let protocols = ["WireGuard", "IPSec"]
    
    var body: some View {
        SupplementaryScreen {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(protocols, id: \.self) { `protocol` in
                    HStack {
                        Text(`protocol`)
                            .font(.exoBody.bold())
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ProtocolSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProtocolSelectionScreen()
    }
}

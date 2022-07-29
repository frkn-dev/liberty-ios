//
//  DonateScreen.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct DonateScreen: View {
    
    let supportItems = [
        ("USDT(Tether)", "0xE92d1695483bd9E82A1AeEEa02E60797B055c53C"),
        ("BTC", "bc1qe76609xu8qay4wt7tnvrxhx4spnjrywwh2jwf3"),
        ("Ethereum", "0xE92d1695483bd9E82A1AeEEa02E60797B055c53C"),
        ("NEAR", "2e1a065b84f27e3e8b7c9cd64200b7cf00ccd7b624da5996aba1185408ba5b5b"),
        ("Credo (Georgian Card)","GE21CD0360000028302649"),
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Text("\(Image(systemName: "arrow.left")) Back")
                }
                .buttonStyle(.plain)
                
                Text("We are OpenSource.\nYou can support us.")
                    .font(.title)
                Text("You can support us with donations or any other contribution to improve the service. Pulling requests and creating issues also helps us a lot.")
                ForEach(supportItems, id: \.0) { item in
                    VStack(alignment: .leading) {
                        Text(item.0)
                            .fontWeight(.bold)
                        Text(item.1)
                    }
                }
                
                
                HStack {
                    Button { } label: {
                        Text("Patreon")
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    
                    Button { } label: {
                        Text("Boosty")
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .fontWeight(.bold)
            }
            .padding()
        }
        .background(Image("Noize"))
    }
}

struct DonateScreen_Previews: PreviewProvider {
    static var previews: some View {
        DonateScreen()
    }
}

/*
FuckRKN1
←Back

You can support us with donations or any other contribution to improve the service. Pulling requests and creating issues also helps us a lot.

Patreon
Boosty
*/

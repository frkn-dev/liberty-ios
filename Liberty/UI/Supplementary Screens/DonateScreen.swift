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
        
        SupplementaryScreen {
            VStack(alignment: .leading, spacing: 20) {
                Text("We are OpenSource.\nYou can support us.")
                    .font(.exoTitle.bold())
                
                Text("You can support us with donations or any other contribution to improve the service. Pulling requests and creating issues also helps us a lot.")
                    .font(.exoBody)
                ForEach(supportItems, id: \.0) { item in
                    VStack(alignment: .leading) {
                        Text(item.0)
                        Text(item.1)
                            .font(.exoBody)
                    }
                }
                
                
                HStack {
                    Link("Patreon \(Image(systemName: "arrow.up.right.square"))",
                         destination: URL(string: "dev/null")!)

                    Spacer()
                    
                    Link("Boosty \(Image(systemName: "arrow.up.right.square"))",
                             destination: URL(string: "dev/null")!)
                    
                    Spacer()
                }
                .foregroundColor(.primary)
            }
            .font(.exoBody.bold())
            .padding()
        }
    }
}

struct DonateScreen_Previews: PreviewProvider {
    static var previews: some View {
        DonateScreen()
    }
}

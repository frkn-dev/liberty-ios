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
                    Text("\(Image(systemName: "arrow.left")) \(String(localized:  "back.button"))")
                }
                .buttonStyle(.plain)
                .font(.custom("Exo 2", size: 14, relativeTo: .title).bold())
                
                Text("open.source.title")
                    .font(.custom("Exo 2", size: 22, relativeTo: .title).bold())
                
                Text("open.source.descr")
                    .font(.custom("Exo 2", size: 14, relativeTo: .body))
                ForEach(supportItems, id: \.0) { item in
                    Button {
                        UIPasteboard.general.string = item.1
                    } label : {
                        VStack(alignment: .leading) {
                            Text(item.0)
                                .font(.custom("Exo 2", size: 14, relativeTo: .body).bold())
                                .foregroundColor(.black)
                            Text(item.1)
                                .font(.custom("Exo 2", size: 14, relativeTo: .body))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                HStack {
                    Button {
                        open(url: "https://www.patreon.com/2pizza")
                    } label: {
                        Image("Patreon")
                        Text("Patreon")
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    
                    Button {
                        open(url: "https://boosty.to/the2pizza")
                    } label: {
                        Image("Boosty")
                        Text("Boosty")
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }
                .font(.custom("Exo 2", size: 14, relativeTo: .body).bold())
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

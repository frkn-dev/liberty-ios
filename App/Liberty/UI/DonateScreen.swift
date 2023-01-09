//
//  DonateScreen.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct DonateScreen: View {
    
    let supportItems = [
        ("BTC", "bc1q5xjm7v20aee4tl2vngqju9k0uzajl2hvljqec6"),
        ("Ethereum", "0x92A3Fad82F27938AA0D5c7509132DD781C4880bb"),
        ("USDT(Eth)", "0x92A3Fad82F27938AA0D5c7509132DD781C4880bb"),
        ("USDT(Tron)", "TKuMVvLHW9orkuVwKpC8AhTDUDQV91ZfeX"),
        ("Solans", "3Crb3Kh6akz4n1qdMaG59e5jVSKR8VsZdPwF9GB8go44"),
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
                        copy(toClipboard: item.1)
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
                    }.buttonStyle(.plain)
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

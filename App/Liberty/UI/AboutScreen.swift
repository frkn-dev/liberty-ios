//
//  AboutScreen.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct AboutScreen: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Group {
                    Button {
                        dismiss()
                    } label: {
                        Text("\(Image(systemName: "arrow.left")) \(String(localized:  "back.button"))")
                            .font(.custom("Exo 2", size: 14, relativeTo: .body).bold())
                    }
                    .buttonStyle(.plain)
                    
                    Text("free.vpn.title")
                        .font(.custom("Exo 2", size: 24, relativeTo: .title).weight(.medium))

                    
                    Text("free.vpn.descr.1")
                        .font(.custom("Exo 2", size: 14, relativeTo: .body))
                    
                    Text("free.vpn.descr.2")
                        .font(.custom("Exo 2", size: 14, relativeTo: .body))
                }
                .padding(.horizontal)
                
                Image("About Image")
                    .resizable()
                    .scaledToFit()
                Group {
                        
                    Text("free.vpn.descr.3")
                        .font(.custom("Exo 2", size: 14, relativeTo: .body))
                        
                    
                    HStack(alignment: .bottom) {
                        Button {
                            open(url: "https://t.me/frkn_dev")
                        } label: {
                            VStack {
                                Image("Telegram")
                                Text("Telegram")
                            }
                        }
                        Spacer()
                        
                        Button {
                            open(url: "https://twitter.com/frkn_org")
                        } label: {
                            VStack {
                                Image("Twitter")
                                Text("Twitter")
                            }
                        }
                        Spacer()
                        
                        Button {
                            open(url: "https://github.com/nezavisimost")
                        } label: {
                            VStack {
                                Image("GitHub")
                                Text("GitHub")
                            }
                        }
                        
                    }
                    .buttonStyle(.plain)
                    .font(.custom("Exo 2", size: 12, relativeTo: .body))
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Image("Noize"))
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}

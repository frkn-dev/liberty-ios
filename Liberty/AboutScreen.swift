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
                        Text("\(Image(systemName: "arrow.left")) Back")
                    }
                    .buttonStyle(.plain)
                    
                    Text("Free VPN for free humans")
                        .font(.title)
                    Text("We are for freedom of speech and against any kind of censorship.")
                }
                .padding(.horizontal)
                
                Image("About Image")
                    .resizable()
                    .scaledToFit()
                Group {
                    Text("We are making a non-commercial VPN that does not collect any data.")
                        
                    Text("Today, freedom of speech is especially vulnerable. Independent media are banned, people are brainwashed with propaganda, VPN services are blocked, and it is dangerous to express one's position and opinion. This is the reason why we took on this project. It is non-commercial, no profit is pursued either. We are rather small, but yet, we have a great potential.")
                        
                    
                    HStack(alignment: .bottom) {
                        Button {} label: {
                            VStack {
                                Image("Telegram")
                                Text("Telegram")
                            }
                        }
                        Spacer()
                        Button {} label: {
                            VStack {
                                Image("Twitter")
                                Text("Twitter")
                            }
                        }
                        Spacer()
                        Button {} label: {
                            VStack {
                                Image("GitHub")
                                Text("GitHub")
                            }
                        }
                        
                    }
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

//
//  AboutScreen.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct AboutScreen: View {
    
    var body: some View {
        SupplementaryScreen {
            Group {
                Text("Free VPN for free humans")
                    .font(.exoTitle.weight(.medium))
                
                
                Text("We are making a non-commercial VPN that does not collect any data.")
                
                Text("We are for freedom of speech and against any kind of censorship.")
            }
            .font(.exoBody)
            .padding(.horizontal)
            
            Image("About Image")
                .resizable()
                .scaledToFit()
            Group {
                
                Text("Today, freedom of speech is especially vulnerable. Independent media are banned, people are brainwashed with propaganda, VPN services are blocked, and it is dangerous to express one's position and opinion. This is the reason why we took on this project. It is non-commercial, no profit is pursued either. We are rather small, but yet, we have a great potential.")
                
                
                HStack(alignment: .bottom) {
                    //FIXME: Add URL provider
                    Link(destination: URL(string: "https://t.me/FuckRKN1")!) {
                        VStack {
                            Image("Telegram")
                            Text("Telegram")
                        }
                    }
                    Spacer()
                    
                    //FIXME: Add URL provider
                    Link(destination: URL(string: "https://twitter.com/fuckrkn1")!) {
                        VStack {
                            Image("Twitter")
                            Text("Twitter")
                        }
                    }
                    Spacer()
                    
                    //FIXME: Add URL provider
                    Link(destination: URL(string: "https://github.com/nezavisimost/FuckRKN1")!) {
                        VStack {
                            Image("GitHub")
                            Text("GitHub")
                        }
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
            }
            .font(.exoBody)
            .padding(.horizontal)
        }
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}

//
//  ConnectView.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct ConnectView: View {
    
    let service = VPNService.shared

    enum ConnectionState {
        case disconnected
        case connecting
        case connected
    }
    
    enum SupplementaryScreen: Int, Identifiable {
        var id: Int {
            self.rawValue
        }
        
        case about
        case supportUs
    }
    
    @State var connectionState = ConnectionState.disconnected
    @State var shownSupplementaryScreen: SupplementaryScreen? = nil
    
    var body: some View {
        ZStack {
            Image("Noize")
                .resizable()
                .ignoresSafeArea()
            
            if connectionState == .disconnected || connectionState == .connecting {
                VStack {
                    Image("Wire")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(15.19))
                        .ignoresSafeArea()
                        .scaledToFit()
                    Image("Wire")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(-6.14))
                        .ignoresSafeArea()
                        .scaledToFit()
                    Spacer()
                    Image("Wire")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(8.87))
                        .ignoresSafeArea()
                        .scaledToFit()
                    Image("Wire")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(15.19))
                        .scaledToFit()
                }
            }
            
            
            VStack {
                HStack {
                    Button {
                        shownSupplementaryScreen = .about
                    } label: {
                        Text("About")
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        shownSupplementaryScreen = .supportUs
                    } label: {
                        Text("Support us")
                    }
                    .buttonStyle(.plain)
                }
                .font(.custom("Exo 2", size: 14, relativeTo: .body).bold())
                .padding()
                .foregroundColor(.primary)
                
                Spacer()
                
                if connectionState == .disconnected || connectionState == .connecting {
                    ZStack(alignment: .bottom) {
                        if connectionState == .connecting {
                            Image("Kremlin Fire")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Image("Kremlin")
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
                }
//                else {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("9.20")
//                                .font(.title) +
//                            Text(" Mb/s")
//                                .foregroundColor(.secondary)
//                            Text("\(Image(systemName: "arrow.down.circle.fill")) Download")
//                        }
//                        Spacer()
//
//                        VStack(alignment: .leading) {
//                            Text("6.45")
//                                .font(.title) +
//                            Text(" Mb/s")
//                                .foregroundColor(.secondary)
//                            Text("\(Image(systemName: "arrow.up.circle.fill")) Upload")
//                        }
//                    }
//                    .padding()
//                }
            }
            
            VStack(spacing: 0) {
                ZStack {
                    
//                    if connectionState == .connecting {
//                        Image("Fire")
//                            .resizable()
//                            .scaledToFit()
//                            .ignoresSafeArea()
//                    }
                    
                    Image("Pterodactyl")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 260)
                }
                .offset(y: 35)
                .zIndex(2)
                Button {
//                    withAnimation {
                    switch connectionState {
                    case .disconnected:
                        connectionState = .connecting
                    case .connecting:
                        connectionState = .connected
                    case .connected:
                        connectionState = .disconnected
                    }
//                    }
                } label: {
                    Image(connectionState == .connected ? "ConnectButtonConnected" : "ConnectButtonDisconnected")
                        .resizable()
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                .frame(width: 110, height: 110)
                Text(connectionStateString())
                    .font(.custom("Exo 2", size: 18, relativeTo: .body).bold())
            }
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        
        .sheet(item: $shownSupplementaryScreen) { screen in
            Group {
                switch screen {
                case .about:
                    AboutScreen()
                case .supportUs:
                    DonateScreen()
                }
            }
            .background(Color.white)
            .environment(\.colorScheme, .light)
#if os(macOS)
            .frame(minWidth: 340, maxWidth: 340, minHeight: 570, maxHeight: 570)
            
#endif
        }
    }
    
    func connectionStateString() -> String {
        switch connectionState {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        }
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
            .environment(\.colorScheme, .light)
#if os(macOS)
            .frame(minWidth: 340, maxWidth: 340, minHeight: 570, maxHeight: 570)
        
#endif
    }
}


// MARK: - Functions

func startTunneling() {
    
}

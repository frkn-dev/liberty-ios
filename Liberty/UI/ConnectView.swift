//
//  ConnectView.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import Combine
import SwiftUI
import NetworkExtension

struct ConnectView: View {
    
    let vpnService = VPNService.shared
    
    enum SupplementaryScreen: Int, Identifiable {
        var id: Int {
            self.rawValue
        }
        
        case about
        case supportUs
    }
    
    // MARK: - View
    
    @State var connectionState: ConnectionState = .disconnected
    @State var shownSupplementaryScreen: SupplementaryScreen? = nil
    
    var body: some View {
        ZStack {
            Image("Noize")
                .resizable()
                .ignoresSafeArea()
            
            if connectionState != .connected {
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
                
                if connectionState != .connected {
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
            }
            
            VStack(spacing: 0) {
                ZStack {
                    Image("Pterodactyl")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 260)
                }
                .offset(y: 35)
                .zIndex(2)
                Button {
                    switch connectionState {
                    case .disconnected: vpnService.connectVPN()
                    case .connected: vpnService.disconnectVPN()
                    default: break
                    }
                } label: {
                    Image(connectionState == .connected ? "ConnectButtonConnected" : "ConnectButtonDisconnected")
                        .resizable()
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                .frame(width: 110, height: 110)
                Text(connectionState.rawValue)
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
        }.onAppear(perform: setupValues)
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

extension ConnectView {
    
    private func setupValues() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange,
                                               object: nil,
                                               queue: nil) { notification in

            let nevpnconn = notification.object as! NEVPNConnection
            if let state = ConnectionState(nevpnconn.status) {
                connectionState = state
                
                print("VPN connection status is \(state)")
            }
        }
    }
}

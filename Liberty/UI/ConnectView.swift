//
//  ConnectView.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import Combine
import SwiftUI
import WidgetKit
import NetworkExtension
import TunnelKit

struct ConnectView: View {
    
    let vpnService = WireGuardService.shared
    
    enum SupplementaryScreen: Int, Identifiable {
        var id: Int {
            self.rawValue
        }
        
        case about
        case supportUs
    }
    
    // MARK: - View
    
    @State var connectionState: VPNStatus = .disconnected
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
                        Text("about")
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        shownSupplementaryScreen = .supportUs
                    } label: {
                        Text("support.us")
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
                .background() {
                    if connectionState == .connected {
                        PulseView()
                    }
                }
                Text(connectionState.rawValue.uppercasedFirst())
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
        .onAppear(perform: lastConnectionState)
        .onAppear(perform: setupValues)
    }
}

struct PulseView: View {
    
    var pulseColor = Color(red: 25/255, green: 184/255, blue: 146/255)
    
    @State var animate = false
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(pulseColor)
                .frame(width: 300, height: 300)
                .opacity(animate ? 0 : 0.25)
                .scaleEffect(animate ? 1 : 0.75)
            
            Circle()
                .fill(pulseColor)
                .frame(width: 300, height: 300)
                .opacity(animate ? 0.25 : 0.5)
                .scaleEffect(animate ? 0.75 : 0.5)

            Circle()
                .fill(pulseColor)
                .frame(width: 300, height: 300)
                .opacity(animate ? 0.5 : 0.75)
                .scaleEffect(animate ? 0.5 : 0.25)

            Circle()
                .fill(pulseColor)
                .frame(width: 300, height: 300)
                .opacity(animate ? 0.75 : 1)
                .scaleEffect(animate ? 0.25 : 0)
            
            Circle().foregroundColor(.white).frame(width: 108, height: 108)
        }
        .onAppear {
            animate.toggle()
        }
        .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false),
                   value: animate)
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
 
    // MARK: - Start functions
    
    private func setupValues() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange,
                                               object: nil,
                                               queue: nil) { notification in

            if let nevpnConnect = notification.object as? NEVPNConnection,
               let state = VPNStatus(nevpnConnect.status) {
                connectionState = state
                
                updateWidgetWith(state)
                
                print("VPN status is \(state)")
            }
        }
    }
    
    private func lastConnectionState() {
        
        let state = vpnService.vpnStatus
        
        connectionState = state
        updateWidgetWith(state)
    }
    
    private func updateWidgetWith(_ state: VPNStatus) {
        
        Defaults.ConnectionData.connectionStatus = state.rawValue
        
        Delay().execute(after: 0.5) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

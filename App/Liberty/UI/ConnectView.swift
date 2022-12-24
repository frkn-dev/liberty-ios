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
    
    // MARK: - Properties
    
    let vpnService     = WireGuardService.shared
    let networkService = NetworkService.shared
    
    enum SupplementaryScreen: Int, Identifiable {
        var id: Int {
            self.rawValue
        }
        
        case about
        case supportUs
        case countries
    }
    
    var connectionStateDescription: String {
        
        switch connectionState {
        case .connected:
            return String(localized: "status.connected")
        case .connecting:
            return String(localized: "status.connecting")
        default:
            return String(localized: "status.disconnected")
        }
    }
    
    // MARK: - View
    
    @State var selectedCountry: Country = .netherlands
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
                
                Spacer()
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
                    case .disconnected:
                        connectionState = .connecting
                        vpnService.connectVPN()
                    case .connected:
                        vpnService.disconnectVPN()
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
                Text("\(connectionStateDescription)")
                    .font(.custom("Exo 2", size: 18, relativeTo: .body).bold())
                
                Spacer()
                
                Button {
                    shownSupplementaryScreen = .countries
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(String(localized: "country.button").uppercased())
                                .font(.custom("Exo 2", size: 9, relativeTo: .body))
                                .foregroundColor(.gray)
                            Text("\(selectedCountry.description)")
                                .font(.custom("Exo 2", size: 14, relativeTo: .body).bold())
                        }
                        Spacer()
                        Image("downArrow")
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(.white)
                    .overlay() {
                            RoundedRectangle(cornerRadius: 8,
                                             style: .continuous)
                            .stroke(.gray)
                    }
                }
                .frame(minWidth: 307, idealWidth: 339, maxWidth: 350, idealHeight: 46)
                .buttonStyle(.plain)
                .foregroundColor(.black)
                .cornerRadius(8)
                Spacer()
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
                case .countries:
                    CountriesScreen()
                }
            }
            .background(Color.white)
            .environment(\.colorScheme, .light)
        #if os(macOS)
            .frame(width: 400, height: 620)
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
            .frame(width: 400, height: 620)
        #endif
    }
}

extension ConnectView {
 
    // MARK: - Start functions
    
    private func setupValues() {
        
        networkService.networkObservers.append(self)
        selectedCountry = networkService.selectedCountry
        
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

extension ConnectView: NetworkObserver {
    
    func countryUpdated() {
        selectedCountry = networkService.selectedCountry
    }
}

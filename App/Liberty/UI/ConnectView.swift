//
//  ConnectView.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import Combine
import SwiftUI
import WidgetKit
import CoreHaptics
import NetworkExtension
import TunnelKit

struct ConnectView: View {
    
    // MARK: - Properties
    
    let wireGuardService = WireGuardService.shared
    let networkService   = NetworkService.shared
    let countryService   = CountryService.shared
    
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
    
    @State var engine: CHHapticEngine?
    
    @State var selectedCountry: Country = Country()
    @State var connectionState: VPNStatus = .disconnected
    
    // MARK: - Alert
    
    @State var showGetLocationsError = false
    
    // MARK: - Toggle
    
    @State var dataWasLoaded = false
    @State var needNewCredentials = false
    
    // MARK: - View
    
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
                    tapOnConnectHaptic()
                    guard countryService.supportedCountries.isNotEmpty else { return }
                    switch connectionState {
                    case .disconnected:
                        connectionState = .connecting
                        wireGuardService.connectVPN(needsNewConfig: needNewCredentials)
                    case .connected:
                        wireGuardService.disconnectVPN()
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
                
                if dataWasLoaded {
                    Button {
                        shownSupplementaryScreen = .countries
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(String(localized: "country.button").uppercased())
                                    .font(.custom("Exo 2", size: 9, relativeTo: .body))
                                    .foregroundColor(.gray)
                                Text(selectedCountry.name)
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
                    .frame(minWidth: 307, idealWidth: 339, maxWidth: 350, idealHeight: 38)
                    .buttonStyle(.plain)
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .padding(10)
                } else {
                    ProgressView()
                        .frame(height: 38)
                        .padding(10)
                }
                HStack {
                    Image("profileButton")
                        .resizable()
                        .frame(maxWidth: 16, maxHeight: 16)
                        .aspectRatio(contentMode: .fit)
                    Toggle(
                        String(localized: "drop.credentials.button"),
                        isOn: $needNewCredentials)
                    .font(.custom("Exo 2", size: 14, relativeTo: .body).bold())
                }
                .padding([.horizontal], 10)
                .padding([.vertical], 4)
                .frame(minWidth: 307, idealWidth: 339, maxWidth: 350, idealHeight: 38, alignment: .leading)
                .cornerRadius(8)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 0.5)
                )
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
        .onAppear(perform: checkUpdates)
        .onAppear(perform: getLocations)
        .alert(String(localized: "error.get.locations.title"), isPresented: $showGetLocationsError) {
            Button(String(localized: "retry.button"), role: .cancel) { getLocations() }
        } message: {
            Text(String(localized: "error.get.locations.descr"))
        }
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
    
    private func lastConnectionState() {
        
        let state = wireGuardService.vpnStatus
        
        connectionState = state
        updateWidgetWith(state)
    }
    
    private func setupValues() {
        
        countryService.countryObservers.append(self)
        
        wireGuardService.observers.append(self)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange,
                                               object: nil,
                                               queue: nil) { notification in

            if let nevpnConnect = notification.object as? NEVPNConnection,
               let state = VPNStatus(nevpnConnect.status) {
                
                connectionState = state
                updateWidgetWith(state)
                
                if state == .connected && needNewCredentials {
                    needNewCredentials = false
                }
                
                print("VPN status is \(state)")
            }
        }
    }
    
    private func checkUpdates() {
        
        let needUpdate     = true
        let appVersion     = Bundle.main.appVersion
        let lastAppVersion = Defaults.AppData.lastAppVersion
        
        if needUpdate, appVersion != lastAppVersion {
            
            Defaults.ConnectionData.lastConnectedCountry = nil
            Defaults.ConnectionData.connectionStatus = nil
            Defaults.ConnectionData.wireGuardConfig = nil
        }
        
        Defaults.AppData.lastAppVersion = appVersion
    }
    
    private func getLocations() {
        networkService.getLocations() { result in
            switch result {
            case .success(let countries):
                countryService.supportedCountries = countries
            case .failure:
                countryService.supportedCountries = []
                showGetLocationsError.toggle()
            }
        }
    }
    
    private func updateWidgetWith(_ state: VPNStatus) {
        
        Defaults.ConnectionData.connectionStatus = state.rawValue
        
        Delay().execute(after: 0.5) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

extension ConnectView: CountryObserver {
    
    func countryUpdated() {
        selectedCountry = countryService.selectedCountry
        dataWasLoaded = true
    }
}

extension ConnectView: VPNStatusObserver {
    
    func disconnectedByFailure() {
        
        connectionState = .disconnected
        updateWidgetWith(.disconnected)
    }
}

extension ConnectView {
    
    func tapOnConnectHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            // TODO: Add logging
        }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

            do {
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                // TODO: Add logging
            }
    }
}

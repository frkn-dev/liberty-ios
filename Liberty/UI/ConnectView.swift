//
//  ConnectView.swift
//  Liberty
//
//  Created by Alexey Ageev on 29.07.2022.
//

import SwiftUI

struct ConnectView: View {
    
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
        case countrySelection
        case protocolSelection
    }
    
    @State var connectionState = ConnectionState.disconnected
    @State var shownSupplementaryScreen: SupplementaryScreen? = nil
    
    var body: some View {
        ZStack {
            Image("Noize")
                .resizable()
                .ignoresSafeArea()
            
            if showWires {
                WiresView()
            }
            
            VStack {
                HeaderView(supplementaryScreen: $shownSupplementaryScreen)
                
                Spacer()
                
                if connectionState == .disconnected || connectionState == .connecting {
                    KremlinView(isOnFire: connectionState == .connecting)
                }
            }
            
            VStack {
                ZStack {
                    
//                    if connectionState == .connecting {
//                        Image("Fire")
//                            .resizable()
//                            .scaledToFit()
//                            .ignoresSafeArea()
//                            .offset(y: -40)
//                    }
                    
                    VStack(spacing: 0) {
                        Image("Pterodactyl")
                            .resizable()
                            .scaledToFit()
                            .offset(y: 40)
                        
                        Button(action: connectionButtonAction) {
                            Image("ConnectButtonConnected")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(connectionState == .connected ? .greenAccent : .primary)
                                .frame(width: 110, height: 110)
                        }
                        .buttonStyle(.plain)
                        .scaledToFit()
                    }
                }
                
                
                Text(connectionStateName())
                    .font(.exoTitle3.bold())
                    .transition(.opacity)
                    .animation(.none, value: connectionState)
                
                
                SelectionButton("Country") {
                    shownSupplementaryScreen = .countrySelection
                } content: {
                    Text("\(Image(systemName: "flag")) Argentina")
                        .font(.exoBody)
                }
                
                SelectionButton("Protocol") {
                    shownSupplementaryScreen = .protocolSelection
                } content: {
                    Text("WireGuard")
                        .font(.exoBody)
                }
            }
            .padding(.horizontal)
        }
        .background(Color.background)
        .ignoresSafeArea(edges: .bottom)
        
        .sheet(item: $shownSupplementaryScreen) { screen in
            Group {
                switch screen {
                case .about:
                    AboutScreen()
                case .supportUs:
                    DonateScreen()
                case .countrySelection:
                    CountrySelectionScreen()
                case .protocolSelection:
                    ProtocolSelectionScreen()
                }
            }
        }
    }
    
    private func connectionStateName() -> String {
        switch connectionState {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        }
    }
    
    private func connectionButtonAction() {
        withAnimation {
            switch connectionState {
            case .disconnected:
                connectionState = .connecting
            case .connecting:
                connectionState = .connected
            case .connected:
                connectionState = .disconnected
            }
        }
    }
    
    private var showWires: Bool {
        connectionState == .disconnected || connectionState == .connecting
    }
}

struct ConnectView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectView()
            #if os(macOS)
            .frame(minWidth: 340, maxWidth: 340, minHeight: 570, maxHeight: 570)
            #endif
    }
}


struct WiresView: View {
    
    private let image = Image("Wire")
        .resizable()
        .renderingMode(.template)
    
    var body: some View {
        VStack {
            image
                .foregroundColor(.gray)
                .rotationEffect(.degrees(15.19))
                .ignoresSafeArea()
                .scaledToFit()
            
            image
                .foregroundColor(.gray)
                .rotationEffect(.degrees(-6.14))
                .ignoresSafeArea()
                .scaledToFit()
            
            Spacer()
            
            image
                .foregroundColor(.gray)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(8.87))
                .ignoresSafeArea()
                .scaledToFit()
            
            image
                .foregroundColor(.gray)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(15.19))
                .scaledToFit()
        }
        .transition(
            .asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .bottom)
            )
        )
    }
}

struct HeaderView: View {
    
    @Binding var supplementaryScreen: ConnectView.SupplementaryScreen?
    
    var body: some View {
        HStack {
            Button {
                supplementaryScreen = .about
            } label: {
                Text("About")
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                supplementaryScreen = .supportUs
            } label: {
                Text("Support us")
            }
            .buttonStyle(.plain)
        }
        .font(.exoBody.bold())
        .padding()
        .foregroundColor(.primary)
    }
}

struct KremlinView: View {
    
    let isOnFire: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isOnFire {
                Image("Kremlin Fire")
                    .resizable()
                    .scaledToFit()
//                    .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity))
            }
            
            Image("Kremlin")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct SelectionButton<Content: View>: View {
    let label: String
    let content: Content
    let action: () -> ()
    
    init(_ label: String, action: @escaping () -> (), content: (() -> Content)?) {
        self.label = label
        if let content = content {
            self.content = content()
        } else {
            self.content = EmptyView() as! Content
        }
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(label)
                        .font(.exoCaption)
                        .foregroundColor(.secondary)
                    
                    content
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .padding(10)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .foregroundColor(.background)
        )
        .shadow(radius: 3)
    }
}

//
//  VPN_Widget.swift
//  VPN Widget
//
//  Created by Yury Soloshenko on 08.10.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> WidgetContent {
        WidgetContent(date: Date(),
                      connectionState: .disconnected)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> Void) {
        
        let entry: WidgetContent
        entry = WidgetContent(date: Date(),
                              connectionState: WidgetUtils.connectionState)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetContent>) -> Void) {
        
        var entries: [WidgetContent] = []
        
        let everySecond: TimeInterval = 1
        var currentDate = Date()
        guard let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) else { return }
        while currentDate < endDate {
            let entry = WidgetContent(date: Date(),
                                      connectionState: WidgetUtils.connectionState)
            entries.append(entry)
            currentDate += everySecond
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct VPN_WidgetEntryView : View {
    
    var entry: Provider.Entry
    var family: WidgetFamily = .systemSmall
    
    var deeplink: String {
        switch entry.connectionState {
        case .connected: return "widget://disconnectVPN"
        default: return "widget://connectVPN"
        }
    }
    
    var buttonTitle: String {
        switch entry.connectionState {
        case .connected:
            return String(localized: "status.connected")
        case .connecting:
            return String(localized: "status.connecting")
        default:
            return String(localized: "status.disconnected")
        }
    }
        
    var backgroundImage: String {
        switch entry.connectionState {
        case .connected: return "ConnectedBackground"
        case .connecting: return "ConnectedBackground"
        default: return "DisconnectBackground"
        }
    }
    
    var borderColor: Color {
        switch entry.connectionState {
        case .connected: return Color(red: 25/255, green: 184/255, blue: 146/255)
        default: return Color(red: 134/255, green: 134/255, blue: 134/255)
        }
    }
    
    var body: some View {
        VStack {
            Image("DisconnectBird")
                .background() {
                    if entry.connectionState == .connecting {
                            Image("ConnectingFire")
                                .resizable()
                                .padding(.vertical, -40)
                                .padding(.horizontal, -30)
                    }
                }
            Button {}
            label: {
                Text(buttonTitle)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(borderColor, lineWidth: 1)
                    .padding(EdgeInsets(top: -6, leading: -14, bottom: -6, trailing: -14))
            )
            .padding(.horizontal, 22)
            .tint(.black)
            .font(.custom("Exo 2", size: 12, relativeTo: .body).bold())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .background() {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
        }
        .widgetURL(URL(string: deeplink))
    }
}

@main
struct VPN_Widget: Widget {
    
    let kind: String = "Liberty iOS widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VPN_WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Liberty iOS")
        .description("This is a FuckRKN1 VPN widget")
    }
}

struct VPN_Widget_Previews: PreviewProvider {
    static var previews: some View {
        VPN_WidgetEntryView(entry: WidgetContent(date: Date(), connectionState: WidgetUtils.connectionState))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

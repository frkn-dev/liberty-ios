//
//  VPN_Widget.swift
//  VPN Widget
//
//  Created by Yury Soloshenko on 08.10.2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> ()) {
        
        if context.isPreview {
            let entry = Entry(date: Date(), configuration: ConfigurationIntent())
            completion(entry)
        } else {
            let entry = Entry(date: Date(), configuration: ConfigurationIntent())
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        var entries: [Entry] = [Entry(date: Date(), configuration: ConfigurationIntent())]
        
        let everySecond: TimeInterval = 1
        var currentDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        while currentDate < endDate {
            let entry = Entry(date: Date(), configuration: ConfigurationIntent())
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
        switch Defaults.ConnectionData.connectionStatus {
        case "Connected": return "widget://disconnectVPN"
        default: return "widget://connectVPN"
        }
    }
    
    var buttonTitle: String {
        switch Defaults.ConnectionData.connectionStatus {
        case "Connected": return "Connected"
        case "Connecting": return "Connecting..."
        default: return "Disconnected"
        }
    }
        
    var backgroundImage: String {
        switch Defaults.ConnectionData.connectionStatus {
        case "Connected": return "ConnectedBackground"
        case "Connecting": return "ConnectedBackground"
        default: return "DisconnectBackground"
        }
    }
    
    var borderColor: Color {
        switch Defaults.ConnectionData.connectionStatus {
        case "Connected": return Color(red: 25/255, green: 184/255, blue: 146/255)
        default: return Color(red: 134/255, green: 134/255, blue: 134/255)
        }
    }
    
    var body: some View {
        VStack {
            Image("DisconnectBird")
            Button(buttonTitle) {
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
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            VPN_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Liberty iOS")
        .description("This is a FuckRKN1 VPN widget")
    }
}

struct VPN_Widget_Previews: PreviewProvider {
    static var previews: some View {
        VPN_WidgetEntryView(entry: Entry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

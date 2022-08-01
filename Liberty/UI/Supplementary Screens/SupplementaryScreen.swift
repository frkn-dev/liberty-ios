//
//  SupplementaryScreen.swift
//  Liberty
//
//  Created by Алексей Агеев on 02.08.2022.
//

import SwiftUI

/// Generic screen to make another screens
struct SupplementaryScreen<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Text("\(Image(systemName: "arrow.left")) Back")
                }
                .buttonStyle(.plain)
                .font(.exoBody.bold())
                .padding(.horizontal)
                
                content
            }
            .padding(.vertical)
        }
        .background(Image("Noize"))
        .background(Color.background)
        #if os(macOS)
        .frame(width: UIConstants.windowWidth, height: UIConstants.windowHeight)
        #endif
        .preferredColorScheme(.light)
    }
}

struct SupplementaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SupplementaryScreen {
            Group {
                Text("Lorem ipsum dolor sit amet,")
                    .font(.exoTitle.bold()) +
                Text(" consectetur adipiscing elit. Morbi suscipit velit odio, id sagittis leo commodo feugiat. In placerat turpis nibh, et tincidunt dui sollicitudin ac. Curabitur luctus imperdiet tellus. Fusce fringilla, ligula eu mattis congue, urna felis sollicitudin urna, vel blandit quam eros a neque. Curabitur ligula arcu, sodales in arcu et, molestie ullamcorper nisl. Sed vulputate aliquet rutrum. Suspendisse felis arcu, ultrices id maximus vel, sodales in velit. Proin vulputate pulvinar augue, vel tincidunt leo consequat vel. Maecenas sagittis eget nulla ut varius. Pellentesque nec nibh ultricies, lobortis metus eget, auctor justo.")
            }.padding()
        }
    }
}

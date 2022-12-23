//
//  CountriesScreen.swift
//  Liberty
//
//  Created by Yury Soloshenko on 23.12.2022.
//

import SwiftUI

struct CountriesScreen: View {
    
    // MARK: - Properties
    
    let networkService = NetworkService.shared
    
    let supportedCountries: [Country] = [
        .netherlands,
        .russia,
        .ukraine,
        .unitedKingdom,
        .usa
    ]
    
    // MARK: -
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Text("\(Image(systemName: "arrow.left")) \(String(localized:  "back.button"))")
                }
                .buttonStyle(.plain)
                .font(.custom("Exo 2", size: 14, relativeTo: .title).bold())
                
                ForEach(supportedCountries, id: \.self) { item in
                    Button {
                        networkService.selectedCountry = item
                        dismiss()
                    } label: {
                        HStack {
                            Text(item.description)
                                .font(.custom("Exo 2", size: 14, relativeTo: .title).bold())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Image("Noize"))
    }
}

struct CountriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CountriesScreen()
    }
}

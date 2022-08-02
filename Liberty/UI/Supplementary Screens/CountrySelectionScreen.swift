//
//  CountrySelectionScreen.swift
//  Liberty
//
//  Created by Alexey Ageev on 02.08.2022.
//

import SwiftUI

struct CountrySelectionScreen: View {
    
    let countries = ["Argentina",
                    "Australia",
                     "Austria",
                     "Belgium",
                     "Brazil",
                     "Bulgaria",
                     "Cambodia",
                     "Canada",
                     "Chile",
                     "Colombia",
                     "Costa Rica",
                     "Cyprus",
                     "Czechia"]
    
    var body: some View {
        SupplementaryScreen {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(countries, id: \.self) { country in
                    HStack {
                        Text("\(Image(systemName: "flag")) \(country)")
                            .font(.exoTitle3.bold())
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CountrySelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectionScreen()
    }
}





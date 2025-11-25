//
//  SectionHeader.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
    }
}

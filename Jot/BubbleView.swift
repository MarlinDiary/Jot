//
//  BubbleView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI

struct BubbleView: View {
    var text: String
    var body: some View {
        Text(text)
            .padding(11)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundStyle(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .stroke(Color("GrayS"), lineWidth: 1)
                    }
            }
    }
}

#Preview {
    ZStack {
        Color("GrayL")
            .edgesIgnoringSafeArea(.all)
        BubbleView(text: "Hello, World!")
    }
}

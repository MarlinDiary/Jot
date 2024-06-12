//
//  HeadView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI

struct HeadView: View {
    let color: Color
    
    var body: some View {
        ZStack{
            RoundView(top: 25, bottom: 0)
            HStack(spacing: 20) {
                Image(systemName: "circle.fill")
                    .font(.title2)
                    .foregroundStyle(color)
                Spacer()
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HeadView(color: Color.red)
}

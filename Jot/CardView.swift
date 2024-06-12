//
//  CardView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI
import SwiftData

struct CardView: View {
    @State var page: Page
    @Binding var scrollID: UUID?
    
    @Query var messages: [Message]
    
    var messagesFiltered: [Message] {
        messages.filter { $0.type == page.type
        }.sorted { $0.sequentialID < $1.sequentialID }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeadView(color: page.color)
            Rectangle()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "#FFFFFF"), Color(hex: "#FBFBFB")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay {
                    Rectangle()
                        .stroke(Color("GrayS"), lineWidth: 1)
                }
                .overlay {
                    ScrollView {
                        ScrollViewReader { proxy in
                            LazyVStack(alignment: .trailing, spacing: 0) {
                                ForEach(messagesFiltered, id: \.id) { message in
                                    BubbleView(text: message.text)
                                        .padding(.bottom, 11)
                                        .padding(.horizontal, 11)
                                        .id(message.id)
                                }
                            }
                            .padding(.top, 11)
                            .onChange(of: scrollID) { oldValue, newValue in
                                withAnimation(.spring()) {
                                    proxy.scrollTo(newValue)
                                }
                            }
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .defaultScrollAnchor(.bottom)
                }
            Rectangle()
                .stroke(Color("GrayS"), lineWidth: 0)
                .frame(height: 0.5)
        }
        
    }
}

#Preview {
    CardView(page: Page(type: 1), scrollID: .constant(UUID()))
}
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
    @Binding var scrollID: Int?
    
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
                    ScrollView(showsIndicators: false) {
                        ScrollViewReader { proxy in
                            LazyVStack(alignment: .trailing, spacing: 10) {
                                ForEach(messagesFiltered, id: \.id) { message in
                                    BubbleView(text: message.text)
                                        .padding(.horizontal, 10)
                                        .id(message.sequentialID)
                                }
                            }
                            .padding(.top, 10)
                            .onChange(of: scrollID) { oldValue, newValue in
                                withAnimation(.spring()) {
                                    proxy.scrollTo(newValue)
                                }
                            }
                            .onAppear {
                                if let lastPosition = messagesFiltered.last?.sequentialID {
                                    proxy.scrollTo(lastPosition)
                                }
                            }
                        }
                    }
                    .contentMargins(.bottom, 14.5)
                    //.scrollBounceBehavior(.basedOnSize)
                    //.defaultScrollAnchor(.bottom)
                }
        }
        
    }
}

#Preview {
    CardView(page: Page(type: 1), scrollID: .constant(1))
}

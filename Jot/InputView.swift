//
//  InputView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI
import SwiftData

struct InputView: View {
    var type: Int
    @State var text: String = ""
    @Binding var scrollToBottomID: UUID?
    
    @Environment(\.modelContext) var modelContext
    @Query var messages: [Message]
    
    var body: some View {
        ZStack {
            RoundView()
            HStack {
                TextField("Enter your text here...", text: $text)
                    .frame(height: 60)
                    .submitLabel(.done)
                Button {
                    sendAction()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.black)
                    
                }
            }
            .padding(.horizontal)
        }
    }
    
    func sendAction() {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("Nothing to Send")
        } else {
            let message = Message(text: text, type: type)
            modelContext.insert(message)
            scrollToBottomID = message.id
        }
        
        Task {
            text = ""
        }
    }
}

#Preview {
    do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Message.self, configurations: config)

            return InputView(type: 1, scrollToBottomID: .constant(UUID()))
                .modelContainer(container)
        } catch {
            return Text("Failed to create preview: \(error.localizedDescription)")
        }
}

struct RoundView: View {
    var top:CGFloat = 0
    var bottom:CGFloat = 25
    var body: some View {
        UnevenRoundedRectangle(cornerRadii: .init(topLeading: top, bottomLeading: bottom, bottomTrailing: bottom, topTrailing: top), style: .continuous)
            .foregroundStyle(.white)
            .overlay(
                UnevenRoundedRectangle(
                    cornerRadii: .init(topLeading: top, bottomLeading:bottom, bottomTrailing: bottom, topTrailing: top),
                    style: .circular
                )
                .stroke(Color("GrayS"), lineWidth: 1)
            )
            .frame(height: 60)
    }
}

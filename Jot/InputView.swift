//
//  InputView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI
import SwiftData

struct InputView: View {
    @Binding var type: Int
    var typeFunc: (() -> Void)? = nil
    @AppStorage("text") var text: String = ""
    @Binding var scrollToBottomID: Int?
    
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
            typeFunc?()
            let message = Message(text: text, type: type)
            modelContext.insert(message)
            scrollToBottomID = message.sequentialID
        }
            text = ""
    }
}

#Preview {
    do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Message.self, configurations: config)

        return InputView(type: .constant(1), scrollToBottomID: .constant(1))
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

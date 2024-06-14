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
    @AppStorage("text") var text: String = ""
    @Binding var scrollToBottomID: Int?
    
    @Environment(\.modelContext) var modelContext
    @Query var messages: [Message]
    
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        ZStack {
            RoundView()
                .onTapGesture {
                    if amountIsFocused == false {
                        amountIsFocused = true
                    }
                }
            HStack {
                TextField("Enter your text here...", text: $text)
                    .tint(.black)
                    .submitLabel(.done)
                    .focused($amountIsFocused)
                    .onAppear {
                        //amountIsFocused = true
                    }
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
            scrollToBottomID = message.sequentialID
        }
        text = ""
    }
    
    func colorForType(type: Int) -> Color {
            switch type {
            case 1:
                return .red
            case 2:
                return .orange
            case 3:
                return .yellow
            case 4:
                return .green
            case 5:
                return .indigo
            case 6:
                return .blue
            case 7:
                return .purple
            default:
                return .gray
            }
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
            .frame(height: 50)
    }
}

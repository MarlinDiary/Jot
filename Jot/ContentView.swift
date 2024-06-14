//
//  ContentView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI

struct ContentView: View {
    @State var pages:[Page] = [Page(type: 1, color: Color.red), Page(type: 2, color: Color.orange), Page(type: 3, color: Color.yellow), Page(type: 4, color: Color.green), Page(type: 5, color: Color.indigo), Page(type: 6, color: Color.blue), Page(type: 7, color: Color.purple)]
    
    @State var scrollID: Int?
    
    @AppStorage("Page") var currentPage: Int = 1
    
    var body: some View {
        ZStack {
            Color("GrayL")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                            ForEach(pages, id: \.self) { page in
                                CardView(page: page, scrollID: $scrollID)
                                    .padding(.horizontal)
                                    .frame(width: UIScreen.main.bounds.width)
                                    .tag(page.type)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                
                InputView(type: $currentPage, scrollToBottomID: $scrollID)
                .padding(.bottom)
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Message.self)
}

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
    
    @AppStorage("Offset") var offset = 0.0
    
    @State var currentPage: Int = 1
    
    var body: some View {
        ZStack {
            Color("GrayL")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        ZStack(alignment:.leading) {
                            HStack(spacing: 0) {
                                ForEach(pages, id: \.self) { page in
                                    CardView(page: page, scrollID: $scrollID)
                                        .padding(.horizontal)
                                        .frame(width: UIScreen.main.bounds.width)
                                        .id(page.type)
                                }
                            }
                            GeometryReader {geometry in
                                Circle()
                                    .opacity(0)
                                    .frame(width: 10)
                                    .onChange(of: geometry.frame(in: .global).minX) { oldValue, newValue in
                                        offset = -geometry.frame(in: .global).minX
                                        
                                    }
                                
                                
                            }
                        }
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollIndicators(.hidden)
                    .onAppear {
                        let screenWidth = Double(UIScreen.main.bounds.width)
                        currentPage = max(1, min(7, Int((offset / screenWidth).rounded()) + 1))
                        proxy.scrollTo(currentPage)
                    }
                }
                
                InputView(type: $currentPage, typeFunc: {
                    let screenWidth = Double(UIScreen.main.bounds.width)
                    currentPage = max(1, min(7, Int((offset / screenWidth).rounded()) + 1))
                }, scrollToBottomID: $scrollID)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width)
            }
            //Text("\(offset)" + "page" + "\(currentPage)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Message.self)
}

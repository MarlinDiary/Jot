//
//  ContentView.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI

struct ContentView: View {
    @State var pages:[Page] = [Page(type: 1, color: Color.red), Page(type: 2, color: Color.orange), Page(type: 3, color: Color.yellow), Page(type: 4, color: Color.green), Page(type: 5, color: Color.indigo), Page(type: 6, color: Color.blue), Page(type: 7, color: Color.purple)]
    
    @State var scrollID: UUID?
    
    @State var offset: CGPoint = .zero
    
    var currentPage: Int {
        if offset.x < UIScreen.main.bounds.width {
            return 1
        } else if offset.x < UIScreen.main.bounds.width * 2 {
            return 2
        } else if offset.x < UIScreen.main.bounds.width * 3 {
            return 3
        } else if offset.x < UIScreen.main.bounds.width * 4 {
            return 4
        } else if offset.x < UIScreen.main.bounds.width * 5 {
            return 5
        } else if offset.x < UIScreen.main.bounds.width * 6 {
            return 6
        } else {
            return 7
        }
    }
    
    var body: some View {
        ZStack {
            Color("GrayL")
                .ignoresSafeArea()
            VStack(spacing: 0) {
                OffsetObservingScrollView(offset: $offset) {
                    LazyHStack(spacing: 0) {
                        ForEach(pages, id: \.self) { page in
                            CardView(page: page, scrollID: $scrollID)
                                .padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                }
                
                InputView(type: pages[currentPage - 1].type, scrollToBottomID: $scrollID)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width)
            }
            
            Text("\(currentPage)")
                .opacity(0)
                
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Message.self)
}

struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
@Binding var position: CGPoint
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
    key: PreferenceKey.self,
    value: geometry.frame(in: coordinateSpace).origin
)
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }

        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
    }
}

struct OffsetObservingScrollView<Content: View>: View {
    var axes: Axis.Set = [.horizontal]
    var showsIndicators = true
    @Binding var offset: CGPoint
    @ViewBuilder var content: () -> Content
    private let coordinateSpaceName = UUID()

    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
    x: -newOffset.x,
    y: -newOffset.y
)
                    }
                ),
                content: content
            )
        }
        .coordinateSpace(name: coordinateSpaceName)
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
    }
}

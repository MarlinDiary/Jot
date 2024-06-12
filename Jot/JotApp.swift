//
//  JotApp.swift
//  Jot
//
//  Created by Drawix on 2024/6/12.
//

import SwiftUI
import SwiftData

@main
struct JotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Message.self)
    }
}

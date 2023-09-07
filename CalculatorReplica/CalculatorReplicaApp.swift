//
//  CalculatorReplicaApp.swift
//  CalculatorReplica
//
//  Created by Isaac Okura on 7/27/23.
//

import SwiftUI

@main
struct CalculatorReplicaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}

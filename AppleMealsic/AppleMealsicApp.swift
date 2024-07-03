//
//  AppleMealsicApp.swift
//  AppleMealsic
//
//  Created by 이진 on 7/3/24.
//

import SwiftUI

@main
struct AppleMealsicApp: App {
    
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}

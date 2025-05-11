//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Роман Вертячих on 11.05.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

#Preview {
    ContentView()
}


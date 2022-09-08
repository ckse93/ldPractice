//
//  ContentView.swift
//  launchdarklyPractice
//
//  Created by Chan Jung on 9/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var ldService = LDService.shared
    
    var body: some View {
        VStack {
            if ldService.testFlag {
                Text("feature flag on!")
                    .font(.title)
                    .foregroundColor(.blue)
            } else {
                Text("feature flag off!")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Text(ldService.ldMessage)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ReservesView()) {
                    Label("Ver reservas", systemImage: "list.clipboard")
                }
                
                NavigationLink(destination: ReservesView()) {
                    Label("Ver reservas pagadas", systemImage: "checkmark.rectangle.stack")
                }
            }
           
        }
    }
}

#Preview {
    ContentView()
}

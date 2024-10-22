//
//  MoreInfoView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 21-10-24.
//

import SwiftUI

struct MoreInfoView: View {
    
    @State private var reservesViewModel = ReservesViewModel()
    @State private var roses: [RoseModel] = []
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(roses, id: \.self) { rose in
                        HStack {
                            Text(rose.roseName)
                            
                            Spacer()
                            
                            Text("\(rose.roseQuantity)")
                        }
                    }
                } header: {
                    Text("Rosas pagadas")
                }
            }
        }
        .navigationTitle("Resumen de los pedidos")
        .task {
            await reservesViewModel.getReservesWithPaymentsInfo()
            roses = reservesViewModel.getTotalRosesByColor()
        }
    }
}

#Preview {
    MoreInfoView()
}

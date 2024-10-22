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
    @State private var totalOfRoses = 0
    @State private var quantityOfPhotos = 0
    @State private var totalOfMoneyCollected = 0
    
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
                    HStack {
                        Text("Rosas totales pagadas")
                        
                        Spacer()
                        
                        Text("\(totalOfRoses)")
                    }
                }
                
                Section {
                    HStack {
                        Text("Fotos con dedicatoria")
                        
                        Spacer()
                        
                        Text("\(quantityOfPhotos)")
                    }
                } header: {
                    Text("Cantidad de fotos con dedicatoria pagadas")
                }
                
                Section {
                    HStack {
                        Text("Total")
                        
                        Spacer()
                        
                        Text("$\(totalOfMoneyCollected)")
                    }
                    .bold()
                } header: {
                    Text("Total de dinero recaudado")
                } footer: {
                    Text("La suma total de todos los pedidos pagados.")
                }
            }
        }
        .navigationTitle("Resumen de los pedidos")
        .task {
            await reservesViewModel.getReservesWithPaymentsInfo()
            roses = reservesViewModel.getTotalRosesByColor()
            totalOfRoses = reservesViewModel.calcTotalOfRoses(roses: roses)
            quantityOfPhotos = reservesViewModel.getQuantityOfPhotos()
            totalOfMoneyCollected = reservesViewModel.calcTotalOfMoneyCollected()
        }
    }
}

#Preview {
    MoreInfoView()
}

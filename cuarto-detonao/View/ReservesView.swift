//
//  ReservesView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import SwiftUI

struct ReservesView: View {
    @State private var viewModel = ReservesViewModel()
    @State private var fetchingData = false
    var body: some View {
        NavigationStack {
            if fetchingData {
                VStack {
                    Text("Obteniendo datos")
                    
                    ProgressView()
                        .scaleEffect(1.4)
                }
            } else {
                List(viewModel.reserves, id: \.id) { reserve in
                    LazyVStack {
                        NavigationLink(destination: ReserveView(reserveModel: reserve)) {
                            HStack(spacing: 30) {
                                Text(String(reserve.id))
                                
                                Text("\(reserve.remitenteNombre) \(reserve.remitenteApellido)")
                                
                                Spacer()
                                
                                Text("$\(reserve.totalAPagar)")
                            }
                        }
                        .contextMenu {
                            Button {
                                //
                            } label: {
                                Label("Pagar", systemImage: "creditcard")
                            }
                            
                            Button {
                                //
                            } label: {
                                Label("Ver detalles", systemImage: "info.circle")
                            }
                            
                            Button {
                                //
                            } label: {
                                Label("Editar", systemImage: "pencil.and.list.clipboard")
                            }
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                //
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchReserves()
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("\(viewModel.reserves.count) Reservas")
        .task {
            fetchingData = true
            await viewModel.fetchReserves()
            fetchingData = false
        }
    }
}

#Preview {
    ReservesView()
}

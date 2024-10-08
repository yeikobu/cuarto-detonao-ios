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
    @State private var searchedText = ""
    
    var searchResults: [ReserveModel] {
        if searchedText.isEmpty {
            return viewModel.reserves
        } else {
            return viewModel.reserves.filter { $0.remitenteNombre.contains(searchedText) || $0.remitenteApellido.contains(searchedText) || $0.id == Int(searchedText)}
        }
    }
    
    var body: some View {
        NavigationStack {
            if fetchingData {
                VStack {
                    Text("Obteniendo datos")
                    
                    ProgressView()
                        .scaleEffect(1.4)
                }
            } else {
                List(searchResults, id: \.id) { reserve in
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
                .toolbar {
                    ToolbarItem {
                        Button("Nueva reserva") {
                            
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchReserves()
                    }
                }
                .searchable(text: $searchedText, prompt: "Busca por id, nombre o apellido") {}
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

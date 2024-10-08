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
    
    // Estados para borrar reserva
    @State private var showDeleteWarning = false
    @State private var deletingData = false
    @State private var isReserveDeleted = false
    @State private var reserveToDelete: ReserveModel? 
    
    // Estado de la búsqueda de una reserva
    @State private var searchedText = ""
    
    var searchResults: [ReserveModel] {
        get {
            if searchedText.isEmpty {
                return viewModel.reserves
            } else {
                return viewModel.reserves.filter { $0.remitenteNombre.contains(searchedText) || $0.remitenteApellido.contains(searchedText) || $0.id == Int(searchedText) }
            }
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
                    NavigationLink(destination: ReserveView(reserveModel: reserve)) {
                        HStack(spacing: 30) {
                            Text(String(reserve.id))
                            Text("\(reserve.remitenteNombre) \(reserve.remitenteApellido)")
                            Spacer()
                            Text("$\(reserve.totalAPagar)")
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
                                reserveToDelete = reserve // Asigna la reserva seleccionada
                                showDeleteWarning = true  // Muestra la alerta
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                        .alert(isPresented: $showDeleteWarning) {
                            Alert(
                                title: Text("¿Quieres eliminar la reserva de \(reserveToDelete?.remitenteNombre ?? "")?"),
                                primaryButton: .destructive(Text("Eliminar")) {
                                    Task {
                                        if let reserve = reserveToDelete {
                                            deletingData = true
                                            isReserveDeleted = await viewModel.deleteReserveByID(id: reserve.id)
                                            if isReserveDeleted {
                                                if let index = viewModel.reserves.firstIndex(where: { $0.id == reserve.id }) {
                                                    viewModel.reserves.remove(at: index)
                                                }
                                            }
                                            deletingData = false
                                            reserveToDelete = nil
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancelar")) {
                                    reserveToDelete = nil // Resetear la reserva seleccionada si se cancela
                                }
                            )
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button("Nueva reserva") {
                            // Acción para nueva reserva
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchReserves()
                    }
                }
                .searchable(text: $searchedText, prompt: "Busca por id, nombre o apellido") {}
                .overlay {
                    if deletingData {
                        VStack {
                            Text("Eliminando reserva..")
                                .font(.title2)
                            
                            ProgressView()
                                .scaleEffect(1.4)
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
            }
        }
        .navigationTitle("\(viewModel.reserves.count) Reservas")
        .alert("Reserva eliminada exitosamente", isPresented: $isReserveDeleted) {
            Button("Aceptar") {}
        }
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

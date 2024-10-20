//
//  ReservesView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import SwiftUI

struct ReservesView: View {
    @State private var viewModel = ReservesViewModel()
    @State private var paymentsViewModel = PaymentsViewModel()
    @State private var fetchingData = false
    
    // Estados para borrar reserva
    @State private var showDeleteWarning = false
    @State private var deletingData = false
    @State private var isReserveDeleted = false
    @State private var reserveToDelete: ReserveWithPaymentModel?
    
    // Estado de la búsqueda de una reserva
    @State private var searchedText = ""
    
    @State private var newReserve = false
    
    // Estados para los págos
    @State private var showCreatePaymentView = false
    @State private var showCreatingPaymentMessage = false
    @State private var selectedReserveToPay: ReserveWithPaymentModel = ReserveWithPaymentModel(id: 0, remitenteNombre: "", remitenteApellido: "", remitentePseudonimo: "", remitenteCurso: "", remitenteAnonimo: false, destinatarioNombre: "", destinatarioApellido: "", destinatarioPseudonimo: "", destinatarioCurso: "", totalAPagar: 0, dedicatoria: "", fotoURL: "", createdAt: "", pago: PaymentModel(id: 0, reservaID: 0, metodoPago: "", monto: 0, estado: "", fechaPago: ""), detalles: [])
    @State private var newPaymentResponse: NewPaymentResponse = NewPaymentResponse(message: "", paymentID: 0)
    @State private var isPaymentCreated = false
    
    //Estados para eliminar un pago
    @State private var paymentToDelete: ReserveWithPaymentModel?
    @State private var showDeletePaymentWarning = false
    @State private var isPaymentDeleted = false
    
    @State private var viewTitle = "Reservas totales"
    
    var searchResults: [ReserveWithPaymentModel] {
        let filteredReserves: [ReserveWithPaymentModel]
            
        // Aplicar el filtro seleccionado
        switch selectedFiler {
        case .todas:
            filteredReserves = viewModel.reserves
        case .pagadas:
            filteredReserves = viewModel.reserves.filter { $0.pago != nil }
        case .entregadas:
            filteredReserves = viewModel.reserves.filter { $0.pago?.estado == "Entregado" }
        case .nonDeliveried:
            filteredReserves = viewModel.reserves.filter { $0.pago?.estado != "No entregado" || $0.pago == nil }
        }
        
        if searchedText.isEmpty {
            return filteredReserves
        } else {
            return filteredReserves.filter {
                $0.remitenteNombre.contains(searchedText) ||
                $0.remitenteApellido.contains(searchedText) ||
                String($0.id).contains(searchedText)
            }
        }
    }
    
    
    enum Filter: String, CaseIterable, Identifiable {
        case todas, pagadas, entregadas
        case nonDeliveried = "No entregadas"
        var id: Self { self }
    }
    
    @State private var selectedFiler: Filter = .todas
    
    var body: some View {
        NavigationStack {
            if fetchingData {
                VStack {
                    Text("Obteniendo datos")
                    
                    ProgressView()
                        .scaleEffect(1.4)
                }
            } else {
                Picker("Filtros", selection: $selectedFiler) {
                    ForEach(Filter.allCases) { filter in
                        Text(filter.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)
                .onChange(of: selectedFiler) {
                    switch selectedFiler {
                    case .todas:
                        viewTitle = "Reservas totales"
                    case .pagadas:
                        viewTitle = "Reservas pagadas"
                    case .entregadas:
                        viewTitle = "Pedidos entregados"
                    case .nonDeliveried:
                        viewTitle = "Pedidos no entregados"
                    }
                }
                
                List(searchResults, id: \.id) { reserve in
                    NavigationLink(destination:
                                    ReserveView(reserveModel: reserve)
                                        .environment(paymentsViewModel)
                                        .environment(viewModel)
                    ) {
                        HStack(spacing: 30) {
                            Text(String(reserve.id))
                            Text("\(reserve.remitenteNombre) \(reserve.remitenteApellido)")
                            Spacer()
                            Text("$\(reserve.totalAPagar)")
                        }
                        .contextMenu {
                            if reserve.pago == nil {
                                Button {
                                    selectedReserveToPay = reserve
                                    showCreatePaymentView = true
                                } label: {
                                    Label("Pagar", systemImage: "creditcard")
                                }
                            }
                            
                            NavigationLink {
                                ReserveView(reserveModel: reserve)
                                    .environment(paymentsViewModel)
                                    .environment(viewModel)
                            } label: {
                                Label("Ver detalles", systemImage: "info.circle")
                            }
                            
                            NavigationLink {
                                UpdateReserveView(selectedReserve: reserve)
                            } label: {
                                Label("Editar", systemImage: "pencil.and.list.clipboard")
                            }
                            
                            Divider()
                            
                            if reserve.pago != nil {
                                Button(role: .destructive) {
                                    paymentToDelete = reserve
                                    showDeletePaymentWarning = true
                                } label: {
                                    Label("Eliminar pago", systemImage: "creditcard")
                                }
                            }
                            
                            Button(role: .destructive) {
                                reserveToDelete = reserve
                                showDeleteWarning = true
                            } label: {
                                Label("Eliminar Reserva", systemImage: "trash")
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
                        .alert(isPresented: $showDeletePaymentWarning) {
                            Alert(
                                title: Text("¿Quieres eliminar el pago de \(paymentToDelete?.remitenteNombre ?? "")?"),
                                primaryButton: .destructive(Text("Eliminar")) {
                                    Task {
                                        if let reserve = paymentToDelete {
                                            if let pago = reserve.pago {
                                                print(pago.id)
                                                deletingData = true
                                                isPaymentDeleted = await paymentsViewModel.deletePaymentByID(id: pago.id)
                                                print(isPaymentDeleted)
                                                if isPaymentDeleted {
                                                    if let index = viewModel.reserves.firstIndex(where: { $0.id == reserve.id }) {
                                                        viewModel.reserves[index].pago = nil
                                                    }
                                                }
                                                deletingData = false
                                                paymentToDelete = nil
                                            }
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancelar")) {
                                    paymentToDelete = nil // Resetear la reserva seleccionada si se cancela
                                }
                            )
                        }
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.getReservesWithPaymentsInfo()
                    }
                }
                .searchable(text: $searchedText, prompt: "Número reserva, nombre o apellido") {}
                .sheet(isPresented: $showCreatePaymentView) {
                    CreatePaymentView(reserve: $selectedReserveToPay, showCreatingPaymentMessage: $showCreatingPaymentMessage, newPaymentResponse: $newPaymentResponse)
                        .presentationDetents([.height(350)])
                        .presentationDragIndicator(.visible)
                        .environment(paymentsViewModel)
                        .onDisappear {
                            if let pago = selectedReserveToPay.pago {
                                if let reserveToReplaceIndex = viewModel.reserves.firstIndex(where: { $0.id == selectedReserveToPay.id }) {
                                    print(reserveToReplaceIndex)
                                    viewModel.reserves[reserveToReplaceIndex].pago = pago
                                }
                            }
                        }
                }
                .overlay {
                    if deletingData {
                        WaitingAlertView(message: "Eliminando Reserva...")
                    }
                }
            }
        }
        .navigationTitle("\(searchResults.count) \(viewTitle)")
        .sheet(isPresented: $newReserve) {
            NavigationStack {
                NewReserveView()
            }
        }
        .alert("Reserva eliminada exitosamente", isPresented: $isReserveDeleted) {
            Button("Aceptar") {}
        }
        .alert("\(newPaymentResponse.message)", isPresented: $paymentsViewModel.isPaymentCreated) {
            Button("Aceptar") { }
        }
        .task {
            fetchingData = true
            await viewModel.getReservesWithPaymentsInfo()
            fetchingData = false
        }
        .toolbar {
            ToolbarItem {
                Button("Nueva reserva") {
                    newReserve.toggle()
                }
            }
        }
    }
}

#Preview {
    ReservesView()
}

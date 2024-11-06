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
    
    @State private var showResumeView = false
    
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
    
    //Estado para actualizar una reserva
    @State private var selectedReserveToUpdate: ReserveWithPaymentModel = ReserveWithPaymentModel(id: 0, remitenteNombre: "", remitenteApellido: "", remitentePseudonimo: "", remitenteCurso: "", remitenteAnonimo: false, destinatarioNombre: "", destinatarioApellido: "", destinatarioPseudonimo: "", destinatarioCurso: "", totalAPagar: 0, dedicatoria: "", fotoURL: "", createdAt: "", pago: PaymentModel(id: 0, reservaID: 0, metodoPago: "", monto: 0, estado: "", fechaPago: ""), detalles: [])
    @State private var showUpdateReserveView = false
    
    //Estados para actualizar el estado de un pago
    @State private var isPaymentStatusChanged = false
    @State private var isChangingPaymentStatusPressed = false
    
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
            filteredReserves = viewModel.reserves.filter { $0.pago?.estado == "No entregado"}
        case .noPagadas:
            filteredReserves = viewModel.reserves.filter { $0.pago == nil }
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
        case todas = "Todas las reservas"
        case pagadas = "Reservas pagadas"
        case noPagadas = "Reservas no pagadas"
        case entregadas = "Reservas entregadas"
        case nonDeliveried = "Reservas no entregadas"
        var id: Self { self }
    }
    
    @State private var selectedFiler: Filter = .todas
    
    var body: some View {
        NavigationStack {
            if fetchingData {
                VStack {
                    Text("Obteniendo información de las reservas")
                    
                    ProgressView()
                        .scaleEffect(1.4)
                }
            } else {
                Picker("Filtros", selection: $selectedFiler) {
                    ForEach(Filter.allCases) { filter in
                        Text(filter.rawValue)
                            .font(.caption)
                    }
                }
                .pickerStyle(.menu)
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
                    case .noPagadas:
                        viewTitle = "Reservas no pagadas"
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
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
                            
                            if let pago = reserve.pago {
                                if pago.estado == "No entregado" {
                                    Button {
                                        Task {
                                            isChangingPaymentStatusPressed = true
                                            isPaymentStatusChanged = await paymentsViewModel.changePaymentStatus(id: pago.id, paymentModel: CreatePaymentModel(reservaID: reserve.id, metodoPago: pago.metodoPago, monto: pago.monto, estado: "Entregado"))
                                            if isPaymentStatusChanged {
                                                if let index = viewModel.reserves.firstIndex(where: { $0.id == reserve.id }) {
                                                    viewModel.reserves[index].pago?.estado = "Entregado"
                                                }
                                            }
                                            isChangingPaymentStatusPressed = false
                                        }
                                    } label: {
                                        Label("Marcar como entregado", systemImage: "checkmark.seal")
                                    }
                                } else {
                                    Button {
                                        Task {
                                            isChangingPaymentStatusPressed = true
                                            isPaymentStatusChanged = await paymentsViewModel.changePaymentStatus(id: pago.id, paymentModel: CreatePaymentModel(reservaID: reserve.id, metodoPago: pago.metodoPago, monto: pago.monto, estado: "No entregado"))
                                            if isPaymentStatusChanged {
                                                if let index = viewModel.reserves.firstIndex(where: { $0.id == reserve.id }) {
                                                    viewModel.reserves[index].pago?.estado = "No entregado"
                                                }
                                            }
                                            isChangingPaymentStatusPressed = false
                                        }
                                    } label: {
                                        Label("Marcar como no entregado", systemImage: "xmark.seal")
                                    }
                                }
                            }
                            
                            NavigationLink {
                                ReserveView(reserveModel: reserve)
                                    .environment(paymentsViewModel)
                                    .environment(viewModel)
                            } label: {
                                Label("Ver detalles", systemImage: "info.circle")
                            }
                            
                            Button {
                                selectedReserveToUpdate = reserve
                                showUpdateReserveView = true
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
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                reserveToDelete = reserve
                                showDeleteWarning = true
                                print(showDeleteWarning)
                            } label: {
                                Label("Eliminar Reserva", systemImage: "trash")
                            }
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
                    
                    if isChangingPaymentStatusPressed {
                        WaitingAlertView(message: "Cambiando estado del pedido")
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
        .navigationDestination(isPresented: $showResumeView, destination: {
            MoreInfoView()
        })
        .navigationDestination(isPresented: $showUpdateReserveView, destination: {
            UpdateReserveView(selectedReserve: $selectedReserveToUpdate)
        })
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
            ToolbarItem(placement: .primaryAction) {
                Button("Nueva reserva") {
                    newReserve.toggle()
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showResumeView.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
    }
}

#Preview {
    ReservesView()
}

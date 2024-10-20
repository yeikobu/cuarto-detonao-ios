//
//  ReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import SwiftUI

struct ReserveView: View {
    
    @State var reserveModel: ReserveWithPaymentModel
    
    @State private var reserveViewModel = ReserveViewModel()
    
    @Environment(ReservesViewModel.self) var reservesViewModel
    @State private var paymentsViewModel = PaymentsViewModel()
    
    @State private var date = ""
    
    //Estados para eliminar una reserva
    @State private var showDeleteWarning = false
    @State private var deletingData = false
    @State private var isReserveDeleted = false
    
    // Estados para los págos
    @State private var showCreatePaymentView = false
    @State private var showCreatingPaymentMessage = false
    @State private var newPaymentResponse: NewPaymentResponse = NewPaymentResponse(message: "", paymentID: 0)
    @State private var isPaymentCreated = false
    
    //Estados para eliminar un pago
    @State private var paymentToDelete: ReserveWithPaymentModel?
    @State private var showDeletePaymentWarning = false
    @State private var isPaymentDeleted = false
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Datos remitente
                Section {
                    HStack {
                        Text("ID de Reserva")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.id)")
                    }
                    
                    HStack {
                        Text("Nombre")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.remitenteNombre) \(reserveModel.remitenteApellido)")
                    }
                    
                    HStack {
                        Text("Seudónimo")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.remitentePseudonimo)")
                    }
                    
                    HStack {
                        Text("Curso")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.remitenteCurso)")
                    }
                    
                    HStack {
                        Text("Anónimo")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(reserveModel.remitenteAnonimo ? "Sí" : "No")
                    }
                } header: {
                    Text("Datos remitente")
                }
                
                // MARK: - Datos destinatario
                Section {
                    HStack {
                        Text("Nombre")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.destinatarioNombre) \(reserveModel.destinatarioApellido)")
                    }
                    
                    HStack {
                        Text("Seudónimo")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.destinatarioPseudonimo)")
                    }
                    
                    HStack {
                        Text("Curso")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(reserveModel.destinatarioCurso)")
                    }
                } header: {
                    Text("Datos destinatario")
                }
                
                // MARK: - Datos destinatario
                Section {
                    HStack {
                        Text("Total a pagar")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("$\(reserveModel.totalAPagar)")
                            .font(.title3)
                    }
                    
                    HStack {
                        Text("Fecha reserva")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(date)")
                            .font(.footnote)
                            .frame(maxWidth: 170, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if let foto = reserveModel.fotoURL {
                        VStack {
                            AsyncImage(url: URL(string: foto)) { image in
                                image.image?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250, height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .clipped()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if let dedicatoria = reserveModel.dedicatoria {
                        VStack {
                            Text("Dedicatoria")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(dedicatoria)")
                                .italic()
                        }
                    }
                    
                    ForEach(reserveModel.detalles, id: \.self) { rose in
                        HStack {
                            Text("Rosa \(rose.colorNombre)")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(rose.cantidad)")
                        }
                    }
                } header: {
                    Text("Detalles de la reserva")
                }
            }
            .navigationTitle("Reserva de \(reserveModel.remitenteNombre)")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        if reserveModel.pago == nil {
                            Button {
                                showCreatePaymentView = true
                            } label: {
                                Label("Pagar", systemImage: "creditcard")
                            }
                        }
                        
                        NavigationLink {
                            UpdateReserveView(selectedReserve: reserveModel)
                        } label: {
                            Label("Editar", systemImage: "pencil.and.list.clipboard")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            showDeleteWarning.toggle()
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                        
                        if reserveModel.pago != nil {
                            Button(role: .destructive) {
                                showDeletePaymentWarning = true
                            } label: {
                                Label("Eliminar pago", systemImage: "creditcard")
                            }
                        }
                    } label: {
                        Text("Opciones")
                    }
                }
            }
            .sheet(isPresented: $showCreatePaymentView) {
                CreatePaymentView(reserve: $reserveModel, showCreatingPaymentMessage: $showCreatingPaymentMessage, newPaymentResponse: $newPaymentResponse)
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.visible)
                    .environment(paymentsViewModel)
                    .onDisappear {
                        if let pago = reserveModel.pago {
                            if let reserveToReplaceIndex = reservesViewModel.reserves.firstIndex(where: { $0.id == reserveModel.id }) {
                                print(reserveToReplaceIndex)
                                reservesViewModel.reserves[reserveToReplaceIndex].pago = pago
                            }
                        }
                    }
            }
            .alert(isPresented: $showDeleteWarning) {
                Alert(title: Text("¿Quieres eliminar la reserva de \(reserveModel.remitenteNombre)?"), primaryButton: .destructive(Text("Eliminar")) {
                    Task {
                        deletingData = true
                        isReserveDeleted = await reservesViewModel.deleteReserveByID(id: reserveModel.id)
                        deletingData = false
                    }
                }, secondaryButton: .cancel())
            }
            .alert("Reserva eliminada exitosamente", isPresented: $isReserveDeleted) {
                Button("Aceptar") {}
            }
            .task {
                date = reserveViewModel.transformDate(isoDate: reserveModel.createdAt)
                
                isPaymentCreated = paymentsViewModel.isPaymentCreated
            }
        }
        .overlay {
            if deletingData {
                WaitingAlertView(message: "Eliminando reserva")
            }
        }
        .alert("\(newPaymentResponse.message)", isPresented: $paymentsViewModel.isPaymentCreated) {
            Button("Aceptar") { }
        }
    }
}

//#Preview {
//    ReserveView(reserveModel: ReserveModel(id: 1, remitenteNombre: "Jacob", remitenteApellido: "Aguilar", remitentePseudonimo: "Yeikobu", remitenteCurso: "Primero Medio C", remitenteAnonimo: false, destinatarioNombre: "Melany", destinatarioApellido: "Torres", destinatarioPseudonimo: "mimi", destinatarioCurso: "Primero Medio D", totalAPagar: 2000, dedicatoria: nil, fotoURL: nil, createdAt: "2024-10-06T15:46:15.135Z", detalles: [Detalle(colorNombre: "Roja", cantidad: 1)]))
//}

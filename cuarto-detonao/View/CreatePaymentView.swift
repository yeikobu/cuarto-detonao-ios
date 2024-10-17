//
//  CreatePaymentView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 16-10-24.
//

import SwiftUI

struct CreatePaymentView: View {
    @Environment(NewPaymentViewModel.self) var newPaymentViewModel
    
    @Binding var reserve: ReserveWithPaymentModel
    @State private var paymentMethod: String = ""
    @Binding var showCreatingPaymentMessage: Bool
    @Binding var newPaymentResponse: NewPaymentResponse
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Text("Confirma el pago para la reserva de")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Text("\(reserve.remitenteNombre) \(reserve.remitenteApellido)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                VStack {
                    Text("Monto a pagar")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    Text("\(reserve.totalAPagar)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                VStack {
                    Text("Método de pago")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 10) {
                        Button {
                            withAnimation(.bouncy(duration: 0.3)) {
                                paymentMethod = "Efectivo"
                            }
                        } label: {
                            VStack {
                                Text("Efectivo")
                                    .foregroundStyle(Color.white)
                            }
                            .frame(width: 130, height: 40)
                            .background(paymentMethod == "Efectivo" ? Color.accentColor : Color.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .scaleEffect(paymentMethod == "Efectivo" ? 1.1 : 1)

                        Button {
                            withAnimation(.bouncy(duration: 0.3)) {
                                paymentMethod = "Transferencia"
                            }
                        } label: {
                            VStack {
                                Text("Transferencia")
                                    .foregroundStyle(Color.white)
                            }
                            .frame(width: 130, height: 40)
                            .background(paymentMethod == "Transferencia" ? Color.accentColor : Color.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .scaleEffect(paymentMethod == "Transferencia" ? 1.1 : 1)
                    }
                }
                
                Spacer()
                
                VStack {
                    if !paymentMethod.isEmpty {
                        Button("Crear pago") {
                            Task {
                                showCreatingPaymentMessage = true
                                let paymentData = CreatePaymentModel(reservaID: reserve.id, metodoPago: paymentMethod, monto: reserve.totalAPagar, estado: "No entregado")
                                
                                if let paymentResponse = await newPaymentViewModel.createNewPayment(paymentModel: paymentData) {
                                    newPaymentResponse = paymentResponse
                                }
                                
                                showCreatingPaymentMessage = false
                                
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .navigationTitle("Confirmar pago")
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                if showCreatingPaymentMessage {
                    WaitingAlertView(message: "Creando pago...")
                }
            }
        }
    }
}

#Preview {
    CreatePaymentView(reserve: .constant(ReserveWithPaymentModel(id: 0, remitenteNombre: "", remitenteApellido: "", remitentePseudonimo: "", remitenteCurso: "", remitenteAnonimo: false, destinatarioNombre: "", destinatarioApellido: "", destinatarioPseudonimo: "", destinatarioCurso: "", totalAPagar: 0, dedicatoria: "", fotoURL: "", createdAt: "", pago: PaymentModel(id: 0, reservaID: 0, metodoPago: "", monto: 0, estado: "", fechaPago: ""), detalles: [])), showCreatingPaymentMessage: .constant(false), newPaymentResponse: .constant(NewPaymentResponse(message: "Reserva creada con éxito", paymentID: 0)))
}

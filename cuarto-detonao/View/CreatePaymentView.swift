//
//  CreatePaymentView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 16-10-24.
//

import SwiftUI

struct CreatePaymentView: View {
    
    var reserve: ReserveModel
    @State private var paymentMethod: String = ""
    @Binding var showCreatingPaymentMessage: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack {
                    Text("Confirma el pago para la reserva de")
                        .foregroundStyle(.secondary)
                    
                    Text("\(reserve.remitenteNombre) \(reserve.remitenteApellido)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                
                VStack {
                    Text("Monto a pagar")
                        .foregroundStyle(.secondary)
                    
                    Text("\(reserve.totalAPagar)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                VStack {
                    Text("Método de pago")
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
                                
                                
                            }
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("Confirmar pago")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CreatePaymentView(reserve: ReserveModel(id: 1, remitenteNombre: "Jacob", remitenteApellido: "Aguilar", remitentePseudonimo: "Yeikobu", remitenteCurso: "Primero Medio C", remitenteAnonimo: false, destinatarioNombre: "Melany", destinatarioApellido: "Torres", destinatarioPseudonimo: "mimi", destinatarioCurso: "Primero Medio D", totalAPagar: 2000, dedicatoria: nil, fotoURL: nil, createdAt: "2024-10-06T15:46:15.135Z", detalles: [Detalle(colorNombre: "Roja", cantidad: 1)]), showCreatingPaymentMessage: .constant(false))
}

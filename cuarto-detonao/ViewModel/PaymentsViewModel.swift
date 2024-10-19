//
//  NewPaymentViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 16-10-24.
//

import Foundation

@Observable
class PaymentsViewModel {
    private let paymentsService = PaymentsService()
    var isPaymentCreated = false
    var showrError: Bool = false
    var errorMessage: String = ""
    
    @MainActor
    func createNewPayment(paymentModel: CreatePaymentModel) async -> NewPaymentResponse? {
        var newPaymentRespose: NewPaymentResponse?
        
        do {
            newPaymentRespose = try await paymentsService.createPayment(paymentModel: paymentModel)
            isPaymentCreated = true
            return newPaymentRespose
        } catch {
            print("Error: \(error)")
            showrError = true
            errorMessage = "Error al agregar el pago"
        }
        
        return newPaymentRespose
    }
    
    @MainActor
    func deletePaymentByID(id: Int) async -> Bool {
        do {
            return try await paymentsService.deletePayment(id: id)
        } catch {
            showrError = true
            errorMessage = "No se pudo eliminar el pago"
            print("Error: \(error)")
        }
        
        return false
    }
}

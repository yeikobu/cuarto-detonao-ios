//
//  NewPaymentViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 16-10-24.
//

import Foundation

@Observable
class NewPaymentViewModel {
    private let paymentsService = PaymentsService()
    var showrError: Bool = false
    var errorMessage: String = ""
    
    @MainActor
    func createNewPayment(paymentModel: PaymentModel) async -> NewPaymentResponse? {
        var newPaymentRespose: NewPaymentResponse?
        
        do {
            newPaymentRespose = try await paymentsService.createPayment(paymentModel: paymentModel)
        } catch {
            showrError = true
            errorMessage = "Error al agregar el pago"
        }
        
        return newPaymentRespose
    }
}

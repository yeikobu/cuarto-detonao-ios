//
//  PaidReservesViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 17-10-24.
//

import Foundation

@Observable
class ReservesViewModel {
    private let paymentsService = PaymentsService()
    private let reserveService: ReservesService = ReservesService()
    
    var reserves: [ReserveWithPaymentModel] = []
    var showError = false
    var errorMessage = ""
    
    func getReservesWithPaymentsInfo() async  {
        do {
            reserves = try await paymentsService.fetchPayments()
            reserves = reserves.sorted(by: { $0.id < $1.id })
        } catch {
            showError = true
            errorMessage = "Error al obtener los datos de la API"
            print("Error: \(error)")
        }
    }
    
    @MainActor
    func deleteReserveByID(id: Int) async -> Bool {
        do {
            let message = try await reserveService.deleteReserveByID(id: id)
            print(message)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func getReservesWithPayments(reserves: [ReserveWithPaymentModel]) -> [ReserveWithPaymentModel] {
        return reserves.filter { $0.pago != nil }
    }
}

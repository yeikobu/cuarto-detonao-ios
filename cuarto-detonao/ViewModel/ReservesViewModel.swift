//
//  ReservesViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import Foundation

@Observable
class ReservesViewModel {
    private let reserveService: ReservesService = ReservesService()
    var reserves: [ReserveModel] = []
    var showrError: Bool = false
    var errorMessage: String = ""
    
    func fetchReserves() async {
        do {
            reserves = try await reserveService.fetchReserves()
            reserves = reserves.sorted(by: { $0.id < $1.id })
        } catch {
            showrError = true
            errorMessage = "Error al obtener los datos de la API"
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
}

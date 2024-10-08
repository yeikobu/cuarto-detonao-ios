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
        } catch {
            showrError = true
            errorMessage = "Error al obtener los datos de la API"
        }
    }
}

//
//  UpdateReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 13-10-24.
//

import Foundation

@Observable
class UpdateReserveViewModel {
    private let reservesService = ReservesService()
    var showErrorMessage = false
    var errorMessage = ""
    
    func updateReserveByID(id: Int, reserveModel: NewReserveModel) async {
        do {
            try await reservesService.updateReserveByID(id: id, reserveData: reserveModel)
        } catch {
            errorMessage = "No se pudo actualizar la reserva"
            showErrorMessage = true
        }
    }
}

//
//  NewReserveViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 11-10-24.
//

import Foundation

@Observable
class NewReserveViewModel {
    
    func checkEssentialInputs(reserveModel: NewReserveModel) -> Bool {
        return !reserveModel.remitenteNombre.isEmpty && !reserveModel.remitenteApellido.isEmpty && reserveModel.remitenteCurso != "Selecciona curso" && reserveModel.remitenteCurso != "" &&
        !reserveModel.destinatarioNombre.isEmpty && !reserveModel.destinatarioApellido.isEmpty && reserveModel.destinatarioCurso != "Selecciona curso" && reserveModel.destinatarioCurso != ""
    }
    
    func checkIfAlmostOneRoseIsSelected(roses: [NewReserveDetalle]) -> Bool {
        return !roses.isEmpty
    }
}

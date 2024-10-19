//
//  NewReserveViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 11-10-24.
//

import SwiftUI

@Observable
class NewReserveViewModel {
    private let storageService = FirebaseStorageService()
    private let reservesService = ReservesService()
    
    var errorMessage = ""
    var showError = false
    
    func checkEssentialInputs(reserveModel: NewReserveModel) -> Bool {
        return !reserveModel.remitenteNombre.isEmpty && !reserveModel.remitenteApellido.isEmpty && reserveModel.remitenteCurso != "Selecciona curso" && reserveModel.remitenteCurso != "" &&
        !reserveModel.destinatarioNombre.isEmpty && !reserveModel.destinatarioApellido.isEmpty && reserveModel.destinatarioCurso != "Selecciona curso" && reserveModel.destinatarioCurso != ""
    }
    
    func checkIfAlmostOneRoseIsSelected(roses: [NewReserveDetalle]) -> Bool {
        return !roses.isEmpty
    }
    
    @MainActor
    func calculateTotal(reserveModel: NewReserveModel, includePhotoAndMessage: Bool) -> Int {
        var totalToPay = 0
        let roses = reserveModel.detalles.filter { $0.cantidad > 0 }
        var totalOfRoses = 0
        
        for rose in roses {
            totalOfRoses += rose.cantidad
        }
        
        // Calcular el costo de las rosas
        let setsOfThree = totalOfRoses / 3
        let remainingRoses = totalOfRoses % 3
        
        totalToPay = setsOfThree * 5000 + remainingRoses * 2000
        
        // Agregar costo adicional si se incluye foto y se ha seleccionado una imagen
        if includePhotoAndMessage {
            totalToPay += 1000
        }
        
        return totalToPay
    }
    
    func uploadImageToFirebase(image: UIImage, from: String, to: String) async -> String {
        var downloadURL = ""
        do {
            downloadURL = try await storageService.uploadImageToFirebase(image: image, from: from, to: to)
        } catch {
            errorMessage = "No se pudo subir la imagen"
            showError = true
        }
        
        return downloadURL
    }
    
    func createNewReserve(reserveData: NewReserveModel) async -> Int? {
        do {
            let reserveResponse = try await reservesService.createNewReserve(reserveData: reserveData)
            guard let numeroReserva = reserveResponse?.numeroReserva else { return nil }
            return numeroReserva
        } catch {
            errorMessage = "No se pudo subir la imagen"
            showError = true
        }
        
        return nil
    }
}

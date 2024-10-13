//
//  FirebaseStorageService.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 12-10-24.
//

import SwiftUI
import FirebaseStorage

final class FirebaseStorageService {
    
    func uploadImageToFirebase(image: UIImage, from: String, to: String) async throws -> String {
        // Asegúrate de que la imagen pueda ser convertida a datos JPEG
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo convertir la imagen a datos JPEG."])
        }
        
        let date = Date()
        let formattedDate = formatDate(date: date)
        
        // Crear una referencia a Firebase Storage
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("fotos/from\(from)-to\(to)at\(formattedDate).jpg")
        
        // Subir la imagen a Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            imageRef.putData(imageData, metadata: metadata) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
        
        // Obtener la URL de descarga de la imagen subida
        return try await withCheckedThrowingContinuation { continuation in
            imageRef.downloadURL { url, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let downloadURL = url?.absoluteString {
                    continuation.resume(returning: downloadURL)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener la URL de descarga"]))
                }
            }
        }
    }
    
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z (zzzz)"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
}

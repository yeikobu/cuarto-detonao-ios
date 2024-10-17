//
//  PaymentsService.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 16-10-24.
//

import Foundation

final class PaymentsService {
    private let baseURL: String = "https://cuarto-detonao-backend.onrender.com"
    
    func fetchPayments() async throws -> [ReserveWithPaymentModel] {
        guard let paymentsURL = URL(string: "\(baseURL)/payments") else { return [] }
        
        let request = URLRequest(url: paymentsURL)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let payments = try JSONDecoder().decode([ReserveWithPaymentModel].self, from: data)
        
        return payments
    }
    
    func createPayment(paymentModel: PaymentModel) async throws -> NewPaymentResponse? {
        guard let paymentsURL = URL(string: "\(baseURL)/payment") else { return nil}
        
        var request = URLRequest(url: paymentsURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let _ = try JSONEncoder().encode(paymentModel)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let apiResponse = response as? HTTPURLResponse, !(200...299).contains(apiResponse.statusCode) {
            throw NSError(domain: "APIService", code: apiResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error al insertar los datos: \(apiResponse.statusCode)"])
        }
        
        let paymentResponse = try JSONDecoder().decode(NewPaymentResponse.self, from: data)
        
        return paymentResponse
    }
}

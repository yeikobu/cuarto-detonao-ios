//
//  ReservesService.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//
import Foundation

final class ReservesService {
    
    private let baseURL: String = "https://cuarto-detonao-backend.onrender.com"
    
    func fetchReserves() async throws -> [ReserveModel] {
        guard let reservesURL = URL(string: "\(baseURL)/reserves") else { return [] }
        
        let request = URLRequest(url: reservesURL)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let reserves = try JSONDecoder().decode([ReserveModel].self, from: data)
        
        return reserves
    }
    
    func createNewReserve(reserveData: NewReserveModel) async throws -> NewReserveResponse? {
        guard let newReserveURL = URL(string: "\(baseURL)/reserve") else { return nil }
        
        var request = URLRequest(url: newReserveURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(reserveData)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let apiResponse = response as? HTTPURLResponse, !(200...299).contains(apiResponse.statusCode) {
            throw NSError(domain: "APIService", code: apiResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error en la solicitud: \(apiResponse.statusCode)"])
        }
        
        let reserveResponse = try JSONDecoder().decode(NewReserveResponse.self, from: data)
        
        return reserveResponse
    }
    
    func updateReserveByID(id: Int, reserveData: NewReserveModel) async throws {
        guard let updateReserveURL = URL(string: "\(baseURL)/reserve/\(id)") else { return  }
        
        var request = URLRequest(url: updateReserveURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(reserveData)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let apiResponse = response as? HTTPURLResponse, !(200...299).contains(apiResponse.statusCode) {
            throw NSError(domain: "APIService", code: apiResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error al actualizar: \(apiResponse.statusCode)"])
        }
        
        let reserveResponse = try JSONDecoder().decode(NewReserveModel.self, from: data)
    }
    
    func deleteReserveByID(id: Int) async throws -> String {
        guard let url = URL(string: "\(baseURL)/reserve/\(id)") else { return "" }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(DeleteReserveResponseModel.self, from: data)
        
        return response.message
    }
}

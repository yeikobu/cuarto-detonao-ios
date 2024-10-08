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

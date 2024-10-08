//
//  ReservesService.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//
import Foundation

final class ReservesService {
    func fetchReserves() async throws -> [ReserveModel] {
        guard let reservesURL = URL(string: "https://cuarto-detonao-backend.onrender.com/reserves") else { return [] }
        
        let request = URLRequest(url: reservesURL)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let reserves = try JSONDecoder().decode([ReserveModel].self, from: data)
        
        return reserves
    }
}

//
//  ReserveViewModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 08-10-24.
//

import Foundation

@Observable
class ReserveViewModel {
    func transformDate(isoDate: String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // Convertir la cadena de fecha en un objeto Date
        if let date = isoDateFormatter.date(from: isoDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE d 'de' MMMM 'de' yyyy 'a las' HH:mm"
            dateFormatter.locale = Locale(identifier: "es_ES")
            
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
}

//
//  ReservaModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import Foundation

struct ReserveModel: Codable {
    let id: Int
    let remitenteNombre, remitenteApellido, remitentePseudonimo, remitenteCurso: String
    let remitenteAnonimo: Bool
    let destinatarioNombre, destinatarioApellido, destinatarioPseudonimo, destinatarioCurso: String
    let totalAPagar: Int
    let dedicatoria: String?
    let fotoURL: String?
    let createdAt: String
    let detalles: [Detalle]

    enum CodingKeys: String, CodingKey {
        case id
        case remitenteNombre = "remitente_nombre"
        case remitenteApellido = "remitente_apellido"
        case remitentePseudonimo = "remitente_pseudonimo"
        case remitenteCurso = "remitente_curso"
        case remitenteAnonimo = "remitente_anonimo"
        case destinatarioNombre = "destinatario_nombre"
        case destinatarioApellido = "destinatario_apellido"
        case destinatarioPseudonimo = "destinatario_pseudonimo"
        case destinatarioCurso = "destinatario_curso"
        case totalAPagar = "total_a_pagar"
        case dedicatoria
        case fotoURL = "foto_url"
        case createdAt = "created_at"
        case detalles
    }
}

// MARK: - Detalle
struct Detalle: Codable, Hashable {
    let colorNombre: String
    let cantidad: Int

    enum CodingKeys: String, CodingKey {
        case colorNombre = "color_nombre"
        case cantidad
    }
}

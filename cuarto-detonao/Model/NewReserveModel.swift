//
//  NewReserveModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 11-10-24.
//

import Foundation

struct NewReserveModel: Codable {
    var remitenteNombre, remitenteApellido, remitentePseudonimo, remitenteCurso: String
    var remitenteAnonimo: Bool
    var destinatarioNombre, destinatarioApellido, destinatarioPseudonimo, destinatarioCurso: String
    var totalAPagar: Int
    var dedicatoria: String?
    var fotoURL: String?
    var detalles: [NewReserveDetalle]

    enum CodingKeys: String, CodingKey {
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
        case detalles
    }
}

// MARK: - Detalle
struct NewReserveDetalle: Codable, Hashable {
    var colorNombre: String
    var cantidad: Int

    enum CodingKeys: String, CodingKey {
        case colorNombre = "color_nombre"
        case cantidad
    }
}


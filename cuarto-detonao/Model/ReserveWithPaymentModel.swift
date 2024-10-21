//
//  PaymentModel.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 16-10-24.
//

import Foundation

struct ReserveWithPaymentModel: Codable {
    var id: Int
    var remitenteNombre, remitenteApellido, remitentePseudonimo, remitenteCurso: String
    var remitenteAnonimo: Bool
    var destinatarioNombre, destinatarioApellido, destinatarioPseudonimo, destinatarioCurso: String
    var totalAPagar: Int
    var dedicatoria, fotoURL: String?
    var createdAt: String
    var pago: PaymentModel?
    var detalles: [Detalle]

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
        case pago, detalles
    }
}

struct Detalle: Codable, Hashable {
    let colorNombre: String
    let cantidad: Int

    enum CodingKeys: String, CodingKey {
        case colorNombre = "color_nombre"
        case cantidad
    }
}


struct PaymentModel: Codable {
    let id: Int
    let reservaID: Int?
    let metodoPago: String
    let monto: Int
    let estado: String
    let fechaPago: String

    enum CodingKeys: String, CodingKey {
        case id
        case reservaID = "reserva_id"
        case metodoPago = "metodo_pago"
        case monto, estado
        case fechaPago = "fecha_pago"
    }
}

struct CreatePaymentModel: Codable {
    let reservaID: Int
    let metodoPago: String
    let monto: Int
    let estado: String
    let fechaPago: String

    enum CodingKeys: String, CodingKey {
        case reservaID = "reserva_id"
        case metodoPago = "metodo_pago"
        case monto, estado
        case fechaPago = "fecha_pago"
    }
}

struct NewPaymentResponse: Codable {
    let message: String
    let paymentID: Int

    enum CodingKeys: String, CodingKey {
        case message
        case paymentID = "payment_id"
    }
}

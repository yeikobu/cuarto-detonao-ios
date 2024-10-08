//
//  ReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 07-10-24.
//

import SwiftUI

struct ReserveView: View {
    
    var reserveModel: ReserveModel
    
    @State private var reserveViewModel = ReserveViewModel()
    @State private var date = ""
    @State private var showMenuOption = false
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Datos remitente
                Section {
                    HStack {
                        Text("ID de Reserva")
                        
                        Spacer()
                        
                        Text("\(reserveModel.id)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Nombre")
                        
                        Spacer()
                        
                        Text("\(reserveModel.remitenteNombre) \(reserveModel.remitenteApellido)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Seudónimo")
                        
                        Spacer()
                        
                        Text("\(reserveModel.remitentePseudonimo)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Curso")
                        
                        Spacer()
                        
                        Text("\(reserveModel.remitenteCurso)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Anónimo")
                        
                        Spacer()
                        
                        Text(reserveModel.remitenteAnonimo ? "Sí" : "No")
                            .fontWeight(.bold)
                    }
                } header: {
                    Text("Datos remitente")
                }
                
                // MARK: - Datos destinatario
                Section {
                    HStack {
                        Text("Nombre")
                        
                        Spacer()
                        
                        Text("\(reserveModel.destinatarioNombre) \(reserveModel.destinatarioApellido)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Seudónimo")
                        
                        Spacer()
                        
                        Text("\(reserveModel.destinatarioPseudonimo)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Curso")
                        
                        Spacer()
                        
                        Text("\(reserveModel.destinatarioCurso)")
                            .fontWeight(.bold)
                    }
                } header: {
                    Text("Datos destinatario")
                }
                
                // MARK: - Datos destinatario
                Section {
                    HStack {
                        Text("Total a pagar")
                        
                        Spacer()
                        
                        Text("$\(reserveModel.totalAPagar)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Fecha reserva")
                        
                        Spacer()
                        
                        Text("\(date)")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .frame(maxWidth: 170, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if let foto = reserveModel.fotoURL {
                        AsyncImage(url: URL(string: foto)) { image in
                            image.image?.resizable()
                        }
                        .frame(width: 200, height: 200)
                    }
                    
                    if let dedicatoria = reserveModel.dedicatoria {
                        VStack {
                            Text("Dedicatoria")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(dedicatoria)
                                .fontWeight(.bold)
                        }
                    }
                    
                    ForEach(reserveModel.detalles, id: \.self) { rose in
                        HStack {
                            Text(rose.cantidad > 1 ? "Rosas \(rose.colorNombre)s" : "Rosa \(rose.colorNombre)")
                            
                            Spacer()
                            
                            Text("\(rose.cantidad)")
                                .fontWeight(.bold)
                        }
                    }
                } header: {
                    Text("Detalles de la reserva")
                }
            }
            .navigationTitle("Reserva de \(reserveModel.remitenteNombre)")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            //
                        } label: {
                            Label("Pagar", systemImage: "creditcard")
                        }
                        
                        Button {
                            //
                        } label: {
                            Label("Editar", systemImage: "pencil.and.list.clipboard")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            //
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    } label: {
                        Text("Opciones")
                    }
                }
            }
            .task {
                date = reserveViewModel.transformDate(isoDate: reserveModel.createdAt)
            }
        }
    }
}

#Preview {
    ReserveView(reserveModel: ReserveModel(id: 1, remitenteNombre: "Jacob", remitenteApellido: "Aguilar", remitentePseudonimo: "Yeikobu", remitenteCurso: "Primero Medio C", remitenteAnonimo: false, destinatarioNombre: "Melany", destinatarioApellido: "Torres", destinatarioPseudonimo: "mimi", destinatarioCurso: "Primero Medio D", totalAPagar: 2000, dedicatoria: nil, fotoURL: nil, createdAt: "2024-10-06T15:46:15.135Z", detalles: [Detalle(colorNombre: "Roja", cantidad: 1)]))
}

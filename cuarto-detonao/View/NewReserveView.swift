//
//  NewReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 09-10-24.
//

import SwiftUI

struct NewReserveView: View {
    
    @State private var senderName = ""
    @State private var senderLastName = ""
    @State private var senderNickName = ""
    @State private var senderCourse = ""
    @State private var senderAnonymous = false
    
    @State private var receiverName = ""
    @State private var receiverLastName = ""
    @State private var receiverNickName = ""
    @State private var receiverCourse = ""
    
    @State private var redRosesQuantity = 0
    @State private var orangeRosesQuantity = 0
    @State private var blueRosesQuantity = 0
    @State private var purpleRosesQuantity = 0
    @State private var yellowRosesQuantity = 0
    @State private var whiteRosesQuantity = 0
    
    let courses = [ "Séptimo A", "Séptimo B", "Octavo A", "Octavo B", "Primero Medio A", "Primero Medio B", "Primero Medio C", "Primero Medio D", "Segundo Medio A", "Segundo Medio B", "Segundo Medio C", "Segundo Medio D", "Tercero Medio A", "Tercero Medio B", "Tercero Medio C", "Tercero Medio D", "Cuarto Medio A", "Cuarto Medio B", "Cuarto Medio C", "Cuarto Medio D", "Profesor", "Personal del liceo"]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Nombre remitente", text: $senderName)
                    
                    TextField("Apellido remitente", text: $senderLastName)
                    
                    TextField("Seudónimo remitente (opcional)", text: $senderNickName)
                    
                    Picker("Seleccionar curso", selection: $senderCourse) {
                        ForEach(courses, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Toggle(isOn: $senderAnonymous) {
                        HStack {
                            Text("Anónimo")
                            
                            Spacer()
                            
                            Text(senderAnonymous ? "Sí" : "No")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                    }
                } header: {
                    Text("Datos del remitente")
                }
                
                
                Section {
                    TextField("Nombre receptor", text: $receiverName)
                    
                    TextField("Apellido receptor", text: $receiverLastName)
                    
                    TextField("Seudónimi receptor (opcional)", text: $receiverName)
                    
                    Picker("Seleccionar curso", selection: $receiverCourse) {
                        ForEach(courses, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    
                } header: {
                    Text("Datos del receptor")
                }
                
                Section {
                    Stepper(value: $redRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Rojas")
                            
                            Spacer()
                            
                            Text("\(redRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    
                    Stepper(value: $orangeRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Naranja puntas rojas")
                            
                            Spacer()
                            
                            Text("\(orangeRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    
                    Stepper(value: $blueRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Azules")
                            
                            Spacer()
                            
                            Text("\(blueRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    
                    Stepper(value: $purpleRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Moradas")
                            
                            Spacer()
                            
                            Text("\(purpleRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    
                    Stepper(value: $yellowRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Amarillas")
                            
                            Spacer()
                            
                            Text("\(yellowRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    
                    Stepper(value: $whiteRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Blancas")
                            
                            Spacer()
                            
                            Text("\(whiteRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                } header: {
                    Text("Rosas")
                }
            }
        }
        .navigationTitle("Nueva reserva")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NewReserveView()
}

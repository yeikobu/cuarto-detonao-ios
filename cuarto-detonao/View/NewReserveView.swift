//
//  NewReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 09-10-24.
//

import SwiftUI
import PhotosUI

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
    
    @State private var includePhotoAndmessage = false
    @State private var imageItem: PhotosPickerItem?
    @State private var image: Image?
    
    @State private var textMessage = ""
    
    let courses = [ "Séptimo A", "Séptimo B", "Octavo A", "Octavo B", "Primero Medio A", "Primero Medio B", "Primero Medio C", "Primero Medio D", "Segundo Medio A", "Segundo Medio B", "Segundo Medio C", "Segundo Medio D", "Tercero Medio A", "Tercero Medio B", "Tercero Medio C", "Tercero Medio D", "Cuarto Medio A", "Cuarto Medio B", "Cuarto Medio C", "Cuarto Medio D", "Profesor", "Personal del liceo"]
    
    var body: some View {
        NavigationStack {
            List {
                
                //MARK: - sender's data section
                Section {
                    TextField("Nombre remitente", text: $senderName)
                    
                    TextField("Apellido remitente", text: $senderLastName)
                    
                    TextField("Seudónimo remitente (opcional)", text: $senderNickName)
                    
                    Picker("Seleccionar curso", selection: $senderCourse) {
                        ForEach(courses, id: \.self) {
                            Text($0)
                                .tag($0)
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
                
                //MARK: - receiver's data section
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
                    .tag("1")
                    
                    
                } header: {
                    Text("Datos del receptor")
                }
                
                //MARK: - Roses quantity section
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
                
               
                Section {
                    Toggle("Incluír foto y dedicatoria", isOn: $includePhotoAndmessage)
                    
                    if includePhotoAndmessage {
                        VStack {
                            PhotosPicker(selection: $imageItem, matching: .any(of: [.images, .screenshots])) {
                                HStack(spacing: 2) {
                                    Text(image != nil ? "Seleccionar otra foto" : "Seleccionar foto")
                                    
                                    Image(systemName: "photo.badge.plus")
                                }
                            }
                            
                            image?
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .frame(maxWidth: 250, maxHeight: 250)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onChange(of: imageItem) {
                            Task {
                                if let loaded = try? await imageItem?.loadTransferable(type: Image.self) {
                                    image = loaded
                                } else {
                                    print("Falló al cargar la imagen en el dispositivo")
                                }
                            }
                        }
                        
                        ZStack(alignment: .leading) {
                            if textMessage.isEmpty {
                                Text("Escribe la dedicatoria")
                                    .foregroundStyle(.secondary)
                                    .padding(4)
                            }
                            
                            TextEditor(text: $textMessage)
                        }

                    }
                } header: {
                    Text("Foto y dedicatoria")
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

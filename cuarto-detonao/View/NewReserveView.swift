//
//  NewReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 09-10-24.
//

import SwiftUI
import PhotosUI

struct NewReserveView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var newReserveViewModel = NewReserveViewModel()
    @State private var newReserve = NewReserveModel(remitenteNombre: "", remitenteApellido: "", remitentePseudonimo: "", remitenteCurso: "", remitenteAnonimo: false, destinatarioNombre: "", destinatarioApellido: "", destinatarioPseudonimo: "", destinatarioCurso: "", totalAPagar: 0, dedicatoria: "", fotoURL: "", detalles: [])
    
    @State private var senderName = ""
    @State private var senderLastName = ""
    @State private var senderNickName = ""
    @State private var senderCourse = ""
    @State private var senderAnonymous = false
    
    @State private var receiverName = ""
    @State private var receiverLastName = ""
    @State private var receiverNickName = ""
    @State private var receiverCourse = ""
    @State private var areEssentialFieldsCompleted = false
    
    @State private var redRosesQuantity = 0
    @State private var orangeRosesQuantity = 0
    @State private var blueRosesQuantity = 0
    @State private var purpleRosesQuantity = 0
    @State private var yellowRosesQuantity = 0
    @State private var whiteRosesQuantity = 0
    @State private var isThereAlmostOneRoseSelected = false
    
    @State private var includePhotoAndMessage = false
    @State private var imageSelected = false
    @State private var imageItem: PhotosPickerItem?
    @State private var image: UIImage?
    @State private var areImageAndMessageCompleted = false
    
    @State private var textMessage = ""
    private let textMessageMaxLenght = 40
    @State private var typedCharacters = 0
    
    @State private var showCreatingReserve = false
    @State private var reserveNumber = 0
    @State private var isReserveCreated = false
    
    @State private var totalToPay = 0
    
    
    let courses = [ "Séptimo A", "Séptimo B", "Octavo A", "Octavo B", "Primero Medio A", "Primero Medio B", "Primero Medio C", "Primero Medio D", "Segundo Medio A", "Segundo Medio B", "Segundo Medio C", "Segundo Medio D", "Tercero Medio A", "Tercero Medio B", "Tercero Medio C", "Tercero Medio D", "Cuarto Medio A", "Cuarto Medio B", "Cuarto Medio C", "Cuarto Medio D", "Profesor", "Personal del liceo"]
    
    var body: some View {
        NavigationStack {
            List {
                
                //MARK: - sender's data section
                Section {
                    TextField("Nombre remitente", text: $senderName)
                        .onChange(of: senderName) {
                            newReserve.remitenteNombre = senderName
                            areEssentialFieldsCompleted = newReserveViewModel.checkEssentialInputs(reserveModel: newReserve)
                        }
                    
                    TextField("Apellido remitente", text: $senderLastName)
                        .onChange(of: senderLastName) {
                            newReserve.remitenteApellido = senderLastName
                            areEssentialFieldsCompleted = newReserveViewModel.checkEssentialInputs(reserveModel: newReserve)
                        }
                    
                    TextField("Seudónimo remitente (opcional)", text: $senderNickName)
                        .onChange(of: senderNickName) {
                            newReserve.remitentePseudonimo = senderNickName
                        }
                    
                    
                    Picker("Seleccionar curso", selection: $senderCourse) {
                        Text("Selecciona curso")
                            .tag("")
                        ForEach(courses, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: senderCourse) {
                        newReserve.remitenteCurso = senderCourse
                        areEssentialFieldsCompleted = newReserveViewModel.checkEssentialInputs(reserveModel: newReserve)
                    }
                    
                    Toggle(isOn: $senderAnonymous) {
                        HStack {
                            Text("Anónimo")
                            
                            Spacer()
                            
                            Text(senderAnonymous ? "Sí" : "No")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                    }
                    .onChange(of: senderAnonymous) {
                        newReserve.remitenteAnonimo = senderAnonymous
                    }
                } header: {
                    Text("Datos del remitente")
                }
                
                //MARK: - receiver's data section
                Section {
                    TextField("Nombre receptor", text: $receiverName)
                        .onChange(of: receiverName) {
                            newReserve.destinatarioNombre = receiverName
                            areEssentialFieldsCompleted = newReserveViewModel.checkEssentialInputs(reserveModel: newReserve)
                        }
                    
                    TextField("Apellido receptor", text: $receiverLastName)
                        .onChange(of: receiverLastName) {
                            newReserve.destinatarioApellido = receiverLastName
                            areEssentialFieldsCompleted = newReserveViewModel.checkEssentialInputs(reserveModel: newReserve)
                        }
                    
                    TextField("Seudónimi receptor (opcional)", text: $receiverNickName)
                        .onChange(of: receiverNickName) {
                            newReserve.destinatarioPseudonimo = receiverNickName
                        }
                    
                    Picker("Seleccionar curso", selection: $receiverCourse) {
                        Text("Selecciona curso")
                            .tag("")
                        ForEach(courses, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: receiverCourse) {
                        newReserve.destinatarioCurso = receiverCourse
                        areEssentialFieldsCompleted = newReserveViewModel.checkEssentialInputs(reserveModel: newReserve)
                    }
                    
                    
                } header: {
                    Text("Datos del receptor")
                }
                
                // MARK: - Roses quantity section
                Section {
                    Stepper(value: $redRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Rojas")
                            Spacer()
                            Text("\(redRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    .onChange(of: redRosesQuantity) {
                        updateRosesDetails(roseColor: RosesColor.red.rawValue, roseQuantity: redRosesQuantity)
                        isThereAlmostOneRoseSelected = newReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: newReserve.detalles)
                        totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                    }
                    
                    Stepper(value: $orangeRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Naranja puntas rojas")
                            Spacer()
                            Text("\(orangeRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    .onChange(of: orangeRosesQuantity) {
                        updateRosesDetails(roseColor: RosesColor.orange.rawValue, roseQuantity: orangeRosesQuantity)
                        isThereAlmostOneRoseSelected = newReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: newReserve.detalles)
                        totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                    }
                    
                    Stepper(value: $blueRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Azules")
                            Spacer()
                            Text("\(blueRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    .onChange(of: blueRosesQuantity) {
                        updateRosesDetails(roseColor: RosesColor.blue.rawValue, roseQuantity: blueRosesQuantity)
                        isThereAlmostOneRoseSelected = newReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: newReserve.detalles)
                        totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                    }
                    
                    Stepper(value: $purpleRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Moradas")
                            Spacer()
                            Text("\(purpleRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    .onChange(of: purpleRosesQuantity) {
                        updateRosesDetails(roseColor: RosesColor.purple.rawValue, roseQuantity: purpleRosesQuantity)
                        isThereAlmostOneRoseSelected = newReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: newReserve.detalles)
                        totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                    }
                    
                    Stepper(value: $yellowRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Amarillas")
                            Spacer()
                            Text("\(yellowRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    .onChange(of: yellowRosesQuantity) {
                        updateRosesDetails(roseColor: RosesColor.yellow.rawValue, roseQuantity: yellowRosesQuantity)
                        isThereAlmostOneRoseSelected = newReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: newReserve.detalles)
                        totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                    }
                    
                    Stepper(value: $whiteRosesQuantity, in: 0...20) {
                        HStack {
                            Text("Blancas")
                            Spacer()
                            Text("\(whiteRosesQuantity)")
                                .padding(.trailing, 4)
                        }
                    }
                    .onChange(of: whiteRosesQuantity) {
                        updateRosesDetails(roseColor: RosesColor.white.rawValue, roseQuantity: whiteRosesQuantity)
                        isThereAlmostOneRoseSelected = newReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: newReserve.detalles)
                        totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                    }
                } header: {
                    Text("Rosas")
                }
                
                //MARK: - Section incluir foto y dedicatoria
                Section {
                    Toggle("Incluír foto y dedicatoria", isOn: $includePhotoAndMessage)
                        .onChange(of: includePhotoAndMessage) {
                            if !includePhotoAndMessage {
                                newReserve.fotoURL = nil
                                newReserve.dedicatoria = nil
                                imageSelected = false
                            }
                            totalToPay = newReserveViewModel.calculateTotal(reserveModel: newReserve, includePhotoAndMessage: includePhotoAndMessage)
                        }
                    
                    if includePhotoAndMessage {
                        VStack {
                            PhotosPicker(selection: $imageItem, matching: .any(of: [.images, .screenshots])) {
                                HStack(spacing: 2) {
                                    Text(image != nil ? "Seleccionar otra foto" : "Seleccionar foto")
                                    
                                    Image(systemName: "photo.badge.plus")
                                }
                            }
                            
                            if let uiImage = image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .frame(width: 250, height: 250)
                                    .clipped()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onChange(of: imageItem) {
                            Task {
                                if let data = try? await imageItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    image = uiImage
                                    newReserve.fotoURL = "placeholder_url" // Esto se actualizará cuando se suba la imagen
                                    imageSelected = true
                                } else {
                                    print("Falló al cargar la imagen en el dispositivo")
                                    imageSelected = false
                                }
                                
                                areImageAndMessageCompleted = imageSelected && !textMessage.isEmpty
                            }
                        }
                        
                        
                        ZStack(alignment: .topLeading) {
                            if textMessage.isEmpty {
                                Text("Escribe la dedicatoria")
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                            
                            VStack {
                                TextEditor(text: $textMessage)
                                    .onChange(of: textMessage) {
                                        typedCharacters = textMessage.count
                                        textMessage = String(textMessage.prefix(textMessageMaxLenght))
                                        areImageAndMessageCompleted = image != nil && !textMessage.isEmpty
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.secondary, lineWidth: 1)
                                    }
                                
                                if typedCharacters > 0 {
                                    Text("\(typedCharacters)/\(textMessageMaxLenght)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                        }
                        
                    }
                } header: {
                    Text("Foto y dedicatoria")
                }
                
                Section {
                    HStack {
                        Text("Total a pagar")
                        
                        Spacer()
                        
                        Text("\(totalToPay)")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .navigationTitle("Nueva reserva")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isThereAlmostOneRoseSelected && areEssentialFieldsCompleted && !includePhotoAndMessage {
                Button("Finalizar") {
                    Task {
                        showCreatingReserve = true
                        newReserve.totalAPagar = totalToPay
                        if let responseReserveNumber = await newReserveViewModel.createNewReserve(reserveData: newReserve) {
                            self.reserveNumber = responseReserveNumber
                        }
                        showCreatingReserve = false
                        isReserveCreated = self.reserveNumber > 0
                    }
                }
            }
            
            if includePhotoAndMessage && isThereAlmostOneRoseSelected && areEssentialFieldsCompleted && areImageAndMessageCompleted {
                Button("Finalizar") {
                    Task {
                        showCreatingReserve = true
                        newReserve.totalAPagar = totalToPay
                        if let image = image {
                            let imageURL = await newReserveViewModel.uploadImageToFirebase(image: image, from: "\(newReserve.remitenteNombre)\(newReserve.remitenteApellido)", to: "\(newReserve.destinatarioNombre)\(newReserve.destinatarioApellido)")
                            newReserve.fotoURL = imageURL
                            newReserve.dedicatoria = textMessage
                            if let responseReserveNumber = await newReserveViewModel.createNewReserve(reserveData: newReserve) {
                                self.reserveNumber = responseReserveNumber
                            }
                        }
                        showCreatingReserve = false
                        isReserveCreated = self.reserveNumber > 0
                    }
                }
            }
        }
        .overlay {
            if showCreatingReserve {
                VStack {
                    Text("Creando reserva...")
                        .font(.title2)
                    
                    ProgressView()
                        .scaleEffect(1.4)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                )
            }
        }
        .alert("Reserva creada exitosamente", isPresented: $isReserveCreated) {
            Button("Aceptar") {
                dismiss()
            }
        } message: {
            Text("Número de reserva: \(reserveNumber)")
        }
        
        
    }
    
    func updateRosesDetails(roseColor: String, roseQuantity: Int) {
        if let index = newReserve.detalles.firstIndex(where: { $0.colorNombre == roseColor }) {
            newReserve.detalles[index].cantidad = roseQuantity
        } else if roseQuantity > 0 {
            newReserve.detalles.append(NewReserveDetalle(colorNombre: roseColor, cantidad: roseQuantity))
        }
        
        newReserve.detalles = newReserve.detalles.filter { $0.cantidad > 0 }
    }
}

#Preview {
    NewReserveView()
}

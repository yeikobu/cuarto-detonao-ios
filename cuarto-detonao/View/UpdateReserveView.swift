//
//  UpdateReserveView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 13-10-24.
//

import SwiftUI
import PhotosUI

struct UpdateReserveView: View {
    @Environment(\.dismiss) var dismiss
    
    var selectedReserve: ReserveModel
    @State private var updateReserveViewModel = UpdateReserveViewModel()
    @State private var reserveToUpdate = NewReserveModel(remitenteNombre: "", remitenteApellido: "", remitentePseudonimo: "", remitenteCurso: "", remitenteAnonimo: false, destinatarioNombre: "", destinatarioApellido: "", destinatarioPseudonimo: "", destinatarioCurso: "", totalAPagar: 0, dedicatoria: "", fotoURL: "", detalles: [])
    
    @State private var detalles: [NewReserveDetalle] = []
    
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
    @State private var isReserveUpdated = false
    
    @State private var totalToPay = 0
    
    
    let courses = [ "Séptimo A", "Séptimo B", "Octavo A", "Octavo B", "Primero Medio A", "Primero Medio B", "Primero Medio C", "Primero Medio D", "Segundo Medio A", "Segundo Medio B", "Segundo Medio C", "Segundo Medio D", "Tercero Medio A", "Tercero Medio B", "Tercero Medio C", "Tercero Medio D", "Cuarto Medio A", "Cuarto Medio B", "Cuarto Medio C", "Cuarto Medio D", "Profesor", "Personal del liceo"]
    
    var body: some View {
        NavigationStack {
            List {
                
                //MARK: - sender's data section
                Section {
                    TextField("Nombre remitente", text: $reserveToUpdate.remitenteNombre)
                        .onChange(of: reserveToUpdate.remitenteNombre) {
//                            reserveToUpdate.remitenteNombre = senderName
                            areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
                        }
                    
                    TextField("Apellido remitente", text: $reserveToUpdate.remitenteApellido)
                        .onChange(of: reserveToUpdate.remitenteApellido) {
//                            reserveToUpdate.remitenteApellido = senderLastName
                            areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
                        }
                    
                    TextField("Seudónimo remitente (opcional)", text: $reserveToUpdate.remitentePseudonimo)
                        .onChange(of: reserveToUpdate.remitentePseudonimo) {
//                            reserveToUpdate.remitentePseudonimo = senderNickName
                        }
                    
                    
                    Picker("Seleccionar curso", selection: $reserveToUpdate.remitenteCurso) {
                        Text("Selecciona curso")
                            .tag("")
                        ForEach(courses, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: reserveToUpdate.remitenteCurso) {
//                        reserveToUpdate.remitenteCurso = senderCourse
                        areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
                    }
                    
                    Toggle(isOn: $reserveToUpdate.remitenteAnonimo) {
                        HStack {
                            Text("Anónimo")
                            
                            Spacer()
                            
                            Text(reserveToUpdate.remitenteAnonimo ? "Sí" : "No")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                        }
                    }
                    .onChange(of: reserveToUpdate.remitenteAnonimo) {
                        reserveToUpdate.remitenteAnonimo = senderAnonymous
                    }
                } header: {
                    Text("Datos del remitente")
                }
                
                //MARK: - receiver's data section
                Section {
                    TextField("Nombre receptor", text: $reserveToUpdate.destinatarioNombre)
                        .onChange(of: reserveToUpdate.destinatarioNombre) {
//                            reserveToUpdate.destinatarioNombre = receiverName
                            areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
                        }
                    
                    TextField("Apellido receptor", text: $reserveToUpdate.destinatarioApellido)
                        .onChange(of: reserveToUpdate.destinatarioApellido) {
//                            reserveToUpdate.destinatarioApellido = receiverLastName
                            areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
                        }
                    
                    TextField("Seudónimo receptor (opcional)", text: $reserveToUpdate.destinatarioPseudonimo)
                        .onChange(of: reserveToUpdate.destinatarioPseudonimo) {
//                            reserveToUpdate.destinatarioPseudonimo = receiverNickName
                        }
                    
                    Picker("Seleccionar curso", selection: $reserveToUpdate.destinatarioCurso) {
                        Text("Selecciona curso")
                            .tag("")
                        ForEach(courses, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: reserveToUpdate.destinatarioCurso) {
//                        reserveToUpdate.destinatarioCurso = receiverCourse
                        areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
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
                        isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
                        totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
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
                        isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
                        totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
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
                        isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
                        totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
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
                        isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
                        totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
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
                        isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
                        totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
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
                        isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
                        totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
                    }
                } header: {
                    Text("Rosas")
                }
                
                //MARK: - Section incluir foto y dedicatoria
                Section {
                    Toggle("Incluír foto y dedicatoria", isOn: $includePhotoAndMessage)
                        .onChange(of: includePhotoAndMessage) {
                            if !includePhotoAndMessage {
                                reserveToUpdate.fotoURL = nil
                                reserveToUpdate.dedicatoria = nil
                                imageSelected = false
                            }
                            totalToPay = updateReserveViewModel.calculateTotal(reserveModel: reserveToUpdate, includePhotoAndMessage: includePhotoAndMessage)
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
                            } else if let unwrappedPhotoURL = selectedReserve.fotoURL {
                                let photoURL = URL(string: unwrappedPhotoURL)
                                
                                AsyncImage(url: photoURL) { phase in
                                    if let asyncImage = phase.image {
                                        asyncImage
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .frame(width: 250, height: 250)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Image(systemName: "x.mark")
                                    } else {
                                        // Acts as a placeholder.
                                        ProgressView().progressViewStyle(.circular)
                                        // Image("Mickey Mouse")
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .onChange(of: imageItem) {
                            Task {
                                if let data = try? await imageItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    image = uiImage
                                    reserveToUpdate.fotoURL = "placeholder_url" // Esto se actualizará cuando se suba la imagen
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
        .navigationTitle("Editar reserva de \(selectedReserve.remitenteNombre)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isThereAlmostOneRoseSelected && areEssentialFieldsCompleted && !includePhotoAndMessage {
                Button("Finalizar") {
                    Task {
                        showCreatingReserve = true
                        reserveToUpdate.totalAPagar = totalToPay
                        isReserveUpdated = await updateReserveViewModel.updateReserveByID(id: selectedReserve.id, reserveModel: reserveToUpdate)
                        showCreatingReserve = false
                    }
                }
            }
            
            if includePhotoAndMessage && isThereAlmostOneRoseSelected && areEssentialFieldsCompleted && areImageAndMessageCompleted {
                Button("Finalizar") {
                    Task {
                        showCreatingReserve = true
                        reserveToUpdate.totalAPagar = totalToPay
                        
                        if let image = image {
                            let imageURL = await updateReserveViewModel.uploadImageToFirebase(image: image, from: "\(reserveToUpdate.remitenteNombre)\(reserveToUpdate.remitenteApellido)", to: "\(reserveToUpdate.destinatarioNombre)\(reserveToUpdate.destinatarioApellido)")
                            reserveToUpdate.fotoURL = imageURL
                            reserveToUpdate.dedicatoria = textMessage
                        }
                        
                        isReserveUpdated = await updateReserveViewModel.updateReserveByID(id: selectedReserve.id, reserveModel: reserveToUpdate)
                        showCreatingReserve = false
                    }
                }
            }
        }
        .overlay {
            if showCreatingReserve {
                VStack {
                    Text("Actualizando reserva...")
                    
                    ProgressView()
                        .scaleEffect(1.4)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThickMaterial)
                )
            }
        }
        .alert("Reserva actualizada exitosamente", isPresented: $isReserveUpdated) {
            Button("Aceptar") {
//                dismiss()
            }
        }
        .onAppear {
            selectedReserve.detalles.forEach { detalle in
                detalles.append(NewReserveDetalle(colorNombre: detalle.colorNombre, cantidad: detalle.cantidad))
                
                switch detalle.colorNombre {
                case RosesColor.red.rawValue:
                    redRosesQuantity = detalle.cantidad
                case RosesColor.orange.rawValue:
                    orangeRosesQuantity = detalle.cantidad
                case RosesColor.purple.rawValue:
                    purpleRosesQuantity = detalle.cantidad
                case RosesColor.blue.rawValue:
                    blueRosesQuantity = detalle.cantidad
                case RosesColor.white.rawValue:
                    whiteRosesQuantity = detalle.cantidad
                case RosesColor.yellow.rawValue:
                    yellowRosesQuantity = detalle.cantidad
                default:
                    print("Error")
                }
            }
            
            if selectedReserve.fotoURL != nil {
                includePhotoAndMessage = true
            }
            
            reserveToUpdate = NewReserveModel(remitenteNombre: selectedReserve.remitenteNombre, remitenteApellido: selectedReserve.remitenteApellido, remitentePseudonimo: selectedReserve.remitentePseudonimo, remitenteCurso: selectedReserve.remitenteCurso, remitenteAnonimo: selectedReserve.remitenteAnonimo, destinatarioNombre: selectedReserve.destinatarioNombre, destinatarioApellido: selectedReserve.destinatarioApellido, destinatarioPseudonimo: selectedReserve.destinatarioPseudonimo, destinatarioCurso: selectedReserve.destinatarioCurso, totalAPagar: selectedReserve.totalAPagar, dedicatoria: selectedReserve.dedicatoria, fotoURL: selectedReserve.fotoURL,  detalles: detalles)
            
            areEssentialFieldsCompleted = updateReserveViewModel.checkEssentialInputs(reserveModel: reserveToUpdate)
            isThereAlmostOneRoseSelected = updateReserveViewModel.checkIfAlmostOneRoseIsSelected(roses: reserveToUpdate.detalles)
            areImageAndMessageCompleted = (image != nil && !textMessage.isEmpty) || (selectedReserve.fotoURL != nil && selectedReserve.dedicatoria != nil)
            
            textMessage = selectedReserve.dedicatoria ?? ""
        }
        
        
    }
    
    func updateRosesDetails(roseColor: String, roseQuantity: Int) {
        if let index = reserveToUpdate.detalles.firstIndex(where: { $0.colorNombre == roseColor }) {
            reserveToUpdate.detalles[index].cantidad = roseQuantity
        } else if roseQuantity > 0 {
            reserveToUpdate.detalles.append(NewReserveDetalle(colorNombre: roseColor, cantidad: roseQuantity))
        }
        
        reserveToUpdate.detalles = reserveToUpdate.detalles.filter { $0.cantidad > 0 }
    }
}

#Preview {
    UpdateReserveView(selectedReserve: ReserveModel(id: 20, remitenteNombre: "Marcelo", remitenteApellido: "Agacháte", remitentePseudonimo: "Conocélo", remitenteCurso: "Cuarto Medio A", remitenteAnonimo: false, destinatarioNombre: "Luis", destinatarioApellido: "Contreras", destinatarioPseudonimo: "", destinatarioCurso: "Cuarto Medio B", totalAPagar: 400, dedicatoria: "Para alguien muy especial", fotoURL: "https://firebasestorage.googleapis.com/v0/b/cuarto-detonao.appspot.com/o/fotos%2FfromMarceloAgachate-toLuisContreras-atWed%20Oct%2009%202024%2018%3A04%3A38%20GMT-0300%20(Chile%20Summer%20Time).jpg?alt=media&token=4c331946-cf60-4e6e-b9f0-30841fa78eb2", createdAt: "2024-10-09T21:04:42.180Z", detalles: [Detalle(colorNombre: "Roja", cantidad: 2)]))
}

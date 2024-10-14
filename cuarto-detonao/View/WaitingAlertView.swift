//
//  WatingAlertView.swift
//  cuarto-detonao
//
//  Created by Jacob Aguilar on 14-10-24.
//

import SwiftUI

struct WaitingAlertView: View {
    
    var message: String
    
    var body: some View {
        VStack {
            Text(message)
                .font(.title3)
                .bold()
            
            ProgressView()
                .scaleEffect(1.2)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThickMaterial)
        )
    }
}

#Preview {
    WaitingAlertView(message: "Actualizando reserva...")
}

//
//  ButtonLabelComponent.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import SwiftUI

struct ButtonLabelComponent: View {
    let title: String
    let type: ButtonType
    
    enum ButtonType {
        case primary
        case secondary
        case delete
        
        var fgColor: Color {
            switch self {
            case .primary:
                Color.white
            case .secondary:
                Color.black.opacity(0.8)
            case .delete:
                Color.white
            }
        }
        
        var bgColor: Color {
            switch self {
            case .primary:
                Color.primaryPurple
            case .secondary:
                Color.gray100
            case .delete:
                Color.mainRed
            }
        }
    }
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundColor(type.fgColor)
            .font(.headline)
            .background(type.bgColor)
            .cornerRadius(12)
    }
    
}

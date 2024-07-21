//
//  Button.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct IS_ButonStyle: ButtonStyle {
    let type: ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundColor(type.fgColor)
            .font(.headline)
            .background(configuration.isPressed ? type.bgColor.opacity(0.7) : type.bgColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    
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
}

struct IS_Button_Modifier: ViewModifier {
    let type: IS_ButonStyle.ButtonType
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(IS_ButonStyle(type: type))
    }
}

extension Button {
    func ilsangButtonStyle(type: IS_ButonStyle.ButtonType) -> some View {
        modifier(IS_Button_Modifier(type: type))
    }
}


#Preview {
    VStack {
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .primary)
        
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .secondary)
        
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .delete)
    }
}

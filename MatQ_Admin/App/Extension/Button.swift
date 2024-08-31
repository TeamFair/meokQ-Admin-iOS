//
//  Button.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct IS_ButonStyle: ButtonStyle {
    let type: ButtonType
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundColor(type.fgColor.opacity(isDisabled ? 0.8 : 1.0))
            .font(.headline)
            .background(isDisabled ? type.bgColor.opacity(0.3) : (configuration.isPressed ? type.bgColor.opacity(0.7) : type.bgColor))
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
    let isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(IS_ButonStyle(type: type, isDisabled: isDisabled))
    }
}

extension Button {
    func ilsangButtonStyle(type: IS_ButonStyle.ButtonType, isDisabled: Bool = false) -> some View {
        modifier(IS_Button_Modifier(type: type, isDisabled: isDisabled))
    }
}


#Preview {
    VStack {
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .primary, isDisabled: true)
        
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .primary, isDisabled: false)
        
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .secondary, isDisabled: true)
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .secondary, isDisabled: false)
        
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .delete, isDisabled: true)
        
        Button { } label: { Text("Button") }
            .ilsangButtonStyle(type: .delete, isDisabled: false)
    }
}

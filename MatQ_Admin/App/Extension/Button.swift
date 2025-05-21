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
            .foregroundColor(isDisabled ? ButtonType.disableFgColor : type.fgColor)
            .font(.headline)
            .background(isDisabled ? ButtonType.disableBgColor : (configuration.isPressed ? type.bgColor.opacity(0.7) : type.bgColor))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    
    enum ButtonType {
        case primary
        case secondary
        case tertiary
        case delete
        static var disableFgColor: Color = Color.gray400
        static var disableBgColor: Color = Color.gray100
        
        var fgColor: Color {
            switch self {
            case .primary:
                Color.white
            case .secondary:
                Color.primaryPurple
            case .tertiary:
                Color.gray500
            case .delete:
                Color.white
            }
        }
        
        var bgColor: Color {
            switch self {
            case .primary:
                Color.primaryPurple
            case .secondary:
                Color.primaryPurple.opacity(0.1)
            case .tertiary:
                Color.gray200
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
        Button { } label: { Text("Primary Button") }
            .ilsangButtonStyle(type: .primary, isDisabled: false)
        Button { } label: { Text("Primary Button") }
            .ilsangButtonStyle(type: .primary, isDisabled: true)
        
        Button { } label: { Text("Secondary Button") }
            .ilsangButtonStyle(type: .secondary, isDisabled: false)
        Button { } label: { Text("SecondaryButton") }
            .ilsangButtonStyle(type: .secondary, isDisabled: true)
        
        Button { } label: { Text("Tertiary Button") }
            .ilsangButtonStyle(type: .tertiary, isDisabled: false)
        Button { } label: { Text("Tertiary Button") }
            .ilsangButtonStyle(type: .tertiary, isDisabled: true)
        
        Button { } label: { Text("Delete Button") }
            .ilsangButtonStyle(type: .delete, isDisabled: false)
        Button { } label: { Text("Delete Button") }
            .ilsangButtonStyle(type: .delete, isDisabled: true)
    }
}

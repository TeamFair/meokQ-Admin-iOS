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

struct IS_ButonView: ButtonStyle {
    let type: ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundColor(type.fgColor)
            .font(.headline)
            .background(type.bgColor)
            .cornerRadius(12)
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


#Preview {
    VStack {
        Button {} label : { Text("공지 삭제하기") }.buttonStyle(IS_ButonView(type: .delete))
        Button(action: {}, label: {
            Text("Button")
        })
        .ilsangButtonStyle(type: .delete)
        //        IS_ButonView(title: "공지 삭제하기", type: .secondary)
        //        IS_ButonView(title: "공지 삭제하기", type: .delete)
    }
}

struct ISButton: ViewModifier {
    let type: IS_ButonView.ButtonType
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(IS_ButonView(type: type))
    }
}
extension Button {
    func ilsangButtonStyle(type: IS_ButonView.ButtonType) -> some View {
        modifier(ISButton(type: type))
    }
}

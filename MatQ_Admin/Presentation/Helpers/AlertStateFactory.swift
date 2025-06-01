//
//  AlertStateFactory.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/30/25.
//

import SwiftUI

struct AlertButton: Identifiable {
    let id = UUID()
    let title: String
    let role: ButtonRole?
    let action: (() -> Void)?
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let buttons: [AlertButton]
}


struct AlertItemModifier: ViewModifier {
    @Binding var isPresented: Bool
    let alertItem: AlertItem?

    func body(content: Content) -> some View {
        content.alert(
            alertItem?.title ?? "",
            isPresented: $isPresented,
            presenting: alertItem
        ) { item in
            buttonView(item.buttons)
        } message: { item in
            Text(item.message)
        }
    }
    
    private func buttonView(_ buttons: [AlertButton]) -> some View {
        ForEach(buttons, id: \.id) { button in
            Button(button.title, role: button.role) {
                button.action?()
            }
        }
    }
}

extension View {
    func alertItem(_ alertItem: AlertItem?, isPresented: Binding<Bool>) -> some View {
        self.modifier(AlertItemModifier(isPresented: isPresented, alertItem: alertItem))
    }
}

enum AlertStateFactory {
    
    static func base(
        title: String,
        message: String,
        buttons: [AlertButton]
    ) -> AlertItem {
        AlertItem(title: title, message: message, buttons: buttons)
    }
    
    static func simple(title: String, message: String, onConfirm: (() -> Void)? = nil) -> AlertItem {
        base(
            title: title,
            message: message,
            buttons: [AlertButton(title: "확인", role: .none, action: onConfirm)]
        )
    }
    
    static func deleteConfirmation(
        onConfirm: @escaping () -> Void
    ) -> AlertItem {
        base(
            title: "정말 삭제하시겠어요?",
            message: "이 작업은 되돌릴 수 없습니다.",
            buttons: [
                AlertButton(title: "삭제", role: .destructive, action: onConfirm),
                AlertButton(title: "취소", role: .cancel, action: nil)
            ]
        )
    }
    
    static func destructiveConfirmation(
        title: String,
        message: String,
        onConfirm: @escaping () -> Void
    ) -> AlertItem {
        base(
            title: title,
            message: message,
            buttons: [
                AlertButton(title: "삭제", role: .destructive, action: onConfirm),
                AlertButton(title: "취소", role: .cancel, action: nil)
            ]
        )
    }
    
    static func networkError(retry: (() -> Void)? = nil) -> AlertItem {
        return AlertItem(
            title: "네트워크 오류",
            message: "인터넷 연결을 확인해주세요.",
            buttons: [
                AlertButton(title: "확인", role: .cancel, action: nil),
                retry.map { AlertButton(title: "재시도", role: nil, action: $0) }
            ].compactMap { $0 }
        )
    }
}

//
//  UIApplication++.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/10/24.
//

import SwiftUI

extension View {
    func textEditEnding() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
        let feedbackGenerator = UISelectionFeedbackGenerator()

        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
    }
}

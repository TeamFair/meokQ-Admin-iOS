//
//  SearchTextField.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 12/17/24.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String
    let clearAction: () -> ()
    
    var body: some View {
        TextField("", text: $searchText)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .overlay(alignment: .trailing) {
                if searchText != "" {
                    Button {
                        withAnimation {
                            clearAction()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray300)
                    }
                } else {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray300)
                }
            }
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.componentPrimary)
            )
    }
}

#Preview {
    SearchTextField(searchText: .constant("검색~"), clearAction: { })
}


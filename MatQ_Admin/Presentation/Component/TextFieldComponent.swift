//
//  TextFieldComponent.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct TextFieldComponent: View {
    let titleName : String
    let contentPlaceholder : String?
    @Binding var content : String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline).bold()
            if let contentPlaceholder = contentPlaceholder {
                TextField("\(contentPlaceholder)", text: $content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundStyle(.textPrimary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.componentPrimary)
                    )
            }
        }
        .padding(.bottom, 16)
    }
}


struct ImageFieldComponent: View {
    let titleName : String
    @Binding var uiImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline).bold()

            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 160, height: 160)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 160, height: 160)
                    .cornerRadius(12)
                    .background(.regularMaterial)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
    }
}

#Preview {
    TextFieldComponent(titleName: "Title", contentPlaceholder: "Placeholder", content: .constant("Test"))
}

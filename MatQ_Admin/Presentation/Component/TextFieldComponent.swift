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
    let uiImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline).bold()
                .multilineTextAlignment(.leading)
                .foregroundStyle(.textPrimary)
            
            Group {
                if let image = uiImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.regularMaterial)
                }
            }
            .frame(width: UIImageSize.medium.value, height: UIImageSize.medium.value)
            .cornerRadius(12)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
    }
}

#Preview {
    VStack {
        TextFieldComponent(titleName: "TextField", contentPlaceholder: "Placeholder", content: .constant("Test"))
        ImageFieldComponent(titleName: "ImageField", uiImage: (.testimage))
    }
}

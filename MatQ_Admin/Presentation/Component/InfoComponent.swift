//
//  InfoComponent.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct InfoComponent: View {
    let titleName : String
    var contentName : String?
    var uiImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline)
            if let content = contentName {
                Text(content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundStyle(.textPrimary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.componentPrimary)
                    )
            }
            
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width:98, height:98)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
            }
            
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    InfoComponent(titleName: "제목", contentName: "내용")
}

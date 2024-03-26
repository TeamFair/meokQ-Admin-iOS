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
    var imageName: String?
    
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
            // TODO: 이미지 연결
//            if image = imageName {
//               AsyncImage(url: imageName)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .font(.body)
//                    .padding()
//                    .background(.regularMaterial)
//            }
            
        }
        .padding(.bottom, 16)
    }
}

#Preview {
    InfoComponent(titleName: "제목", contentName: "내용")
}

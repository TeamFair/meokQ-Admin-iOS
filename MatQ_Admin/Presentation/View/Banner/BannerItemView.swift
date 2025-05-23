//
//  BannerItemView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import SwiftUI

struct BannerItemView: View {
    let banner: Banner
    
    var body: some View {
        HStack(spacing: 0){
            Group {
                if let image = banner.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Rectangle()
                        .foregroundStyle(.gray100)
                }
            }
            .frame(width: UIImageSize.regular.value, height: UIImageSize.regular.value)
            .cornerRadius(8)
            .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(banner.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.textPrimary)
                    .multilineTextAlignment(.leading)
                Text(banner.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray500)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray300)
                .font(.system(size: 14))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.componentSecondary)
                .shadow(color: .black.opacity(0.05), radius: 12)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}

#Preview {
    BannerItemView(banner: .mockActiveData)
}

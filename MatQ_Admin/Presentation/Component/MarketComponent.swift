//
//  MarketComponent.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct MarketComponent: View {
    
    let marketImage : String
    let marketName : String
    
    var body: some View {
        HStack(spacing: 0){
            // TODO: 이미지 연결
//            Image(marketImage)
//                .resizable()
//                .frame(width: 76, height: 76)
//                .cornerRadius(10)
//                .padding(.trailing, 14)
//            
                Text(marketName)
                    .bold()
                    .font(.system(size: 15))
                    .padding(.bottom, 8)
            
            Spacer()
            Image(systemName: "chevron.right")
            
        }
        .padding()
        .foregroundStyle(.black)
        .frame(height: 108)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.white)
        )
        .shadow(color: .black.opacity(0.05), radius: 12)
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        
    }
}

#Preview {
    MarketComponent(marketImage: "testimage", marketName: "커피크라운")
}

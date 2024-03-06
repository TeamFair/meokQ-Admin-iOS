//
//  NoticeComponent.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticeComponent: View {
    
    let noticeName : String
    let timeStamp : String
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading, spacing: 0){
                Text(noticeName)
                    .bold()
                    .font(.system(size: 15))
                    .padding(.bottom, 8)
                    .foregroundStyle(.black)
                Text(timeStamp)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray400)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray400)
        }
        .padding()
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.white)
        )
        .frame(height: 80)
    }
}

#Preview {
    NoticeComponent(noticeName: "test", timeStamp: "date")
}

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
                    .foregroundStyle(.textPrimary)
                Text(timeStamp)
                    .font(.system(size: 12))
                    .foregroundStyle(.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(.textSecondary)
        }
        .padding()
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.componentPrimary)
        )
        .frame(height: 80)
    }
}

#Preview {
    NoticeComponent(noticeName: "test", timeStamp: "date")
}

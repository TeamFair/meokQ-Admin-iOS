//
//  QuestItemView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct QuestItemView: View {
    let questImage : UIImage
    let missionTitle : String
    let expireDate : String

    var body: some View {
        HStack(spacing: 0){
            Image(uiImage: questImage)
                .resizable()
                .frame(width: 76, height: 76)
                .cornerRadius(10)
                .padding(.trailing, 14)
            VStack(alignment: .leading, spacing: 8) {
                Text(missionTitle)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.textPrimary)
                Text(expireDate)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray500)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray300)
        }
        .padding()
        .frame(height: 108)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.componentSecondary)
                .shadow(color: .black.opacity(0.05), radius: 12)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
    }
}

#Preview {
    QuestItemView(questImage: .testimage, missionTitle: "Mission", expireDate: "2025.02.11")
}

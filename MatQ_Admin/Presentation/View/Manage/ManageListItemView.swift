//
//  ManageListItemView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import SwiftUI

struct ManageListItemView: View {
    let challengeTitle: String
    let userNickname: String

    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .leading, spacing: 6) {
                Text(challengeTitle)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.textPrimary)
                Text(userNickname)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray500)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray300)
        }
        .padding()
        .frame(height: 80)
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
    ManageListItemView(challengeTitle: "챌린지명", userNickname: "일상1234")
}

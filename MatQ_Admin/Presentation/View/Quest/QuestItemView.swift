//
//  QuestItemView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct QuestItemView: View {
    let questImage: UIImage?
    let missionTitle: String
    let writer: String
    let target: QuestRepeatTarget
    let stats: [XpStat]

    var body: some View {
        HStack(spacing: 0){
            Group {
                if let questImage = questImage {
                    Image(uiImage: questImage)
                        .resizable()
                        .frame(width: UIImageSize.small.value, height: UIImageSize.small.value)
                } else {
                    Rectangle()
                        .frame(width: UIImageSize.small.value, height: UIImageSize.small.value)
                        .foregroundStyle(.gray100)
                }
            }
            .cornerRadius(10)
            .padding(.trailing, 14)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(writer)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray500)
                    .padding(.bottom, -6)
                Text(missionTitle)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.textPrimary)
                HStack {
                    typeTagView(target)
                    ForEach(stats, id: \.rawValue) { stat in
                        tagView(stat.korean)
                    }
                }
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
    
    private func tagView(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .medium))
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .foregroundStyle(.textSecondary)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(.textSecondary.opacity(0.1))
            )
    }
    
    private func typeTagView(_ target: QuestRepeatTarget) -> some View {
        Text(target.title)
            .font(.system(size: 11, weight: .semibold))
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .foregroundStyle(Color(target.color).opacity(0.7))
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(target.color).opacity(0.1))
            )
    }
}

#Preview {
    VStack {
        QuestItemView(questImage: .testimage, missionTitle: "베트남 음식 도전하기", writer: "일상 초심자", target: .daily, stats: [.charm, .fun])
        QuestItemView(questImage: .testimage, missionTitle: "나무 사진 찍기", writer: "일상 요리사", target: .weekly, stats: [.charm])
        QuestItemView(questImage: .testimage, missionTitle: "혼밥 자랑하기", writer: "일상 사냥꾼", target: .monthly, stats: [.charm, .sociability])
        QuestItemView(questImage: .testimage, missionTitle: "태국 음식 도전하기", writer: "일상 초심자", target: .none, stats: [.charm, .intellect])
    }
}

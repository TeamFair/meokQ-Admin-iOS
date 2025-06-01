//
//  QuestItemView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct QuestItemView: View {
    let questImage: UIImage?
    let mainQuestImage: UIImage?
    let mission: Mission
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
            .cornerRadius(8)
            .padding(.trailing, 6)
            
            Group {
                if let questImage = mainQuestImage {
                    Image(uiImage: questImage)
                        .resizable()
                        .frame(width: UIImageSize.small.value, height: UIImageSize.small.value)
                } else {
                    Rectangle()
                        .frame(width: UIImageSize.small.value, height: UIImageSize.small.value)
                        .foregroundStyle(.gray100)
                }
            }
            .cornerRadius(6)
            .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(writer)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray500)
                    .padding(.bottom, -6)
                
                Text(mission.content)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.textPrimary)
                
                HStack(spacing: 5) {
                    switch MissionType(rawValue: mission.type) {
                    case .FREE:
                        tagView("📸")
                    case .OX:
                        tagView("🙆🏻")
                    default:
                        tagView("✏️")
                    }
                    
                    typeTagView(target)
                    
                    ForEach(stats, id: \.rawValue) { stat in
                        tagView(stat.korean)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.leading, 12)
        .padding(.trailing, 4)
        .frame(height: 98)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.componentSecondary)
                .shadow(color: .black.opacity(0.05), radius: 12)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
    
    private func tagView(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 10, weight: .medium))
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
            .font(.system(size: 10, weight: .semibold))
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .foregroundStyle(Color(target.color).opacity(0.7))
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(target.color).opacity(0.1))
            )
    }
}

#Preview {
    let quiz = Quiz(question: "2+4는?", hint: "머게", answers: [.init(content: "6")])
    
    VStack {
        QuestItemView(questImage: .testimage, mainQuestImage: .testimage, mission: .init(content: "베트남 음식 도전하기"), writer: "일상 초심자", target: .daily, stats: [.charm, .fun])
        QuestItemView(questImage: .testimage, mainQuestImage: .testimage,  mission: .init(content: "나무 사진 찍기"), writer: "일상 요리사", target: .weekly, stats: [.charm])
        QuestItemView(questImage: .testimage, mainQuestImage: .testimage, mission: .init(content: "혼밥 자랑하기"), writer: "일상 사냥꾼", target: .monthly, stats: [.charm, .sociability, .fun, .intellect, .strength])
        QuestItemView(questImage: .testimage, mainQuestImage: .testimage, mission: .init(content: "퀴즈", missionType: .WORDS, quizzes: [quiz]), writer: "일상 초심자", target: .none, stats: [.charm, .intellect])
    }
}

//
//  QuestDetailView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct QuestDetailView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm : QuestDetailViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationBarComponent(navigationTitle: vm.viewType.title, isNotRoot: true)
                .overlay(alignment: .trailing) {
                    Button {
                        // TODO: 퀘스트 삭제 API 연결
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.primaryPurple)
                    }
                    .opacity(vm.viewType == .edit ? 1 : 0)
                    .padding(.trailing, 20)
                }
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextFieldComponent(titleName: "미션 제목", contentPlaceholder: vm.items.questTitle, content: $vm.editedItems.questTitle)
                    TextFieldComponent(titleName: "리워드 XP", contentPlaceholder: vm.items.xpCount, content: $vm.editedItems.xpCount)
                    TextFieldComponent(titleName: "작성자", contentPlaceholder: vm.items.publisher, content: $vm.editedItems.publisher)
                    TextFieldComponent(titleName: "만료 기한", contentPlaceholder: vm.items.expireDate, content: $vm.editedItems.expireDate)
                    ImageFieldComponent(titleName: "퀘스트 이미지", uiImage: $vm.editedItems.questImage)
                }
                .padding(.horizontal, 20)
            }
            
            Button {
                // TODO: 퀘스트 수정/게시 API 연결

            } label: {
                Text(vm.viewType.buttonTitle)
            }
            .ilsangButtonStyle(type: .primary)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    QuestDetailView(vm: QuestDetailViewModel(viewType: .edit, questDetail: .initialData))
}

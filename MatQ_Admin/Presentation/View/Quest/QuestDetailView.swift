//
//  QuestDetailView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI
import Combine
import PhotosUI

struct QuestDetailView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm : QuestDetailViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            NavigationBarComponent(navigationTitle: vm.viewType.title, isNotRoot: true)
                .overlay(alignment: .trailing) {
                    HStack(spacing: 20) {
                        Button {
                            vm.showAlert = true
                            vm.selectedDeleteType = .soft
                            vm.activeAlertType = .delete
                        } label: {
                            Image(systemName: "eraser")
                                .foregroundStyle(.primaryPurple)
                        }
                        
                        Button {
                            vm.showAlert = true
                            vm.selectedDeleteType = .hard
                            vm.activeAlertType = .delete
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.primaryPurple)
                        }
                    }
                    .opacity(vm.viewType == .edit ? 1 : 0)
                    .padding(.trailing, 20)
                }
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TextFieldComponent(titleName: "미션 제목", contentPlaceholder: vm.items.questTitle, content: $vm.editedItems.questTitle)
                    TextFieldComponent(titleName: "리워드 XP", contentPlaceholder: String(vm.items.xpCount), content: $vm.editedItems.xpCount)
                    TextFieldComponent(titleName: "작성자", contentPlaceholder: vm.items.writer, content: $vm.editedItems.writer)
                    TextFieldComponent(titleName: "만료 기한", contentPlaceholder: vm.items.expireDate, content: $vm.editedItems.expireDate)
                    
                    if vm.viewType == .publish {
                        PhotosPicker(selection: $vm.photosPickerItem, matching: .any(of: [.images, .screenshots])) {
                            ImageFieldComponent(titleName: "퀘스트 이미지", uiImage: vm.editedItems.questImage)
                        }
                    } else {
                        ImageFieldComponent(titleName: "퀘스트 이미지", uiImage: vm.items.questImage)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            if vm.viewType == .publish {
                Button {
                    // TODO: 퀘스트 수정 API 연결
                    vm.createData(data: vm.editedItems)
                } label: {
                    Text(vm.viewType.buttonTitle)
                }
                .ilsangButtonStyle(type: .primary)
                .padding(.horizontal, 20)
            }
        }
        .alert(isPresented: $vm.showAlert) {
            switch vm.activeAlertType {
            case .delete:
                Alert(
                    title: Text("퀘스트를 삭제하시겠습니까?"),
                    message: Text("퀘스트를 복구할 수 없습니다."),
                    primaryButton: .cancel(Text("취소")),
                    secondaryButton: .destructive(Text("삭제")) {
                        vm.deleteData(questId: vm.editedItems.questId, type: vm.selectedDeleteType)
                    }
                )
            case .result:
                Alert(
                    title: Text(vm.alertTitle),
                    message: Text(vm.alertMessage),
                    dismissButton: .default(Text("확인")) {
                        if vm.alertTitle == "퀘스트 추가 성공" || vm.alertTitle == "퀘스트 삭제 성공" {
                            router.pop()
                        }
                    }
                )
            case .none:
                Alert(title: Text(""))
            }
        }
    }
}

//#Preview {
//    QuestDetailView(vm: QuestDetailViewModel(viewType: .edit, questDetail: .initialData))
//}

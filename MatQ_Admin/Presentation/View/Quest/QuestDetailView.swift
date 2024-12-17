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
                            vm.selectedDeleteType = .soft
                            vm.activeAlertType = .delete
                            vm.showAlert = true
                        } label: {
                            Image(systemName: "eraser")
                                .foregroundStyle(.primaryPurple)
                        }
                        
                        Button {
                            vm.selectedDeleteType = .hard
                            vm.activeAlertType = .delete
                            vm.showAlert = true
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
                        .overlay(alignment: .topTrailing) {
                            Text("\(vm.editedItems.questTitle.count) / 16")
                                .foregroundStyle(vm.editedItems.questTitle.count > 16 ? .red : .textPrimary)
                                .opacity(vm.viewType == .publish ? 1 : 0)
                                .font(.caption2)
                                .padding(.trailing, 8)
                                .offset(y: 2)
                        }
                 
                    VStack(alignment: .leading) {
                        Text("스탯")
                            .font(.subheadline).bold()
                            .foregroundStyle(.textSecondary)

                        VStack {
                            SliderComponent(titleName: "체력", contentPlaceholder: vm.items.strengthXP, content: Binding(
                                get: { Double(vm.editedItems.strengthXP) },
                                set: { vm.editedItems.strengthXP = Int($0) }
                            ))
                            SliderComponent(titleName: "지능", contentPlaceholder: vm.items.intellectXP, content: Binding(
                                get: { Double(vm.editedItems.intellectXP) },
                                set: { vm.editedItems.intellectXP = Int($0) }
                            ))
                            SliderComponent(titleName: "재미", contentPlaceholder: vm.items.funXP, content: Binding(
                                get: { Double(vm.editedItems.funXP) },
                                set: { vm.editedItems.funXP = Int($0) }
                            ))
                            SliderComponent(titleName: "매력", contentPlaceholder: vm.items.charmXP, content: Binding(
                                get: { Double(vm.editedItems.charmXP) },
                                set: { vm.editedItems.charmXP = Int($0) }
                            ))
                            SliderComponent(titleName: "사회성", contentPlaceholder: vm.items.sociabilityXP, content: Binding(
                                get: { Double(vm.editedItems.sociabilityXP) },
                                set: { vm.editedItems.sociabilityXP = Int($0) }
                            ))
                        }
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.componentPrimary)
                        )
                    }
                    
                    TextFieldComponent(titleName: "우선순위", contentPlaceholder: String(vm.items.score), content: Binding(
                        get: { String(vm.editedItems.score) },
                        set: { vm.editedItems.score = Int($0) ?? 0 }
                    ))
                    TextFieldComponent(titleName: "작성자", contentPlaceholder: vm.items.writer, content: $vm.editedItems.writer)
                    TextFieldComponent(titleName: "만료 기한", contentPlaceholder: vm.items.expireDate, content: $vm.editedItems.expireDate)
                    SegmentComponent(title: "타입", content: $vm.editedItems.questType, list: QuestType.allCases)
                    SegmentComponent(title: "반복 타입", content: $vm.editedItems.questTarget, list: QuestRepeatTarget.allCases)
                        .disabled(vm.editedItems.questType != .repeat)
                    
                    PhotosPicker(selection: $vm.photosPickerItem, matching: .any(of: [.images, .screenshots])) {
                        ImageFieldComponent(titleName: "퀘스트 이미지", uiImage: vm.editedItems.questImage)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.immediately)
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
        .safeAreaInset(edge: .bottom) {
            // TODO: 스탯 전부 0이면 생성 & 수정 불가
            Button {
                if vm.viewType == .edit {
                    let imageUpdated = vm.editedItems.questImage != vm.items.questImage // 이미지가 변경되었는지 확인
                    vm.modifyData(vm.editedItems, imageUpdated: imageUpdated)
                } else if vm.viewType == .publish {
                    vm.createData(data: vm.editedItems)
                }
            } label: {
                Text(vm.viewType.buttonTitle)
            }
            .ilsangButtonStyle(type: .primary, isDisabled: vm.editedItems.questTitle.count > 16 || vm.editedItems.questTitle.count == 0)
            .disabled(vm.editedItems.questTitle.count > 16 || vm.editedItems.questTitle.count == 0)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
    }
}

//#Preview {
//    QuestDetailView(vm: QuestDetailViewModel(viewType: .edit, questDetail: .initialData))
//}

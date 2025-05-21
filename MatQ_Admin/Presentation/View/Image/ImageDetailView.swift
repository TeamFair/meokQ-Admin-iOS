//
//  ImageDetailView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 2/28/25.
//

import SwiftUI
import PhotosUI

struct ImageDetailView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm : ImageDetailViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            NavigationBarComponent(navigationTitle: vm.viewType.title, isNotRoot: true)
                .overlay(alignment: .trailing) {
                    Button {
                        vm.activeAlertType = .delete
                        vm.showAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.primaryPurple)
                    }
                    .opacity(vm.viewType == .edit ? 1 : 0)
                    .disabled(vm.viewType != .edit)
                    .padding(.trailing, 20)
                }
            
            VStack(alignment: .leading, spacing: 24) {
                // 이미지 ID
                if vm.editedItems.imageId != "" {
                    InputFieldComponent(
                        titleName: "이미지 ID",
                        inputField: TextFieldComponent(
                            placeholder: vm.item.imageId,
                            content: Binding(
                                get: { vm.editedItems.imageId },
                                set: { vm.editedItems.imageId = $0 }
                            )
                        )
                    )
                    .disabled(true)
                    .overlay(alignment: .trailing) {
                        Button {
                            copyToClipboard(text: vm.editedItems.imageId)
                        } label: {
                            Text("복사")
                                .font(.caption)
                                .padding(.top, 20)
                                .padding(.trailing, 16)
                                .foregroundStyle(.primaryPurple)
                        }
                    }
                }
                
                // 이미지
                PhotosPicker(selection: $vm.photosPickerItemForMainImage, matching: .any(of: [.images, .screenshots])) {
                    ImageFieldComponent(titleName: "이미지", uiImage: vm.editedItems.image, imageSize: .large, contentMode: .fit)
                }
                .disabled(vm.viewType == .edit)
                
                if vm.viewType == .edit {
                    Button {
                        copyToClipboard(text: vm.editedItems.imageId)
                        vm.showQuestMainView = true
                    } label: {
                        Text("사용된 퀘스트 찾기 >")
                            .font(.caption)
                            .foregroundStyle(.primaryPurple)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .safeAreaInset(edge: .bottom) {
                // 하단 버튼
                if vm.viewType == .publish {
                    Button {
                        if let image = vm.editedItems.image {
                            vm.postImage(image: image)
                        }
                    } label: {
                        Text(vm.viewType.buttonTitle)
                    }
                    .ilsangButtonStyle(type: .primary, isDisabled: vm.editedItems.image == nil)
                    .disabled(vm.editedItems.image == nil)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                }
            }
            .sheet(isPresented: $vm.showQuestMainView) {
                router.buildScene(path: .QuestMainView)
            }
            .alert(isPresented: $vm.showAlert) {
                switch vm.activeAlertType {
                case .delete:
                    Alert(
                        title: Text("이미지를 삭제하시겠습니까?"),
                        message: Text("이미지를 복구할 수 없습니다."),
                        primaryButton: .cancel(Text("취소")),
                        secondaryButton: .destructive(Text("삭제")) {
                            vm.deleteImage(imageId: vm.editedItems.imageId)
                        }
                    )
                case .result:
                    Alert(
                        title: Text(vm.alertTitle),
                        message: Text(vm.alertMessage),
                        dismissButton: .default(Text("확인")) {
                            if vm.alertTitle == "이미지 삭제 성공" {
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
}

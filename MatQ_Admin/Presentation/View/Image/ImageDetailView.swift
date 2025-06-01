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
                        vm.onDeleteButtonTap()
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
                            placeholder: vm.editedItems.imageId,
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
                
                // 이미지 타입
                SegmentComponent(
                    content: $vm.selectedImageType,
                    list: ImageType.allCases
                )
                .disabled(vm.viewType == .edit)
                .onChange(of: vm.selectedImageType) { _, newValue in
                    vm.handleChange(type: newValue)
                }
                
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
                            vm.postImage(image: image, type: vm.selectedImageType)
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
            .alertItem(vm.alertItem, isPresented: $vm.showAlert)
            .onChange(of: vm.shouldPop) { _, shouldPop in
                if shouldPop {
                    router.pop()
                }
            }
        }
    }
}

#Preview {
    ImageDetailView(vm: ImageDetailViewModel(viewType: .publish, imageType: .BANNER_IMAGE, imageItem: .mockData[0], imageRepository: MockImageRepository()))
}

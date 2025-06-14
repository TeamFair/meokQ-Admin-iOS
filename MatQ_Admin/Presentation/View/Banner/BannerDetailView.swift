//
//  BannerDetailView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 5/22/25.
//

import SwiftUI

struct BannerDetailView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm : BannerDetailViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            navigationBar
            contentView
        }
        .alertItem(vm.alertItem, isPresented: $vm.showAlert)
        .onChange(of: vm.shouldPop) { _, shouldPop in
            if shouldPop {
                router.pop()
            }
        }
        .safeAreaInset(edge: .bottom, content: bottomButton)
    }
    
    private var navigationBar: some View {
        NavigationBarComponent(navigationTitle: vm.viewType.title, isNotRoot: true)
            .overlay(alignment: .trailing) { navigationTrailingButtons }
    }
    
    private var navigationTrailingButtons: some View {
        Button {
            vm.onDeleteButtonTap()
        } label: {
            Image(systemName: "trash")
                .foregroundStyle(.primaryPurple)
        }
        .opacity(vm.viewType == .edit ? 1 : 0)
        .padding(.trailing, 20)
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                bannerDirectionView
                
                if vm.viewType == .edit {
                    ToggleComponent(titleName: "활성화", isOn: $vm.editedItems.activeYn)
                        .padding(.trailing, 4)
                }
                
                InputFieldComponent(
                    titleName: "제목",
                    inputField: TextFieldComponent(
                        placeholder: vm.initialItem.title,
                        content: $vm.editedItems.title
                    )
                )
                
                InputFieldComponent(
                    titleName: "화면 전환 경로",
                    inputField: TextFieldComponent(
                        placeholder: vm.initialItem.description,
                        content: $vm.editedItems.description
                    )
                )
                
                imageInputView
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 80)
        }
        .scrollIndicators(.never)
        .scrollDismissesKeyboard(.immediately)
    }
    
    private var bannerDirectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("배너 관리 안내사항")
                .font(.headline)
            Text("- 하나의 이미지는 하나의 배너에만 사용할 수 있어요.")
            Text("- 배너 등록 후, 수정 화면에서 직접 배너를 활성화해야 해요.")
            Text("- 배너 등록 후, 이미지는 수정할 수 없어요.")
            Text("- 배너 삭제 시, 이미지도 삭제돼요.")
            Text("- 화면 전환 경로는 **quest · rank · my · approval**로 설정되어 있어요.")
        }
        .font(.subheadline)
        .foregroundStyle(.textPrimary)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color.bgSecondary)
        )
    }
    
    private var imageInputView: some View {
        VStack(alignment: .leading) {
            Button {
                vm.showManageImageView.toggle()
            } label: {
                ImageFieldComponent(
                    titleName: "배너 이미지",
                    uiImage: vm.editedItems.image,
                    imageSize: .custom(UIImageSize.maxWidth.value - 40),
                    contentMode: .fit
                )
            }
            .disabled(vm.viewType == .edit)
            
            Button {
                copyToClipboard(text: vm.editedItems.imageId)
            } label: {
                Text(vm.editedItems.imageId)
                    .font(.subheadline)
                    .padding(.vertical, 4)
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .imageSelected, object: nil)
        }
        .sheet(isPresented: $vm.showManageImageView) {
            router.buildScene(path: .ImageMainView(type: .selectingItem))
        }
    }
    
    private func bottomButton() -> some View {
        Button(action: { vm.onPrimaryButtonTap() }) {
            Text(vm.viewType.buttonTitle)
        }
        .ilsangButtonStyle(type: .primary, isDisabled: vm.isPrimaryButtonDisabled)
        .disabled(vm.isPrimaryButtonDisabled)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}

#Preview {
    let networkService = NetworkService()
    let imageCache = InMemoryImageCache()
    let bannerRepo = BannerRepository(bannerDataSource: BannerDataSource(networkService: networkService))
    
    BannerDetailView(
        vm: BannerDetailViewModel(
            viewType: .edit,
            banner: .mockActiveData,
            postBannerUseCase: PostBannerUseCase(bannerRepository: bannerRepo),
            putBannerUseCase: PutBannerUseCase(bannerRepository: bannerRepo),
            deleteBannerUseCase: DeleteBannerUseCase(bannerRepository: bannerRepo),
            imageCache: imageCache
        )
    )
}

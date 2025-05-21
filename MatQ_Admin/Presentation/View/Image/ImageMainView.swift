//
//  ImageMainView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 1/13/25.
//

import SwiftUI

struct ImageMainView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm: ImageMainViewModel
    @Environment(\.dismiss) var dismiss // TODO: 시트 따로 관리하도록 수정
    
    private let gridCount = 3
    private var gridItems: [GridItem] { Array(repeating: GridItem(spacing: 0), count: gridCount) }
    private let contentSpacing: CGFloat = 12
    private let contentInnerSpacing: CGFloat = 8
    private let outerSpacing: CGFloat = 20
    private var totalSpacing: CGFloat { contentSpacing * CGFloat(gridCount - 1) + outerSpacing * 2 + contentInnerSpacing * CGFloat(2 * gridCount) }
    private var totalWidth: CGFloat { UIImageSize.maxWidth.value - totalSpacing }
    private var imageSize: CGFloat { totalWidth / CGFloat(gridCount) }  // 각 이미지 크기
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "이미지", isNotRoot: false)
                .zIndex(3)
            
            switch vm.viewState {
            case .empty:
                listEmptyView
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                imageListView
            }
        }
        .safeAreaInset(edge: .bottom) {
            if vm.viewType == .fetchingList {
                Button {
                    router.push(.ImageDetailView(type: .publish, imageItem: ImageMainViewModelItem()))
                } label: {
                    Text("이미지 등록")
                }
                .ilsangButtonStyle(type: .primary)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .background(.bgSecondary)
        .alert(isPresented: $vm.showAlert) {
            Alert(title: Text("Error"), message: Text(vm.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var listEmptyView: some View {
        VStack {
            Text("불러올 이미지가 없어요!")
                .font(.callout)
                .foregroundStyle(.textSecondary)
            Button {
                vm.loadImages()
            } label: {
                Text("재시도")
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var imageListView: some View {
        return ScrollView {
            LazyVGrid(columns: gridItems, spacing: contentSpacing) {
                ForEach(vm.imageList, id: \.imageId) { item in
                    Button {
                        switch vm.viewType {
                        case .fetchingList:
                            router.push(.ImageDetailView(type: .edit, imageItem: item))
                        case .selectingItem:
                            vm.selectImage(imageId: item.imageId)
                            dismiss()
                        }
                    } label: {
                        imageListItemView(item)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 60)
        }
        .padding(.horizontal, outerSpacing)
        .refreshable {
            if vm.viewType == .fetchingList {
                vm.loadImages()
            }
        }
    }
    
    private func imageListItemView(_ item: ImageMainViewModelItem) -> some View {
        VStack(alignment: .center, spacing: 8) {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .clipped()
            }
            Text(item.imageId.forceCharWrapping)
                .font(.caption).bold()
                .foregroundStyle(.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.leading, 2)
        }
        .padding(contentInnerSpacing)
        .frame(width: imageSize + contentInnerSpacing * 2)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.componentSecondary)
                .shadow(color: .gray300.opacity(0.2), radius: 10)
        )
    }
}

#Preview {
    ImageMainView(
        vm: ImageMainViewModel(
            fetchImagesUseCase: FetchImagesUseCase(
                imageRepository: ImageRepository(
                    imageDataSource: ImageDataSource(
                        cache: InMemoryImageCache(),
                        networkService: NetworkService()
                    )
                )
            ), type: .fetchingList
        )
    )
}

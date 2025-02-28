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
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "이미지", isNotRoot: false)
                .zIndex(3)
            
            switch vm.viewState {
            case .empty:
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
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                questListView
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                router.push(.ImageDetailView(type: .publish, imageItem: ImageMainViewModelItem()))
            } label: {
                Text("이미지 등록")
            }
            .ilsangButtonStyle(type: .primary)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(.bgSecondary)
        .onAppear(perform: {
            vm.loadImages()
        })
        .alert(isPresented: $vm.showAlert) {
            Alert(title: Text("Error"), message: Text(vm.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
  
    
    private var questListView: some View {
        let gridCount = 3
        let gridItems = Array(repeating: GridItem(spacing: 0), count: gridCount)
        let contentSpacing: CGFloat = 8
        let contentInnerSpacing: CGFloat = 8
        let outerSpacing: CGFloat = 20
        let totalSpacing = contentSpacing * CGFloat(gridCount - 1) + outerSpacing * 2 + contentInnerSpacing * CGFloat(2 * gridCount)
        let totalWidth = UIImageSize.maxWidth.value - totalSpacing
       
        let imageSize = totalWidth / CGFloat(gridCount)  // 각 이미지 크기
        
        return ScrollView {
            LazyVGrid(columns: gridItems, spacing: contentSpacing) {
                ForEach(vm.imageList, id: \.imageId) { item in
                    Button {
                        router.push(.ImageDetailView(type: .edit, imageItem: item))
                    } label: {
                        VStack(alignment: .center, spacing: 8) {
                            Group {
                                if let image = item.image {
                                    Image(uiImage: image)
                                        .resizable()
                                } else {
                                    Rectangle()
                                        .fill(Color.gray200)
                                }
                            }
                            .scaledToFit()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                            
                            Text(item.imageId?.forceCharWrapping ?? "")
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
                                .shadow(color: .gray300.opacity(0.3), radius: 12)
                        )
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 60)
        }
        .padding(.horizontal, outerSpacing)
        .refreshable {
            vm.loadImages()
        }
    }
}

#Preview {
    ImageMainView(
        vm: ImageMainViewModel(
            fetchImagesUseCase: FetchCachedImagesUseCase(
                imageRepository: ImageRepository(
                    imageDataSource: ImageDataSource(
                        cache: InMemoryImageCache(),
                        networkService: NetworkService()
                    )
                )
            )
        )
    )
}


extension String{
    var forceCharWrapping: Self {
          self.map({ String($0) }).joined(separator: "\u{200B}") /// 200B: 가로폭 없는 공백문자
      }
}

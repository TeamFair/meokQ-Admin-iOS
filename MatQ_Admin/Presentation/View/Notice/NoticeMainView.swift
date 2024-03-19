//
//  NoticeMainView.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticeMainView: View {
    
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm: NoticeMainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "공지사항", isNotRoot: false)
            
            HStack {
                ForEach(NoticeTargetType.allCases, id: \.self) { notice in
                    targetType(type: notice)
                }
            }
            .padding(.top, 8)
            .background(.bg)
            
            switch vm.viewState {
            case .empty:
                Text("공지한 내용이 없어요!")
                    .font(.callout)
                    .foregroundStyle(.textSecondary)
                    .frame(maxHeight: .infinity)
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
            case .loaded:
                noticeListView
            }
            
            switch vm.viewState {
            case .empty, .loaded:
                Button {
                    router.push(.NoticePostView)
                } label: {
                    ButtonLabelComponent(title: "작성하기", type: .primary)
                }
                .padding(20)

            case .loading:
                EmptyView()
            }
        }
        .background(.bg/*Color.gray.opacity(0.05)*/)
        .task {
            print("NOTICEMAIN TASK")
            await vm.getNoticeList(target: vm.selectedType, page: 0)
        }
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var noticeListView: some View {
        ScrollView {
            ForEach(vm.items, id: \.noticeId) { item in
                Button {
                    router.push(.NoticeDetailView(notice: item))
                } label: {
                    NoticeComponent(noticeName: item.title, timeStamp: item.createDate ?? "23.12.31")
                }
            }
            .padding(.vertical, 10)
        }
        .refreshable {
            await vm.getNoticeList(target: vm.selectedType, page: 0)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    private func targetType(type: NoticeTargetType) -> some View {
        let isSelected = vm.selectedType == type
        return Button {
            Task {
                vm.selectedType = type
                await vm.getNoticeList(target: vm.selectedType, page: 0)
            }
        } label: {
            VStack {
                Text(type.rawValue)
                    .font(isSelected ? .callout : .subheadline)
                    .bold()
                Spacer()
                Rectangle()
                    .frame(height: 3)
                    .foregroundStyle(isSelected ? .main : .clear)
                    .padding(.horizontal, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 30)
        .foregroundStyle(isSelected ? .textPrimary : .textSecondary)
    }
}

#Preview {
    NoticeMainView(vm: .init(noticeUseCase: GetNoticeUseCase(noticeRepository: NoticeRepository(noticeService: NoticeService()))))
}

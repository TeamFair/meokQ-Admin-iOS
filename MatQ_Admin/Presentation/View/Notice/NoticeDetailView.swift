//
//  NoticeDetailView.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticeDetailView: View {
    
    @EnvironmentObject var router: NavigationStackCoordinator
    @ObservedObject var vm: NoticeDetailViewModel

    var body: some View {
        VStack {
            NavigationBarComponent(navigationTitle: "공지사항", isNotRoot: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.notice.title)
                    .font(.title3)
                
                Text("\(vm.notice.target) • \(vm.notice.createDate ?? "23.12.31")")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 12)

                Text(vm.notice.content)
                    .font(.body)
                    .lineLimit(0)
                
                Spacer()
                
                Button {
                    vm.showingDeleteAlert.toggle()
                } label: {
                    ButtonLabelComponent(title: "공지 삭제하기", type: .delete)
                }
                .background(Color.red)
                .cornerRadius(10)
            }
            .padding(20)
        }
        .alert("공지 삭제", isPresented: $vm.showingDeleteAlert) {
            Button("삭제", role: .destructive) {
                Task { await vm.deleteNotice() }
            }
            Button("취소", role: .cancel) {
                vm.showingDeleteAlert.toggle()
            }
        } message: {
            Text("공지를 삭제하시겠습니까?")
        }
        .alert("공지 삭제 에러", isPresented: $vm.showingErrorAlert) {
            Button("삭제", role: .none) {
                vm.showingErrorAlert.toggle()
            }
        } message: {
            Text(vm.feedbackMessage)
        }
        .alert("공지 삭제 성공", isPresented: $vm.showingSuccessAlert) {
            Button("확인", role: .none) {
                router.pop()
            }
        } message: {
            Text(vm.feedbackMessage)
        }
    }
}

#Preview {
    NoticeDetailView(vm: NoticeDetailViewModel(noticeUseCase: DeleteNoticeUseCase(noticeRepository: NoticeRepository(noticeService: NoticeService())), notice: Notice.init(getNotice: .init(noticeId: "", title: "Title", content: "Content", createDate: "23.12.31", target: "ALL"))))
}

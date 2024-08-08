//
//  NoticePostView.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticePostView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @ObservedObject var vm: NoticePostViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBarComponent(navigationTitle: "공지사항", isNotRoot: true)
            
            ScrollView {
                Form {
                    VStack(alignment: .leading, spacing: 20) {
                        targetView
                        
                        writeTitleView
                        
                        writeContentView
                    }
                }
                .formStyle(.columns)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .tint(.primaryPurple)

            Spacer()
            
            Button {
                Task {
                    await vm.postNotice()
                }
            } label: {
                Text("공지 등록하기")
                    
//                IS_ButonView(title: "공지 등록하기", type: vm.buttonAble ? .primary : .secondary)
                    .padding(20)
            }
            .ilsangButtonStyle(type: .primary)
            .disabled(!vm.buttonAble)
        }
        .onTapGesture {
            self.textEditEnding()
        }
        .alert(isPresented: $vm.showingErrorAlert) {
            Alert(title: Text("공지 작성 에러"),
                  message: Text(vm.feedbackMessage),
                  dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $vm.showingSuccessAlert) {
            Alert(title: Text("공지 작성 성공"),
                  message: Text(vm.feedbackMessage),
                  dismissButton: .default(Text("OK"), action: {
                router.pop()
            }))
        }
    }
    
    private var targetView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("공지할 대상")
                .font(.headline)
            
            Picker("", selection: $vm.target) {
                Text("All").tag(NoticeTargetType.ALL)
                Text("CUSTOMER").tag(NoticeTargetType.CUSTOMER)
                Text("BOSS").tag(NoticeTargetType.BOSS)
                Text("ADMIN").tag(NoticeTargetType.ADMIN)
            }
            .labelsHidden()
            .pickerStyle(MenuPickerStyle())
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.grayF4)
            )
        }
    }
    
    private var writeTitleView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("공지 제목")
                .font(.headline)
            
            TextField("공지 제목을 입력해주세요", text: $vm.title, axis: .vertical)
                .padding()
                .frame(minHeight: 50)
                .font(.body)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.grayF4)
                )
        }
    }
    
    private var writeContentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("공지 내용")
                .font(.headline)
            
            TextField("공지 내용을 입력해주세요", text: $vm.content, axis: .vertical)
                .padding()
                .frame(minHeight: 200, alignment: .topLeading)
                .font(.body)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.grayF4)
                )
                .keyboardType(.default)
        }
    }
}

#Preview {
    NoticePostView(vm: NoticePostViewModel(noticeUseCase: PostNoticeUseCase(noticeRepository: NoticeRepository(noticeService: NoticeService()))))
}

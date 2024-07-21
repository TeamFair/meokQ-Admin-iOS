//
//  QuestDetailView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI
import Combine

struct QuestDetailView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm : QuestDetailViewModel
    
    let input: PassthroughSubject<QuestDetailViewModel.Input, Never> = .init()
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationBarComponent(navigationTitle: vm.viewType.title, isNotRoot: true)
                .overlay(alignment: .trailing) {
                    Button {
                        self.input.send(.deleteData(vm.editedItems.questId))
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.primaryPurple)
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
                    ImageFieldComponent(titleName: "퀘스트 이미지", uiImage: $vm.editedItems.questImage)
                }
                .padding(.horizontal, 20)
            }
            
            Button {
                // TODO: 퀘스트 수정 API 연결
                self.input.send(.createData(vm.editedItems))
            } label: {
                Text(vm.viewType.buttonTitle)
            }
            .ilsangButtonStyle(type: .primary)
            .opacity(vm.viewType == .edit ? 1 : 0)

            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .task {
            self.bind()
        }
        .alert(isPresented: $vm.showAlert) {
            Alert(
                title: Text(vm.alertTitle),
                message: Text(vm.errorMessage),
                dismissButton: .default(Text("확인")) {
                    if vm.alertTitle == "퀘스트 추가 성공" || vm.alertTitle == "퀘스트 삭제 성공" {
                        print("HEREE")
                        self.input.send(.dismiss)
                    }
                }
            )
        }
    }
    
    func bind() {
        let output = vm.transform(input: input.eraseToAnyPublisher())
        
        output.sink { event in
            switch event {
            case .createSuccess(let message):
                vm.alertTitle = "퀘스트 추가 성공"
                vm.errorMessage = message
                vm.showAlert = true
            case .createFail(let error):
                vm.alertTitle = "퀘스트 추가 실패"
                vm.errorMessage = error.localizedDescription
                vm.showAlert = true
            case .deleteSuccess(let message):
                vm.alertTitle = "퀘스트 삭제 성공"
                vm.errorMessage = message
                vm.showAlert = true
            case .deleteFail(let error):
                vm.alertTitle = "퀘스트 삭제 실패"
                vm.errorMessage = error.localizedDescription
                vm.showAlert = true
            case .dismiss:
                router.pop()
            }
        }
        .store(in: &vm.subscriptions)
    }
}

//#Preview {
//    QuestDetailView(vm: QuestDetailViewModel(viewType: .edit, questDetail: .initialData))
//}

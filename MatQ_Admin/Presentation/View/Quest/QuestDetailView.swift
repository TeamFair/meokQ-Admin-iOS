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
            navigationBar
            
            ScrollView {
                contentView
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .alert(isPresented: $vm.showAlert, content: alertView)
        .safeAreaInset(edge: .bottom, content: bottomButton)
    }
   
    private var navigationBar: some View {
        NavigationBarComponent(navigationTitle: vm.viewType.title, isNotRoot: true)
            .overlay(alignment: .trailing) { navigationTrailingButtons }
    }
    
    private var navigationTrailingButtons: some View {
        HStack(spacing: 20) {
            Button {
                vm.onDeleteButtonTap(type: .soft)
            } label: {
                Image(systemName: "eraser")
                    .foregroundStyle(.primaryPurple)
            }
            Button {
                vm.onDeleteButtonTap(type: .hard)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.primaryPurple)
            }
        }
        .opacity(vm.viewType == .edit ? 1 : 0)
        .padding(.trailing, 20)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 32) {
            imageInputView // 작성자 이미지, 메인 이미지
            
            InputFieldComponent(
                titleName: "미션 제목",
                inputField: TextFieldComponent(
                    placeholder: vm.items.missionTitle,
                    content: $vm.editedItems.missionTitle,
                    showContentSize: true
                )
            )
            
            InputFieldComponent(
                titleName: "작성자",
                inputField: TextFieldComponent(
                    placeholder: vm.items.writer,
                    content: $vm.editedItems.writer
                )
            )
            
            HStack {
                InputFieldComponent(
                    titleName: "타입",
                    inputField:
                        SegmentComponent(
                            content: $vm.editedItems.questType,
                            list: QuestType.allCases
                        )
                )
                
                if vm.editedItems.questType == .repeat {
                    InputFieldComponent(
                        titleName: "반복주기",
                        inputField:
                            SegmentComponent(
                                content: $vm.editedItems.questTarget,
                                list: QuestRepeatTarget.allCases
                            )
                    )
                }
            }
            
            InputFieldComponent(
                titleName: "만료 기한",
                inputField: TextFieldComponent(
                    placeholder: vm.items.expireDate,
                    content: $vm.editedItems.expireDate
                )
            )
            
            InputFieldComponent(
                titleName: "우선순위",
                inputField: TextFieldComponent(
                    placeholder: String(vm.items.score),
                    content: $vm.editedItems.score.toString()
                )
            )
            
            ToggleComponent(titleName: "인기퀘스트", isOn: $vm.editedItems.popularYn)
                .padding(.leading, 4)
            
            InputFieldComponent(
                titleName: "스탯",
                inputField: statsView
            )
            
            quizSection
        }
    }
    
    private var quizSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            InputFieldComponent(
                titleName: "인증 방법",
                inputField:
                    SegmentComponent(
                        content: $vm.editedItems.missionType,
                        list: MissionType.allCases
                    )
            )
            
            quizzesView
            
            Button {
                withAnimation {
                    vm.editedItems.quizzes.append(.init(question: "", hint: "", answers: [.init(content: "")]))
                }
            } label: {
                Text("퀴즈 추가")
                    .foregroundStyle(.primaryPurple)
                    .padding(8)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, -8)
        }
    }
    
    private var imageInputView: some View {
        HStack {
            PhotosPicker(selection: $vm.photosPickerItemForWriterImage, matching: .any(of: [.images, .screenshots])) {
                ImageFieldComponent(titleName: "작성자 이미지", uiImage: vm.editedItems.writerImage)
            }
            
            PhotosPicker(selection: $vm.photosPickerItemForMainImage, matching: .any(of: [.images, .screenshots])) {
                ImageFieldComponent(titleName: "메인 이미지", uiImage: vm.editedItems.mainImage)
            }
        }
    }
    
    private var statsView: some View {
        VStack {
            let sliders = [
                ("체력", vm.items.strengthXP, $vm.editedItems.strengthXP),
                ("지능", vm.items.intellectXP, $vm.editedItems.intellectXP),
                ("재미", vm.items.funXP, $vm.editedItems.funXP),
                ("매력", vm.items.charmXP, $vm.editedItems.charmXP),
                ("사회성", vm.items.sociabilityXP, $vm.editedItems.sociabilityXP)
            ]
            
            ForEach(sliders, id: \.0) { title, placeholder, binding in
                SliderComponent(
                    titleName: title,
                    contentPlaceholder: placeholder,
                    content: binding.toDouble()
                )
            }
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.componentPrimary)
        )
    }
    
    @ViewBuilder
    private var quizzesView: some View {
        if vm.editedItems.missionType == .OX || vm.editedItems.missionType == .WORDS {
            VStack(spacing: 28) {
                ForEach(vm.editedItems.quizzes.indices, id: \.self) { idx in
                    quizView(idx: idx)
                }
            }
        }
    }
   
    private func quizView(idx: Int) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("\(idx+1)번째 퀴즈")
                    .font(.headline).bold()
                    .foregroundStyle(.textSecondary)
                Spacer()
                Button {
                    withAnimation {
                        vm.removeQuiz(at: idx)
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.textSecondary.opacity(0.5))
                        .padding(12)
                }
                .padding(.trailing, -12)
            }
            
            InputFieldComponent(
                titleName: "질문",
                inputField: TextFieldComponent(
                    placeholder: "퀴즈 질문을 입력해 주세요",
                    content: $vm.editedItems.quizzes[idx].question
                )
            )
            .padding(.top, -12)
            
            InputFieldComponent(
                titleName: "힌트",
                inputField: TextFieldComponent(
                    placeholder: "힌트를 입력해 주세요",
                    content:$vm.editedItems.quizzes[idx].hint
                )
            )
            
            if vm.editedItems.missionType == .WORDS {
                InputFieldComponent(
                    titleName: "답",
                    inputField:
                        quizWorkAnswerView(idx: idx)
                )
            } else if vm.editedItems.missionType == .OX {
                InputFieldComponent(
                    titleName: "답",
                    inputField:
                        Picker("", selection: $vm.editedItems.quizzes[idx].answers.first?.content ?? .constant("O")) {
                            ForEach(["O", "X"], id: \.self) { item in
                                Text(item)
                            }
                        }
                        .pickerStyle(.segmented)
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.componentPrimary.opacity(0.4)))
        )
    }
    
    private func quizWorkAnswerView(idx: Int) -> some View {
        VStack {
            ForEach(vm.editedItems.quizzes[idx].answers.indices, id: \.self) { answerIdx in
                HStack {
                    TextFieldComponent(
                        placeholder: "답을 입력해 주세요",
                        content: $vm.editedItems.quizzes[idx].answers[answerIdx].content
                    )
                    .overlay(alignment: .trailing) {
                        if !vm.editedItems.quizzes[idx].answers[answerIdx].content.isEmpty {
                            Button {
                                vm.initQuizAnswerContent(at: idx, answerIdx: answerIdx)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.textSecondary.opacity(0.3))
                                    .padding(12)
                            }
                        }
                    }
                    
                    if answerIdx >= 1 {
                        Button {
                            withAnimation {
                                vm.removeQuizAnswer(at: idx, answerIdx: answerIdx)
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.textSecondary.opacity(0.3))
                                .padding(8)
                        }
                    }
                }
                .animation(.default, value: vm.editedItems.quizzes[idx])
            }
            Button {
                withAnimation {
                    vm.editedItems.quizzes[idx].answers.append(.init(content: ""))
                }
            } label: {
                Label("답 추가", systemImage: "plus")
                    .font(.subheadline)
                    .foregroundStyle(.primaryPurple)
                    .padding(12)
            }
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
    
    private func alertView() -> Alert {
        switch vm.activeAlertType {
        case .delete:
            return Alert(title: Text("퀘스트를 삭제하시겠습니까?"), message: Text("퀘스트를 복구할 수 없습니다."), primaryButton: .cancel(Text("취소")), secondaryButton: .destructive(Text("삭제")) { vm.deleteData(questId: vm.editedItems.questId, type: vm.selectedDeleteType) })
        case .result:
            return Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage), dismissButton: .default(Text("확인")) { if vm.alertTitle == "퀘스트 추가 성공" || vm.alertTitle == "퀘스트 삭제 성공" { router.pop() } })
        case .none:
            return Alert(title: Text(""))
        }
    }
}

#Preview {
    let networkService = NetworkService()
    let imageRepository = ImageRepository(imageDataSource:  ImageDataSource(cache: InMemoryImageCache(), networkService: networkService))
    let questRepo = QuestRepository(questDataSource: QuestDataSource(networkService: networkService))
    
    QuestDetailView(
        vm: QuestDetailViewModel(viewType: .publish, questDetail: .mockOXData, postQuestUseCase: PostQuestUseCase(questRepository: questRepo, imageRepository: imageRepository), putQuestUseCase: PutQuestUseCase(questRepository: questRepo, imageRepository: imageRepository), deleteQuestUseCase: DeleteQuestUseCase(questRepository: questRepo))
    )
}

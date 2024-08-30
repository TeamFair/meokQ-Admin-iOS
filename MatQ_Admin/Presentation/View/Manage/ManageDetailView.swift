//
//  ManageDetailView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/19/24.
//

import SwiftUI

struct ManageDetailView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @StateObject var vm : ManageDetailViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBarComponent(navigationTitle: "신고된 챌린지 관리", isNotRoot: true)
            
            Spacer().frame(height: 16)
            
            VStack(alignment: .leading, spacing: 16) {
                Image(uiImage: vm.item.image ?? .testimage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIImageSize.maxWidth.value, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .gray200.opacity(0.2), radius: 8)
                    .background(alignment: .bottom, content: {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.componentPrimary)
                            .scaleEffect(0.9)
                            .offset(y: 32)
                    })
                    .padding(.bottom, 12)
                
                HStack(spacing: 12) {
                    Text(vm.item.questTitle)
                        .font(.title2).bold()
                        .foregroundStyle(.textPrimary)
                    
                    Text("\(vm.item.quantity)XP")
                        .font(.headline)
                        .foregroundStyle(.primaryPurple)
                }
                
                textView(title: "작성자", content: "\(vm.item.userNickname)")
                textView(title: "업로드 날짜", content: "\(vm.item.createdAt)")
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    vm.activeAlertType = .recovery
                    vm.showAlert = true
                } label: {
                    Text("철회")
                }
                .ilsangButtonStyle(type: .secondary)
                Button {
                    vm.activeAlertType = .delete
                    vm.showAlert = true
                } label: {
                    Text("삭제")
                }
                .ilsangButtonStyle(type: .primary)
            }
            .padding([.horizontal, .bottom], 20)
        }
        .alert(isPresented: $vm.showAlert) {
            switch vm.activeAlertType {
            case .delete:
                Alert(
                    title: Text("챌린지를 삭제하시겠습니까?"),
                    message: Text("삭제한 챌린지는 복구할 수 없으며 미완료 상태로 변경됩니다."),
                    primaryButton: .cancel(Text("취소")),
                    secondaryButton: .destructive(Text("삭제")) {
                        vm.deleteChallenge(item: vm.item)
                    }
                )
            case .recovery:
                Alert(
                    title: Text("챌린지 신고를 철회하시겠습니까?"),
                    message: Text("챌린지는 완료 상태로 복구됩니다."),
                    primaryButton: .cancel(Text("취소")),
                    secondaryButton: .destructive(Text("신고 철회")) {
                        vm.recoveryChallenge(challengeId: vm.item.challengeId)
                    }
                )
            case .result:
                Alert(
                    title: Text(vm.alertTitle),
                    message: Text(vm.alertMessage),
                    dismissButton: .default(Text("확인")) {
                        if vm.alertTitle == "챌린지 신고 철회 성공" || vm.alertTitle == "챌린지 삭제 성공" {
                            router.pop()
                        }
                    }
                )
            case .none:
                Alert(title: Text(""))
            }
        }
    }
    
    private func textView(title: String, content: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .frame(width: 80, alignment: .leading)
                .foregroundStyle(.textSecondary)
            
            Text(content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
                .foregroundStyle(.textSecondary)
        }
    }
}

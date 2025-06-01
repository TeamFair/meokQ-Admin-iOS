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
            NavigationBarComponent(navigationTitle: "신고된 도전 내역 관리", isNotRoot: true)
            
            Spacer().frame(height: 16)
            
            VStack(alignment: .leading, spacing: 16) {
                Image(uiImage: vm.item.image ?? .testimage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIImageSize.maxWidth.value-40, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .gray200.opacity(0.2), radius: 8)
                    .background(alignment: .bottom, content: {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.componentPrimary)
                            .scaleEffect(0.9)
                            .offset(y: 32)
                    })
                    .padding(.bottom, 12)
                
                Text(vm.item.questTitle)
                    .font(.title2).bold()
                    .foregroundStyle(.textPrimary)
                
                textView(title: "작성자", content: "\(vm.item.userNickname)")
                textView(title: "업로드 날짜", content: "\(vm.item.createdAt)")
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    vm.onRecoveryButtonTap()
                } label: {
                    Text("철회")
                }
                .ilsangButtonStyle(type: .tertiary)
                Button {
                    vm.onDeleteButtonTap()
                } label: {
                    Text("삭제")
                }
                .ilsangButtonStyle(type: .primary)
            }
            .padding([.horizontal, .bottom], 20)
        }
        .alertItem(vm.alertItem, isPresented: $vm.showAlert)
        .onChange(of: vm.shouldPop) { _, shouldPop in
            if shouldPop {
                router.pop()
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

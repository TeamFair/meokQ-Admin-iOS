//
//  NoticeDetailView.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticeDetailView: View {
    
    @EnvironmentObject var router: NavigationStackCoordinator
    
    var body: some View {
        VStack {
            NavigationBarComponent(navigationTitle: "공지사항", isNotRoot: true)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("공지사항 타이틀")
                    .font(.title3)
                Text("2024.01.01")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .padding(.bottom, 12)
                
                Text("내용")
                    .font(.body)
                    .lineLimit(0)
                
                Spacer()
                
                Button {
                    router.pop()
                } label: {
                    ButtonLabelComponent(title: "공지 삭제하기", type: .delete)
                }
                .background(Color.red)
                .cornerRadius(10)
            }
            .padding(20)
        }
        
    }
}

#Preview {
    NoticeDetailView()
}

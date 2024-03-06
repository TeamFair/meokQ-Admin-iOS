//
//  NoticeMainView.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticeMainView: View {
    
    @EnvironmentObject var router: NavigationStackCoordinator
    
    let items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationBarComponent(navigationTitle: "공지사항", isNotRoot: false)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(items, id: \.self) { item in
                            Button {
                                router.push(.NoticeDetailView)
                            } label: {
                                NoticeComponent(noticeName: item, timeStamp: item)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    router.push(.NoticePostView)
                } label: {
                    ButtonLabelComponent(title: "작성하기", type: .primary)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(Color.gray.opacity(0.05))
    }
}

#Preview {
    NoticeMainView()
}

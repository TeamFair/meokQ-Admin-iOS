//
//  NoticePostView.swift
//  MatQ_Admin
//
//  Created by 077tech on 1/1/24.
//

import SwiftUI

struct NoticePostView: View {
    
    @State private var selectedTarget = "CUSTOMER"
    @State private var inputValue: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationBarComponent(navigationTitle: "공지사항", isNotRoot: true)
            
            VStack(alignment: .leading) {
                Text("공지할 대상")
                    .font(.system(size: 19))
                    .bold()
                
                Picker("대상 선택", selection: $selectedTarget) {
                    Text("CUSTOMER").tag("CUSTOMER")
                    Text("BOSS").tag("BOSS")
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.bottom)
                
                Text("공지사항 작성")
                    .font(.system(size: 19))
                    .bold()
                    .padding(.bottom)
                
                TextEditor(text: $inputValue)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                
                Spacer()
                
                Button {
                    print("공지 등록하기")
                } label: {
                    ButtonLabelComponent(title: "공지 등록하기", type: .primary)
                }
                .background(Color.yellow)
                .cornerRadius(10)
            }
            .padding(20)
        }
    }
}

#Preview {
    NoticePostView()
}

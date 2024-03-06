//
//  PopupView.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct PopupView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    
    let contentTitle: String
    let content: String
    var action: (() -> Void?)? = nil
    
    var body: some View {
        VStack {
            Text(contentTitle)
                .bold()
            Text(content)
            
            HStack(alignment: .center){
                Button {
                    router.pop()
                } label: {
                    Text("취소")
                        .padding(.horizontal,51)
                        .padding(.vertical, 9)
                        .foregroundColor(.black)
                }
                .background(Color.gray)
                .cornerRadius(10)
                
                Button {
                    action?()
                } label: {
                    Text("확인")
                        .padding(.horizontal,51)
                        .padding(.vertical, 9)
                        .foregroundColor(.black)
                }
                .background(Color.yellow)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .opacity(0.2)
    }
}

#Preview {
    PopupView(contentTitle: "testTitle", content: "test")
}

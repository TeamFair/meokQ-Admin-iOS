//
//  BusinessRegistrationView.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct BusinessRegistrationView: View {
        
    let license: License
    
    var body: some View {
        
        NavigationBarComponent(navigationTitle: "영업신고증", isNotRoot: true)
        
        ScrollView {
            VStack(alignment: .leading){
                Text("영업신고증")
                    .font(.title3.bold())

                InfoComponent(titleName: "영업신고증 고유번호", contentName: license.licenseId)
                InfoComponent(titleName: "영업의 종류", contentName: license.licenseId) // TODO: 백 수정시 변경
                InfoComponent(titleName: "대표자", contentName: license.ownerName)
                InfoComponent(titleName: "영업소 명칭 (상호명)", contentName: license.marketName)
                InfoComponent(titleName: "소재지", contentName: license.address)
                InfoComponent(titleName: "우편번호", contentName: license.postalCode)
                InfoComponent(titleName: "영업신고증 이미지", imageName: license.licenseImage.imageId)

            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//    BusinessRegistrationView()
//}

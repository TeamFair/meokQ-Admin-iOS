//
//  IdentificationView.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct IdentificationView: View {
    
    private let contentTitle = ["성함", "생년월일", "신분증 이미지"]
    let operatorData: Operator
    
    var body: some View {
        NavigationBarComponent(navigationTitle: "신분증", isNotRoot: true)
        
        ScrollView{
            VStack(alignment: .leading){
                Text("신분증")
                    .font(.title3.bold())

                InfoComponent(titleName: "성함", contentName: operatorData.name)
                InfoComponent(titleName: "생년월일", contentName: operatorData.birthdate)
                InfoComponent(titleName: "신분증 이미지", imageName: operatorData.idcardImage.imageId)
                Text("주민등록번호 뒤 7자리가 기재된 공간 마스킹 필요\n주민등록번호 뒷자리를 지우지 않은 신분증은 즉시 파기되며 요청 반려")
                    .font(.footnote)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    IdentificationView(operatorData: Operator(name: "name", birthdate: "00.00.00", idcardImage: .init(imageId: "", location: "")))
}

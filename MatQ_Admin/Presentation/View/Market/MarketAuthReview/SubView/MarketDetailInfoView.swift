//
//  MarketInfoView.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct MarketDetailInfoView: View {
    
    let marketDetail: MarketDetail
        
    var body: some View {
        NavigationBarComponent(navigationTitle: "가게정보", isNotRoot: true)
        ScrollView() {
            VStack(alignment: .leading) {
                Text("가게 로고")
                    .font(.title3.bold())
                
                HStack(alignment: .center) {
                    // TODO: 이미지 연결
                    Image(marketDetail.logoImage)
                        .resizable()
                        .frame(width:98, height:98)
                        .cornerRadius(20)
                }
                .frame(maxWidth: .infinity)
                
                Text("가게 정보")
                    .font(.title3.bold())
                
                InfoComponent(titleName: "상호명", contentName: marketDetail.name)
                InfoComponent(titleName: "가게 주소", contentName:marketDetail.address)
                InfoComponent(titleName: "가게 전화번호", contentName: marketDetail.phone)
                
                Text("영업 요일")
                    .font(.title3.bold())
                
                HStack(alignment: .top) {
                    ForEach(요일.allCases, id: \.value) { day in
                        if let time = marketDetail.marketTime?.filter({ $0.weekDay == day.value }).first {
                            dayView(time)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .padding()
        }
    }
    
    private func dayView(_ marketTime: MarketTime) -> some View {
        VStack(alignment: .leading) {
            Text(marketTime.weekDay)
                .bold()
            if marketTime.holidayYn == "N" {
                Text(marketTime.openTime)
                Text(marketTime.closeTime)
            } else {
                Text("휴무")
            }
        }
        .font(.caption)
        .frame(maxWidth: .infinity)
    }
}

enum 요일: CaseIterable {
    case 월
    case 화
    case 수
    case 목
    case 금
    case 토
    case 일
    
    var value: String {
        switch self {
        case .월:
            "MON"
        case .화:
            "TUE"
        case .수:
            "WED"
        case .목:
            "THU"
        case .금:
            "FRI"
        case .토:
            "SAT"
        case .일:
            "SUN"
        }
    }
}

#Preview {
    MarketDetailInfoView(marketDetail: .init(marketId: "id000", logoImage: "", name: "MARKET", district: "111110000", phone: "010-3030-3030", address: "서울틀별시", status: "", marketTime: [.init(weekDay: "월", openTime: "08:00", closeTime: "21:00", holidayYn: "N")]))
}

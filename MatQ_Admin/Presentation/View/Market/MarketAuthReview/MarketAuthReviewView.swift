//
//  MarketDetailView.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct MarketAuthReviewView: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    @ObservedObject var vm : MarketAuthReviewViewModel
        
    var body: some View {
        VStack(spacing: 16) {
            NavigationBarComponent(navigationTitle: vm.items.name, isNotRoot: true)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {
                    infoSectionComponent(.businessRegistration)
                    infoSectionComponent(.identification)
                    infoSectionComponent(.marketDetail)
                    
                    rejectTextFieldArea
                }
                .padding(.horizontal, 20)
            }
            Spacer()
            
            buttonArea
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
        .onTapGesture {
            self.textEditEnding()
        }
        .task {
            await vm.getMarketInfo()
        }
        .alert(isPresented: $vm.showingAlert) {
            Alert(title: Text("Error"), message: Text(vm.feedbackMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private enum Destination {
        case businessRegistration
        case identification
        case marketDetail
        
        var title:String {
            switch self {
            case .businessRegistration:
                "영업신고증"
            case .identification:
                "신분증"
            case .marketDetail:
                "가게정보"
            }
        }
    }
    
    private func infoSectionComponent(_ destination: Destination) -> some View {
        HStack(spacing: 20){
            Text(destination.title)
                .font(.headline)
            
            Button {
                switch destination {
                case .businessRegistration:
                    router.push(.BusinessRegistrationView(license: vm.items.marketAuth.license))
                case .identification:
                    router.push(.IdentificationView(operator: vm.items.marketAuth.operator))
                case .marketDetail:
                    router.push(.MarketDetailInfoView(detail: vm.items.marketDetail))
                }
            } label: {
                HStack(spacing: 3) {
                    Text("확인하기")
                    Image(systemName: "chevron.right")
                }
                .font(.caption2)
                .foregroundColor(.gray)
            }
        }
    }
    
    private var rejectTextFieldArea: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("반려 사유")
                .font(.headline)
            
            TextField("반려 사유를 입력해주세요", text: $vm.comment, axis: .vertical)
                .padding()
                .frame(height: 140, alignment: .topLeading)
                .frame(maxWidth: .infinity)
                .font(.body)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.componentPrimary)
                )
                .tint(.tintYellow)
        }
    }
    
    private var buttonArea: some View {
        HStack(alignment: .center) {
            Button {
                Task {
                    await vm.putMarketReviewAuth(reviewResult: .reject)
                }
            } label: {
                ButtonLabelComponent(title: "반려", type: .secondary)
            }
            
            Button {
                Task {
                    await vm.putMarketReviewAuth(reviewResult: .approve)
                }
            } label: {
                ButtonLabelComponent(title: "승인", type: .primary)
            }
        }
        .font(.headline)
    }
}


//#Preview {
//    MarketAuthReviewView(vm:, marketId:)
//}

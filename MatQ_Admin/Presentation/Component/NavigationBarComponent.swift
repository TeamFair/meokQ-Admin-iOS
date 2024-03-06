//
//  NavigationBar.swift
//  MatQ_Admin
//
//  Created by 077tech on 12/22/23.
//

import SwiftUI

struct NavigationBarComponent: View {
    @EnvironmentObject var router: NavigationStackCoordinator
    
    var navigationTitle : String
    var isNotRoot : Bool
    
    var body: some View {
        ZStack {
            HStack(){
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                .opacity(isNotRoot ? 1 : 0)
                .padding()
                
                Spacer()
            }
            
            Text(navigationTitle)
                .bold()
        }
        .frame(height: 45)
        .background(.white)
    }
}

#Preview {
    NavigationBarComponent(navigationTitle: "Test", isNotRoot: true)
}

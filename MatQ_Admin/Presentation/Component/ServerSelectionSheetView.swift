//
//  ServerSelectionSheetView.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 6/1/25.
//

import SwiftUI

struct ServerSelectionSheetView: View {
    @Binding var isPresented: Bool
    @AppStorage("port") private var port: String = "8880"
    
    private let availablePorts: [String: String] = [
        "PRD": "8881",
        "DEV": "8880"
    ]
    @State private var initialServer: String = ""
    @State private var selectedServer: String = "PRD"
    
    var onConfirm: ((String) -> Void)? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text("서버를 선택해주세요")
                    .font(.title3)
                Text("현재 서버: \(initialServer) (\(port))")
                    .font(.subheadline)
                    .padding(.bottom, 16)
                Picker("서버", selection: $selectedServer) {
                    ForEach(availablePorts.keys.sorted(), id: \.self) { server in
                        Text(server).tag(server)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("서버 설정")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("적용") {
                        if let selectedPort = availablePorts[selectedServer] {
                            port = selectedPort
                            onConfirm?(selectedPort)
                        }
                        isPresented = false
                    }
                    .disabled(availablePorts[selectedServer] == port)
                }
            })
            .onAppear {
                if let matched = availablePorts.first(where: { $0.value == port }) {
                    initialServer = matched.key
                    selectedServer = matched.key
                }
            }
        }
    }
}

#Preview {
    ServerSelectionSheetView(isPresented: .constant(true))
}

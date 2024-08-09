//
//  NetworkConfiguration.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/9/24.
//


import SwiftUI

class NetworkConfiguration {
    static let shared = NetworkConfiguration()
    
    let baseURL: String = "http://43.202.229.190"
    @AppStorage("port") var port: String = "9090"
    
    private init() { }
    
    var completeBaseURL: String {
        return baseURL + ":" + port
    }
}

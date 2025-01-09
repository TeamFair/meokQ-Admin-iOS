//
//  NetworkConfiguration.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 8/9/24.
//


import SwiftUI

class NetworkConfiguration {
    static let shared = NetworkConfiguration()
    
    let baseURL: String = "http://52.79.126.243"
    @AppStorage("port") var port: String = "8880"
    
    private init() { }
    
    var completeBaseURL: String {
        return baseURL + ":" + port
    }
}

//
//  Binding++.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/25.
//

import SwiftUI

extension Binding where Value == Int {
    func toString() -> Binding<String> {
        Binding<String>(
            get: { String(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) ?? 0 }
        )
    }
    
    func toDouble() -> Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}

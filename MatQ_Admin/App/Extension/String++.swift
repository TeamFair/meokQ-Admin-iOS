//
//  String++.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 9/25/24.
//

import Foundation

extension String {
    
    /// 서버에서 보내주는 시간을 "30-12-31" 형식으로 날짜 포맷 변환.
    ///
    /// 서버 응답 예시들: 3125-01-02T00:00:00, 2024-07-04T00:31:57.313048
    func timeAgoSinceDate() -> String {
        let date = self.split(separator: ".")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: String(date[0])) else { return "2030-12-31" }
       
        // 날짜 포맷 설정
        let dateFormat = "yyyy-MM-dd"
        
        // 설정한 포맷으로 변환
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}

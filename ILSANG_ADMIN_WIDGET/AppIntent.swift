//
//  AppIntent.swift
//  ILSANG_ADMIN_WIDGET
//
//  Created by Lee Jinhee on 9/1/24.
//

import WidgetKit
import AppIntents
import SwiftUI

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("일상 관리자 위젯입니다.")
    
    init() { }
    
    init(colorMode: ColorMode) {
        self.colorMode = colorMode
    }
    
    @Parameter(title: "테마 색상 설정", default: ColorMode.blackType)
    var colorMode: ColorMode
    
    func perform() async throws -> some IntentResult {
        try await Task.sleep(for: .seconds(1))
        return .result()
    }
}

enum Status {
    case able
    case disable
    case fail
    case loading
    
    var emoji: String {
        switch self {
        case .able:
            "🍀"
        case .disable:
            "🚨"
        case .fail:
            "⚠️"
        case .loading:
            "🏃🏻‍♂️"
        }
    }
    
    var bgColor: Color {
        switch self {
        case .able:
                .greenBg
        case .disable:
                .redBg
        case .fail:
                .yellow.opacity(0.2)
        case .loading:
                .blue.opacity(0.2)
        }
    }
}

enum ColorMode: String, AppEnum {
    case purpleType, blackType
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Color Type"
    static var caseDisplayRepresentations: [ColorMode : DisplayRepresentation] = [
        .purpleType: "Purple",
        .blackType:"Black",
    ]
    
    var bgColor: Color {
        switch self {
        case .purpleType:
                .primaryPurple
        case .blackType:
                .black
        }
    }
}

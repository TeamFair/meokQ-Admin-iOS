//
//  ILSANG_ADMIN_WIDGET.swift
//  ILSANG_ADMIN_WIDGET
//
//  Created by Lee Jinhee on 9/1/24.
//

import WidgetKit
import SwiftUI

// MARK: - 위젯

struct ILSANG_ADMIN_WIDGET: Widget {
    let kind: String = "ILSANG_ADMIN_WIDGET"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
                .containerBackground(entry.configuration.colorMode.bgColor, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

struct WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("관리할 내역")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundStyle(.white)
                    .opacity(0.9)
                Text("\(entry.count)")
                    .font(.title3).bold()
                    .foregroundStyle(.secondaryGreen)
                    .contentTransition(.numericText(value: Double(entry.count)))
                    .invalidatableContent()
                Spacer()
                Button(intent: ConfigurationAppIntent()) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text(entry.prdServerStatus.emoji)
                        .font(.system(size: 28))
                        .frame(width: 48, height: 48)
                        .background {
                            Circle()
                                .foregroundStyle(entry.prdServerStatus.bgColor)
                        }
                        .contentTransition(.symbolEffect)
                        .invalidatableContent()
                    
                    Text("PRD")
                        .font(.caption).bold()
                        .foregroundStyle(.gray)
                }
                
                VStack(spacing: 6) {
                    Text(entry.devServerStatus.emoji)
                        .font(.system(size: 28))
                        .frame(width: 48, height: 48)
                        .background {
                            Circle()
                                .foregroundStyle(entry.devServerStatus.bgColor)
                        }
                        .contentTransition(.symbolEffect)
                        .invalidatableContent()
                    
                    Text("DEV")
                        .font(.caption).bold()
                        .foregroundStyle(.gray)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.white)
                    .shadow(color: .black.opacity(0.14), radius: 5, x: 0, y: -6)
            )
        }
        .ignoresSafeArea()
    }
}


// MARK: - 프리뷰

extension ConfigurationAppIntent {
    fileprivate static var blackMode: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.colorMode = .blackType
        return intent
    }
    
    fileprivate static var purpleMode: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.colorMode = .purpleType
        return intent
    }
}

#Preview(as: .systemSmall) {
    ILSANG_ADMIN_WIDGET()
} timeline: {
    IlsangTimelineEntry(date: .now, configuration: .blackMode, prdServerStatus: .able, devServerStatus: .able, count: 0)
    IlsangTimelineEntry(date: .now, configuration: .purpleMode, prdServerStatus: .able, devServerStatus: .able, count: 0)
}

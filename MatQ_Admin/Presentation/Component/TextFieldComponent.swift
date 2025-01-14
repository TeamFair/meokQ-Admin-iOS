//
//  TextFieldComponent.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct TextFieldComponent: View {
    let titleName : String
    let contentPlaceholder : String?
    @Binding var content : String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline).bold()
                .foregroundStyle(.textSecondary)
            if let contentPlaceholder = contentPlaceholder {
                TextField("\(contentPlaceholder)", text: $content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
                    .foregroundStyle(.textPrimary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.componentPrimary)
                    )
            }
        }
    }
}


struct SegmentComponent<T: Identifiable & Hashable & StringValue & Equatable>: View {
    let title : String
    @Binding var content : T
    let list: [T]
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.subheadline).bold()
                .foregroundStyle(.textSecondary)
            Picker("", selection: $content) {
                ForEach(list, id: \.self) { item in
                    Text(item.title)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct SliderComponent: View {
    let titleName: String
    let contentPlaceholder: Int
    @Binding var content: Double
    
    var body: some View {
        HStack(spacing: 2) {
            Text(titleName)
                .font(.subheadline)
                .frame(width: 40)
            Text("\(Int(content))")
                .frame(width: 32)
            Slider(value: $content, in: 0...100, step: 5)
                .frame(maxWidth: .infinity)
        }
        .foregroundStyle(.textPrimary)
        .tint(.primaryPurple)
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}

struct ToggleComponent: View {
    let titleName: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(titleName)
                .font(.subheadline)
                .bold()
                .foregroundStyle(.textSecondary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .tint(.primaryPurple)
        .padding(.vertical, 4)
    }
}

struct ImageFieldComponent: View {
    let titleName : String
    let uiImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline).bold()
                .multilineTextAlignment(.leading)
                .foregroundStyle(.textSecondary)
            Group {
                if let image = uiImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.regularMaterial)
                }
            }
            .frame(width: UIImageSize.medium.value, height: UIImageSize.medium.value)
            .cornerRadius(12)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
    }
}

#Preview {
    VStack {
        TextFieldComponent(titleName: "TextField", contentPlaceholder: "Placeholder", content: .constant("Test"))
        ImageFieldComponent(titleName: "ImageField", uiImage: (.testimage))
        SliderComponent(titleName: "SliderField", contentPlaceholder: 10, content: .constant(0))
        SegmentComponent(title: "SegmentField", content: .constant(QuestType.normal), list: [QuestType.normal, QuestType.repeat])
        ToggleComponent(titleName: "ToggleField", isOn: .constant(true))
    }
}

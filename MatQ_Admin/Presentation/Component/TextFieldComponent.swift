//
//  TextFieldComponent.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 7/6/24.
//

import SwiftUI

struct InputFieldComponent<T: View>: View {
    let titleName: String
    let inputField: T
    
    var body: some View {
        VStack(alignment: .leading){
            Text(titleName)
                .font(.subheadline).bold()
                .foregroundStyle(.textSecondary)
                .padding(.leading, 4)
            
            inputField
        }
    }
}

struct TextFieldComponent: View {
    let placeholder : String?
    @Binding var content : String
    var showContentSize: Bool = false
    
    var body: some View {
        if let placeholder = placeholder {
            TextField("\(placeholder)", text: $content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body)
                .foregroundStyle(.textPrimary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.componentPrimary)
                )
                .overlay(alignment: .topTrailing) {
                    if showContentSize {
                        Text("\(content.count) / 16")
                            .foregroundStyle(content.count > 16 ? .red : .textPrimary)
                            .font(.caption2)
                            .padding(.trailing, 12)
                            .offset(y: -20)
                    }
                }
        }
    }
}

struct SegmentComponent<T: Identifiable & Hashable & StringValue & Equatable>: View {
    @Binding var content : T
    let list: [T]
    
    var body: some View {
        HStack {
            ForEach(list, id: \.self) { item in
                Button {
                    content = item
                } label: {
                    Text(item.title)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(content == item ? .textPrimary : .textSecondary.opacity(0.4))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(content == item ? .componentSecondary : .clear)
                                .shadow(color: .textSecondary.opacity(0.2), radius: 3)
                        )
                }
            }
        }
        .padding(2)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.componentPrimary)
        )
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
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        TextFieldComponent(placeholder: "Placeholder", content: .constant("Test"))
        ImageFieldComponent(titleName: "ImageField", uiImage: (.testimage))
        SliderComponent(titleName: "SliderField", contentPlaceholder: 10, content: .constant(0))
        SegmentComponent(content: .constant(QuestType.normal), list: [QuestType.normal, QuestType.repeat])
        ToggleComponent(titleName: "ToggleField", isOn: .constant(true))
    }
}


//struct SegmentComponent<T: Identifiable & Hashable & StringValue & Equatable>: View {
//    let title : String
//    @Binding var content : T
//    let list: [T]
//
//    var body: some View {
//        VStack(alignment: .leading){
//            Text(title)
//                .font(.subheadline).bold()
//                .foregroundStyle(.textSecondary)
//            Picker("", selection: $content) {
//                ForEach(list, id: \.self) { item in
//                    Text(item.title)
//                }
//            }
//            .pickerStyle(.segmented)
//        }
//    }
//}

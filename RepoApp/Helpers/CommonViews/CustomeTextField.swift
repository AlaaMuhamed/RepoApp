
import Foundation
import SwiftUI

enum ValidationState {
    case none
    case success
    case failure
}

struct CustomTextField: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    @Binding var isLoginText: Bool
    let errorText: String
    let validationState: ValidationState
    let onCommit: ()->()
    let placeholder: String
    let isSecure: Bool

    @State private var isPasswordVisible = false

    init(text: Binding<String>,
         isLoginText: Binding<Bool> = .constant(false),
         errorText: String,
         validationState: ValidationState,
         onCommit: @escaping ()->(),
         placeholder: String,
         isSecure: Bool = false) {
        _text = text
        _isLoginText = isLoginText
        self.errorText = errorText
        self.validationState = validationState
        self.onCommit = onCommit
        self.placeholder = placeholder
        self.isSecure = isSecure
    }

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if isSecure {
                    HStack {
                        if isPasswordVisible {
                            TextField("", text: $text, onEditingChanged: { editing in
                                withAnimation {
                                    isEditing = editing
                                }
                            })
                            .tint(Color.blue)
                        } else {
                            SecureField("", text: $text, onCommit: onCommit)
                                .tint(Color.blue)
                        }

                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(isPasswordVisible ? "hide" : "show")
                        }
                    }
                    .offset(x: 0, y: 5)
                } else {
                    TextField("", text: $text, onEditingChanged: { editing in
                        withAnimation {
                            isEditing = editing
                        }
                    })
                    .tint(Color.blue)
                    .offset(x: 0, y: 5)
                }
            }
            .padding()
            .foregroundColor(.black)
            .font(.system(size: 15, weight: .medium))
            .background(Color(.lightGray))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(borderColor, lineWidth: 1)
            )
            .placeholder(when: true, alignment: .leading) {
                Text(" \(placeholder)")
                    .font(text.isEmpty && !isEditing ?
                        .system(size: 17, weight: .regular) :
                        .system(size: 13, weight: .bold))
                    .padding(.leading, 20)
                    .foregroundColor(.gray)
                    .offset(x: getXOffset(),
                            y: text.isEmpty && !isEditing ? 0 : -15)
                    .scaleEffect(text.isEmpty && !isEditing ? 1 : 0.8)
            }
            .overlay(
                HStack {
                    if validationState == .success, !isSecure {
                        Image("success")
                            .padding(.trailing, 8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 8),
                alignment: .trailing
            )
            .onSubmit(onCommit)

            if validationState == .failure {
                Text(errorText)
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 4)
                        .fill(Color.red)
                    )
            }
        }
    }

    func getXOffset() -> CGFloat {
        if isLoginText, !isSecure {
            return CGFloat(text.isEmpty && !isEditing ? 0 : -20)
        }
        return CGFloat(text.isEmpty && !isEditing ? 0 : -20)
    }

    private var borderColor: Color {
        switch validationState {
        case .none:
            return Color.white
        case .success:
            return Color.green
        case .failure:
            return Color.red
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            self
            placeholder()
                .opacity(shouldShow ? 1 : 0)
                .allowsHitTesting(false)
        }
    }
}


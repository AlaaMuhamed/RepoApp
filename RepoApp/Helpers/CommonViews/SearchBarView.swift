
import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var placeHolder: String = "Search by Repo name ..."

    @State
    private var isEditing = false

    var searchIconEnabled = true

    var cancelHandler: (()->())?

    var backgroundColor: Color = .lightGray
    var placeholderColor: Color = .gray
    var frameHeight: CGFloat = 40

    private enum Constant {
        static let cornerRadius: CGFloat = 7
        static let cancelPadding: CGFloat = 10
    }

    var body: some View {
        HStack {
            HStack {
                if searchIconEnabled {
                    Image("search-icon")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(placeholderColor)
                        .padding(.leading,10)
                }

                TextField("", text: $text, prompt: Text(placeHolder)
                    .font(.system(size: 14))
                    .foregroundColor(placeholderColor))
                    .foregroundColor(placeholderColor)
            }
            .padding(Constant.cornerRadius)
            .cornerRadius(Constant.cornerRadius)
            .frame(height: frameHeight)
            .background(
                backgroundColor
            )
            .clipShape(
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
            )
            .padding(.horizontal, Constant.cancelPadding)
            .contentShape(Rectangle())
            .onTapGesture {
                isEditing = true
            }

            if isEditing {
                Button(action: {
                    isEditing = false
                    text = ""

                }) {
                    Text("Cancel")
                }
                .padding(.trailing, Constant.cancelPadding)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State static var searchText = ""

    static var previews: some View {
        SearchBarView(text: $searchText)
            .previewLayout(.sizeThatFits)
    }
}


import Foundation
import SwiftUI

struct RepoBannerView: View {
    var isProfileAvailable = true
    var name: String
    var date: String
    var ownerName: String
    var ownerAvatar:String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    if isProfileAvailable {
                        AsyncImageView(url: ownerAvatar)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    Text(ownerName)
                        .font(.system(size: 16))
                    Spacer()
                }
                HStack {
                    Image( "calendar-icon")
                    Text(date)
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Repo name:")
                        .fontWeight(.medium)
                    Text(name)
                        .font(.subheadline)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.lightGray, lineWidth: 2)
        )
        .frame(height: isProfileAvailable ? 150 : 120)
    }
}

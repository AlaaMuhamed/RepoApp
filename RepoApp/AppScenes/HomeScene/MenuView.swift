
import Foundation
import SwiftUI

struct MenuView: View {
    var onLogoutHandler: ()->()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Repo Radar")
                    .font(.custom("Lobster-Regular", size: 50))
                    .foregroundColor(.lightPurble)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top ,50)
            
            Color.extraLightPurple
                .frame(height: 80)
                .overlay {
                    HStack {
                        VStack(alignment:.leading,spacing: 10) {
                            Text(UserDefaultsConfig.userName ?? "")
                                .font(.system(size: 15))
                                .fontWeight(.regular)
                            
                            Text("Edit profile")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .cornerRadius(10)
                .padding(.horizontal)
            
            Divider()
            .background(Color.gray)
            .padding()
        
            HStack {
                Image( "home-icon")
                    .padding(.horizontal)
                Text("Home")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
            }
            .padding(.vertical,10)
        
            HStack {
                Image( "notification-icon")
                    .padding(.horizontal)

                Text("Notifications")
                    .font(.system(size: 17))
            }
            .padding(.vertical,10)

            
            HStack {
                Image( "setting-icon")
                    .padding(.horizontal)
                Text("Settings")
                    .font(.system(size: 17))
            }
            .padding(.vertical,10)


            Spacer()
            
            Divider()
            .background(Color.gray)
            .padding()
            
            Button(action: {
                UserDefaultsConfig.userName = nil
               onLogoutHandler()
            }) {
                HStack {
                    Image( "logout-icon")
                        .padding(.horizontal)
                    
                    Text("Logout")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        
                }
                .padding(.bottom,50)
            }
        }
    }
}

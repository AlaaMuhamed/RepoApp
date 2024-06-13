
import Foundation

public struct UserDefaultsConfig {
    
    @UserDefault("userName", defaultValue: nil)
    static var userName: String?
    
}

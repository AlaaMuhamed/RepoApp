
import Foundation

final class LoginViewModel: ObservableObject {
    
    //MARK: - Save user Data -
    
    func saveUserData(email: String) {
        guard let userName = email.components(separatedBy: "@").first  else
        {
            return
        }
        UserDefaultsConfig.userName = userName
    }
    
    //MARK: - Auth -
    func checkUserAuth(emailValidation: ValidationState , passwordValidation: ValidationState) -> Bool {
        if emailValidation == .success , passwordValidation == .success {
            return true
        }
        return false
    }

}

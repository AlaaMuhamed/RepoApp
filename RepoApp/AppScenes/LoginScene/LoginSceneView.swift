
import SwiftUI
import UIKit

struct LoginSceneView: View {
    
    //MARK: - State Variables -
    
    @State private var userEmail: String = ""
    @State private var password: String = ""
    @State private var emailOrUsernameValidation: ValidationState = .none
    @State private var passwordValidation: ValidationState = .none
    @State private var emailValidationError: String = ""
    @State private var PasswordValidationError: String = ""
    @State private var isButtonEnabled: Bool = false
    @ObservedObject var loginViewModel: LoginViewModel

    //MARK: - SceneView -

    var body: some View {
        VStack {
            Spacer()
            makeHeadlineView()
            Spacer()
            VStack {
                Image("login-BG")
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        VStack {
                            Image("Profile-image")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 222, height: 222)
                                .clipShape(Circle())
                                .offset(y: -30)
                            makeSignInView()
                            Spacer()
                    }
                }
            }
        }
        .background(
            Color(.splashBG)
        )
        .edgesIgnoringSafeArea(.all)
        .onChange(of: userEmail, perform: { email in
            if email.count >= 4, email.isValidEmail {
                emailOrUsernameValidation = .success
                emailValidationError = ""
                isButtonEnabled = loginViewModel.checkUserAuth(emailValidation: emailOrUsernameValidation, passwordValidation: passwordValidation)
            } else {
                if email.count == 0 {
                    emailOrUsernameValidation = .none
                    emailValidationError = ""
                } else {
                    emailOrUsernameValidation = .failure
                    emailValidationError = "Please enter valid email"
                }
                isButtonEnabled = false
            }
        })
        .onChange(of: password, perform: { passwordText in
            if passwordText.count >= 6 {
                passwordValidation = .success
                PasswordValidationError = ""
                isButtonEnabled = loginViewModel.checkUserAuth(emailValidation: emailOrUsernameValidation, passwordValidation: passwordValidation)
            } else {
                if passwordText.count == 0 {
                    passwordValidation = .none
                    PasswordValidationError = ""
                } else {
                    PasswordValidationError = "Password Must be more than 7 characters"
                    passwordValidation = .failure
                }
                isButtonEnabled = false
            }
        })
    }
    
    //MARK: - View Builders -

    @ViewBuilder private func makeHeadlineView() -> some View {
        VStack {
            Text("Repo Radar")
                .font(.custom("Lobster-Regular", size: 60))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.bottom , 30)
            
            Text("Explore, contribute, and grow")
                .font(.custom("Mansalva-Regular", size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
        .padding(.top, 64)
        .padding(.bottom, 50)
    }
    
    @ViewBuilder private func makeSignInView() -> some View {
        HStack {
            Text("Sign in")
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.top, -50)
        .padding(.leading , 25)
        
        VStack(spacing: 15) {
            ForEach(CustomSigninTextFieldType.allCases, id: \.self) { textField in
                CustomTextField(text: binding(for: textField), isLoginText: .constant(true), errorText: bidingValidationError(for: textField), validationState: bidingValidation(for: textField), onCommit: {}, placeholder: textField.localizedString, isSecure: textField == .password)
            }
        }
        .padding(.top, -35)
        .padding(.horizontal , 20)
        Button(action: {}) {
            Text("Not Register yet? Sign up")
                .underline()
                .foregroundColor(.black)
                .font(.system(size: 14, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 30)
        .padding(.bottom , 30)
        
        Button(action: {
            loginViewModel.saveUserData(email: userEmail)
            resetWindowContent()
        }) {
            Text("Enter")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(isButtonEnabled ?  Color(.lightPurble) : .lightGray)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.bottom , 30)
        .disabled(!isButtonEnabled)
    }
    
    
    //MARK: - Helpers -

    private func binding(for textField: CustomSigninTextFieldType) -> Binding<String> {
        switch textField {
        case .email: return $userEmail
        case .password: return $password
        }
    }

    private func bidingValidation(for textField: CustomSigninTextFieldType) -> ValidationState {
        switch textField {
        case .email: return emailOrUsernameValidation
        case .password: return passwordValidation
        }
    }

    private func bidingValidationError(for textField: CustomSigninTextFieldType) -> String {
        switch textField {
        case .email: return emailValidationError
        case .password: return PasswordValidationError
        }
    }
        
    private func createMainCoordinator() -> UINavigationController {
        let navigationController = MainNavigationController()
        let router = Router(with: navigationController)
        let loginCoordinator = LoginCoordinator(router: router)
        loginCoordinator.start()
        return navigationController
    }
    
    private func resetWindowContent() {
        let rootViewController = createMainCoordinator()
        var window: UIWindow? {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                  let window = windowSceneDelegate.window else {
                return nil
            }
            return window
        }
        window?.rootViewController = rootViewController
    }
}

//MARK: - Enums -

enum CustomSigninTextFieldType: String, CaseIterable {
    case email
    case password
    
    var localizedString: String {
        switch self {
        case .email:
            return "Enter your e-mail"
        case .password:
            return "Enter your password"
        }
    }
}

#Preview {
    LoginSceneView(loginViewModel: LoginViewModel())
}

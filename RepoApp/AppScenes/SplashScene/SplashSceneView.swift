
import SwiftUI

struct SplashSceneView: View {
    //MARK: - State Variables -
    
    @State private var isActive = false
    @State private var isUserAuthorized = false
    
    //MARK: - SceneView  -

    var body: some View {
        VStack {
            if isActive {
                LoginSceneView(loginViewModel: LoginViewModel())
            } else {
                SplashContentView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                if UserDefaultsConfig.userName != nil {
                                    isUserAuthorized = true
                                } else {
                                    self.isActive = true
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: isUserAuthorized, perform: { _ in
            resetWindowContent()
        })
    }
    
    //MARK: - Helpers  -

    func createMainCoordinator() -> UINavigationController {
        let navigationController = MainNavigationController()
        let router = Router(with: navigationController)
        let loginCoordinator = LoginCoordinator(router: router)
        loginCoordinator.start()
        return navigationController
    }
    
    func resetWindowContent() {
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

//MARK: - Splash View  -

struct SplashContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("splash-BG")
                .resizable()
                .scaledToFill()
                .overlay {
                    VStack {
                        Text("Repo Radar")
                            .font(.custom("Lobster-Regular", size: 70))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
        }
        .background(
            Color(.splashBG)
        )
    }
}

#Preview {
    SplashSceneView()
}

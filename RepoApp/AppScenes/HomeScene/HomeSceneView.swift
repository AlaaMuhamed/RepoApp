
import SwiftUI

struct HomeSceneView: View {
    
    //MARK: - Variables -
    @State private var showMenu = false
    @StateObject private var viewModel = HomeViewModel()
    var coordinator: HomeCoordinator?
    
    //MARK: - Initializations -
    init(homeCoordinator: HomeCoordinator? = nil ) {
        coordinator = homeCoordinator
    }
    
    //MARK: - SceneView -
    var body: some View {
        VStack {
            makeHeaderView()
            SearchBarView(text: $viewModel.searchText)
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            makeBookingListView()
            
            Spacer()
        }
        .overlay(
                makeMenueView()
                .background(Color.black.opacity(showMenu ? 0.5 : 0)
                .edgesIgnoringSafeArea(.all))
                .onTapGesture {
                    withAnimation {
                        self.showMenu = false
                    }
                },
            alignment: .leading
        )
        .task {
            await viewModel.fetchRepositories()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
}


//MARK: - View Builders -
extension HomeSceneView {
    @ViewBuilder private func makeHeaderView() -> some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.showMenu.toggle()
                }
            }) {
                Image("menu-icon")
                    .resizable()
                    .frame(width: 24,height: 24)
                    .font(.title)
                
            }
            .padding(.trailing,10)
            
            Text("Hello, ")
                .font(.system(size: 20, weight: .regular)) +
            Text(UserDefaultsConfig.userName ?? "")
                .font(.system(size: 20, weight: .bold))
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image("notification-icon")
                    .resizable()
                    .frame(width: 24,height: 24)
                    .font(.title)
            }
        }
        .padding()
    }
    
    @ViewBuilder private func makeBookingListView() -> some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.filteredRepos, id: \.id) { repo in
                    Button(action: {
                        coordinator?.routeToRepoDetails(repoDetails: repo)
                    }) {
                        RepoBannerView(name: repo.name, date: repo.created_at ?? "", ownerName: repo.owner.login, ownerAvatar: repo.owner.avatar_url)
                    }
                    .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
        }
    }
        
    @ViewBuilder private func makeMenueView() -> some View {
        HStack {
            MenuView(onLogoutHandler: coordinator?.backToLogin ?? {})
            .frame(width: UIScreen.main.bounds.width * 0.7 , height:  UIScreen.main.bounds.height)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .offset(x: showMenu ? 0 : -UIScreen.main.bounds.width * 0.7 , y: -10)
            .animation(.easeInOut)
            Spacer()
        }
    }
}

#Preview {
    HomeSceneView()
}




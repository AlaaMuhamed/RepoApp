
import Foundation

class NetworkService {
    private let url = URL(string: "https://api.github.com/repositories")!
    
    func fetchRepositories() async throws -> [RepoDataModel] {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([RepoDataModel].self, from: data)
    }
}


import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    //MARK: - Variables -
    @Published var searchText = ""
    @Published var repositories: [RepoDataModel] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service = NetworkService()
    private let dateFormatter: DateFormatter
    
    //MARK: - Initialization -
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    }
    
    //MARK: - Getters -
    
    var filteredRepos: [RepoDataModel] {
        if searchText.isEmpty {
            return repositories
        } else {
            return repositories.filter { repo in
                repo.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func fetchRepositories() async {
        isLoading = true
        error = nil
        do {
            var repos = try await service.fetchRepositories()
            repos = repos.map { repo in
                var repository = repo
                repository.created_at = formatDateString(repo.created_at)
                return repository
            }
            repositories = repos
            
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    //MARK: - Helpers -
    
    private func formatDateString(_ dateString: String?) -> String {
        if let dateString = dateString, let date = ISO8601DateFormatter().date(from: dateString) {
            return date.formatted(forDisplayWith: dateFormatter)
        } else {
            let randomDate = generateRandomDateWithinLastTwoYears()
            return randomDate.formatted(forDisplayWith: dateFormatter)
        }
    }
    
     func generateRandomDateWithinLastTwoYears() -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        let twoYearsAgo = calendar.date(byAdding: .year, value: -2, to: currentDate)!
        let randomTimeInterval = TimeInterval.random(in: twoYearsAgo.timeIntervalSinceNow...currentDate.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: randomTimeInterval)
    }
}

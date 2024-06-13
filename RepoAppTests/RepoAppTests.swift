

import XCTest
@testable import RepoApp

final class RepoAppTests: XCTestCase {

    func testFetchRepositories() async throws {
           let service = NetworkService()
           let repositories = try await service.fetchRepositories()
           
           XCTAssertFalse(repositories.isEmpty, "Repositories should not be empty")
           XCTAssertNotNil(repositories.first?.name, "Repository name should not be nil")
       }
    
    func testRecentDateFormatting() {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            
            let calendar = Calendar.current
            let recentDate = calendar.date(byAdding: .month, value: -2, to: Date())!
            
            let formattedDate = recentDate.formatted(forDisplayWith: formatter)
            
            XCTAssertEqual(formattedDate, formatter.string(from: recentDate), "Recent date should be formatted as full date")
        }
}


import Foundation

struct RepoDataModel: Identifiable , Codable {
    let id: Int
    let name: String
    let description: String?
    let full_name: String
    let owner: Owner
    let fork: Bool
    var created_at: String?
}


struct Owner: Codable {
    let login: String
    let avatar_url: String
}

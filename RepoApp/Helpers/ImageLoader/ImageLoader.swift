
import Foundation
import UIKit

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    init(url: String) {
        Task {
            await loadImage(from: url)
        }
    }

    private func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}

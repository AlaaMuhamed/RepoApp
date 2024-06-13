

import Foundation

extension Date {
    func formatted(forDisplayWith formatter: DateFormatter) -> String {
        let calendar = Calendar.current
        if let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: Date()), self > sixMonthsAgo {
            return formatter.string(from: self)
        } else {
            let components = calendar.dateComponents([.year, .month], from: self, to: Date())
            if let year = components.year, year >= 1 {
                return year == 1 ? "1 year ago" : "\(year) years ago"
            } else if let month = components.month, month >= 1 {
                return month == 1 ? "1 month ago" : "\(month) months ago"
            } else {
                return "less than a month ago"
            }
        }
    }
}

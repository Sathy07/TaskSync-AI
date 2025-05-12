import Foundation

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var priority: Int // 1 (Low) to 5 (High)
    var dueDate: Date
    var isCompleted: Bool = false
    var group: String = "General"
}

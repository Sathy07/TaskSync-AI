import Foundation

class TaskViewModel {
    private let saveKey = "SavedTasks"

    func loadTasks() -> [Task] {
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Task].self, from: savedData) {
            return decoded
        }
        return []
    }

    func saveTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}

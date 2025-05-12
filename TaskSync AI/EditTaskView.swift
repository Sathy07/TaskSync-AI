import SwiftUI

struct EditTaskView: View {
    @Binding var tasks: [Task]
    var viewModel: TaskViewModel
    var task: Task

    @Environment(\.dismiss) var dismiss

    @State private var title: String
    @State private var priority: Int
    @State private var dueDate: Date
    @State private var group: String

    init(tasks: Binding<[Task]>, viewModel: TaskViewModel, task: Task) {
        self._tasks = tasks
        self.viewModel = viewModel
        self.task = task
        _title = State(initialValue: task.title)
        _priority = State(initialValue: task.priority)
        _dueDate = State(initialValue: task.dueDate)
        _group = State(initialValue: task.group)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Task")) {
                    TextField("Title", text: $title)
                    TextField("Group", text: $group)

                    Picker("Priority", selection: $priority) {
                        ForEach(1...5, id: \.self) { Text("\($0)") }
                    }

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Update") {
                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                            tasks[index].title = title
                            tasks[index].priority = priority
                            tasks[index].dueDate = dueDate
                            tasks[index].group = group
                            viewModel.saveTasks(tasks)
                            tasks = viewModel.loadTasks()
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

import SwiftUI

struct AddTaskView: View {
    @Binding var tasks: [Task]
    var viewModel: TaskViewModel

    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var priority = 3
    @State private var dueDate = Date()
    @State private var group = "General"

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Title", text: $title)
                    TextField("Group", text: $group)

                    Picker("Priority", selection: $priority) {
                        ForEach(1...5, id: \.self) { Text("\($0)") }
                    }

                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newTask = Task(title: title, priority: priority, dueDate: dueDate, group: group)
                        tasks.append(newTask)
                        viewModel.saveTasks(tasks)
                        tasks = viewModel.loadTasks()
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

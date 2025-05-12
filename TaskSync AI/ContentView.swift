import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    private let viewModel = TaskViewModel()
    @State private var showingAddTask = false
    @State private var editingTask: Task? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(sortedGroupKeys, id: \.self) { group in
                    if let sortedTasks = sortedGroupedTasks[group] {
                        Section(header: Text(group)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)) {
                            
                            ForEach(sortedTasks) { task in
                                HStack(spacing: 16) {
                                    Button(action: {
                                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                            tasks[index].isCompleted.toggle()
                                            viewModel.saveTasks(tasks)
                                            tasks = viewModel.loadTasks()
                                        }
                                    }) {
                                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                            .foregroundColor(task.isCompleted ? .green : .gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(task.title)
                                            .strikethrough(task.isCompleted, color: .gray)
                                            .font(.headline)

                                        HStack {
                                            Text("Priority: \(task.priority)")
                                            Spacer()
                                            Text(task.dueDate, style: .date)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Button(action: {
                                        editingTask = task
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .onDelete { offsets in
                                let indexSet = offsets.compactMap { offset in
                                    sortedTasks.indices.contains(offset) ? tasks.firstIndex(of: sortedTasks[offset]) : nil
                                }
                                tasks.remove(atOffsets: IndexSet(indexSet))
                                viewModel.saveTasks(tasks)
                                tasks = viewModel.loadTasks()
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("TaskSync AI")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTask.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .onAppear {
                tasks = viewModel.loadTasks()
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(tasks: $tasks, viewModel: viewModel)
            }
            .sheet(item: $editingTask) { task in
                EditTaskView(tasks: $tasks, viewModel: viewModel, task: task)
            }
        }
        .accentColor(.blue)
    }

    // Priority Functions

    private var sortedGroupedTasks: [String: [Task]] {
        Dictionary(grouping: tasks, by: { $0.group }).mapValues { groupTasks in
            groupTasks.sorted {
                score(for: $0) < score(for: $1)
            }
        }
    }

    private var sortedGroupKeys: [String] {
        sortedGroupedTasks.map { (key, groupTasks) in
            (key, groupTasks.map(score(for:)).min() ?? Int.max)
        }
        .sorted(by: { $0.1 < $1.1 })
        .map { $0.0 }
    }

    private func score(for task: Task) -> Int {
        (6 - task.priority) * max(1, daysUntil(task.dueDate))
    }

    private func daysUntil(_ date: Date) -> Int {
        let diff = Calendar.current.dateComponents([.day], from: Date(), to: date)
        return max(1, diff.day ?? 1)
    }
}

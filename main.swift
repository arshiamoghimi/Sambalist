import Foundation

// ================================= THIRD PARTIES =====================================

// https://stackoverflow.com/a/7885923
func getCurrentMillis() -> Int64{
    return  Int64(NSDate().timeIntervalSince1970 * 1000)
}


// ====================================  MODELS  =======================================

enum Priority: Int, CaseIterable {
    case high = 1, medium, low

    func toString() -> String {
        switch(self) {
            case Priority.high:
                return "high"
            case Priority.medium:
                return "medium"
            case Priority.low:
                return "low"
        }
    }
}

class TaskBoard {
    static var tasks: [Task] = []
    static var categories: [Category] = []

    private init() {}

    static func addTask(task: Task) {
        tasks.append(task)
    }

    static func removeTask(task: Task) {
        let optionalIndex = tasks.firstIndex{ $0.id == task.id }
        if let taskIndex = optionalIndex {
            tasks.remove(at: taskIndex)
        }
    }

    static func addCategory(category: Category) {
        categories.append(category)
    }

    static func findCategoryByName(name: String) -> Category? {
        let optionalIndex = categories.firstIndex{ $0.name == name }
        if let categoryIndex = optionalIndex {
            return categories[categoryIndex]
        }
        return nil
    }

    static func removeCategory(name: String) -> Bool {
        let optionalIndex = categories.firstIndex{ $0.name == name }
        if let categoryIndex = optionalIndex {
            categories.remove(at: categoryIndex)
            removeCategoryFromTasks(name: name)
            return true
        }
        return false
    }

    private static func removeCategoryFromTasks(name: String) {
        for task in tasks {
            task.categories = task.categories.filter{$0.name != name}
        }
    }
}

class Task {
    private static var autoIncreamentId: Int = 0
    var id: Int
    var creationDate: Int64
    var title: String
    var content: String
    var priority: Priority
    var completed: Bool = false 
    public var categories: [Category] = []

    func checkDone() {
        completed = true
    }

    func removeTask() {
        TaskBoard.removeTask(task: self)
    }

    init(title: String, content: String, priority: Priority) {
        self.id = Task.autoIncreamentId
        Task.autoIncreamentId += 1
        self.creationDate = getCurrentMillis()
        self.title = title
        self.content = content
        self.priority = priority
        TaskBoard.addTask(task: self)
    }
}

class Category: Equatable {
    private static var autoIncreamentId: Int = 0
    var id: Int
    var name: String
    init(name: String) throws {
        for category in TaskBoard.categories {
            if category.name == name {
                throw CategoryValidationError.uniqueName
            }
        }
        id = Category.autoIncreamentId
        Category.autoIncreamentId += 1
        self.name = name

        TaskBoard.addCategory(category: self)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}


// ==================================== Errors =============================================

enum CategoryValidationError: String, Error {
    case uniqueName = "Category name must be unique"
}

// ====================================  CLI HELPER  =======================================

class Color {
    static var black = "\u{001B}[0;30m"
    static var red = "\u{001B}[0;31m"
    static var green = "\u{001B}[0;32m"
    static var yellow = "\u{001B}[0;33m"
    static var blue = "\u{001B}[0;34m"
    static var magenta = "\u{001B}[0;35m"
    static var cyan = "\u{001B}[0;36m"
    static var white = "\u{001B}[0;37m"
    static var reset = "\u{001B}[0;0m"

    static func changeColor(_ color: String) {
        print(color, terminator: "")
    }

    static func resetColor() {
        changeColor(reset)
    }

    private init() {}
}



class GUIHelper {
    private init() {}

    static func drawMenu(name: String, options: [CommandLineOption]) -> Bool {
        Color.changeColor(Color.reset)
        print("=== \(name) ===")
        for option in options {
            print("\(option.key) => \(option.title)")
        }

        let response = readLine()
        for option in options {
            if option.key == response {
                option.run()
                return true
            }
        }
        Color.changeColor(Color.red)
        print("\u{274C}Wrong choice!")
        Color.resetColor()
        return false
    }

    static func drawSelectBox<T: Equatable>(label: String, options: [T], values: [String], current: T?) -> T? {
        printDivider()
        print(label)
        if values.isEmpty {
            print("   No option found!")
            return nil
        }
        for i in 0...values.count-1 {
            let currentString: String
            if options[i] == current {
                currentString = " <="
            } else {
                currentString = ""
            }
            print("\(i) => \(values[i]) \(currentString)")
        }
        let input = readLine()
        if let inputText = input {
            for i in 0...values.count-1 {
                if inputText == "\(i)" {
                    return options[i]
                }
            }
        }
        return nil
    }

    static func drawPrioritySelectBox(label: String, current: Priority? = nil) -> Priority? {
        var values: [String] = []
        for priority in Priority.allCases {
            values.append(priority.toString())
        }
        return drawSelectBox(label: label, options: Priority.allCases, values: values, current: current)
    }
    
    static func printDivider() {
        print("--------------------")
    }
}

class TasksGUI {
    static func printTasksList(tasksList: [Task]) {
        GUIHelper.printDivider()
        print(" === Tasks List ===")
        Color.changeColor(Color.blue)
        if tasksList.isEmpty {
            print("No tasks found with specified filter :( ")
        }
        for task in tasksList {
            print("\(task.id). \(task.title): \(task.content)")
        }
        Color.resetColor()

        GUIHelper.printDivider()
    }
}

class CategoriesManagementGUI {

    func menu() {
        let options: [CommandLineOption] = [
            CreateCategoryOption(),
            CategoryListOption(),
            DeleteCategoryOption(),
            BackOption(),
        ]

        var finished = true
        repeat {
            GUIHelper.printDivider()
            finished = GUIHelper.drawMenu(name: "Category Management", options: options)
        } while finished == false
    }

    func list() {
        Color.resetColor()
        GUIHelper.printDivider()
        print("== Categories:")
        if TaskBoard.categories.isEmpty {
            print("No category found :(")
        } else {
            for category in TaskBoard.categories {
                print("\(category.id): \(category.name)")
            }
        }
        print()
        print()

    }
}

class TaskManagementGUI {
    static func show(task: Task) {
        print()
        print()
        GUIHelper.printDivider()
        print("Task ID: \(task.id)")
        print("Task Title: \(task.title)")
        print("Task Priority: \(task.priority.toString())")
        print("Task Content: \(task.content)")
        GUIHelper.printDivider()
        print()
        _ = GUIHelper.drawMenu(name: "Please select one of this actions", options: [
            DeleteTaskOption(task: task),
            UpdateTaskOption(task: task),
            AddCategoryToTaskOption(task: task),
            BackOption(),
        ])
    }
}

// ====================================  LOGIC  =======================================

protocol CommandLineOption {
    var key: String { get }
    var title: String { get }
    func run()
}

class AnonymousOption: CommandLineOption {
    var keyFunc: () -> String
    var titleFunc: () -> String
    var runFunc: () -> Void 
    var key: String {
        return keyFunc()
    }
    var title: String {
        return titleFunc()
    }

    func run() {
        return runFunc()
    }

    init(key: @escaping () -> String, title: @escaping () -> String, run: @escaping () -> Void) {
        self.keyFunc = key
        self.titleFunc = title
        self.runFunc = run
    }
}


// .................... Main Menu Options .......................

class CreateTaskOption: CommandLineOption {
    var key: String {
        return "+"
    }
    var title: String {
        return "Create new task"
    }

    func run() {
        GUIHelper.printDivider()
        print("Enter Title, Content and Priority of your task in 3 consecutive lines:")
        print("Title?")
        let title = readLine()
        print("Content?")
        let content = readLine()
        let priority = GUIHelper.drawPrioritySelectBox(label: "Priority?")
        // TODO: Validation for priority
        if title != nil && content != nil && priority != nil {
            let _ = Task(title: title!, content: content!, priority: priority!)
            Color.changeColor(Color.green)
            print("\u{2705}Task created Successfully")
            GUIHelper.printDivider()
        } else {
            Color.changeColor(Color.red)
            print("\u{274C}Task creation failed :(")
            GUIHelper.printDivider()
        }
    }
}


class CategoryManagementOption: CommandLineOption {
    var key: String {
        return "c"
    }

    var title: String {
        return "Add / Show Categories"
    }

    func run() {
        CategoriesManagementGUI().menu()
    }
}

class QuitOption: CommandLineOption {
    var key: String {
        return "q"
    }
    var title: String {
        return "Quit"
    }

    func run() {
        print("Good bye!")
        exit(0)
    }
}

// .................... TaskBoard Options .......................

enum TaskBoardColumn: String, CaseIterable {
    case CreationDate = "creation date", Name = "name", Priority = "priority"
}

class TaskBoardTasksOption: CommandLineOption {
    var key: String {
        return "l"
    }
    var order: Bool = true
    var column: TaskBoardColumn = TaskBoardColumn.CreationDate
    var backPressed: Bool = false
    var filter: Category? = nil

    var title: String {
        return "Show tasks"
    }

    func printTasks() {
        var tasksList = TaskBoard.tasks
        switch(column) {
            case TaskBoardColumn.CreationDate:
                break
            case TaskBoardColumn.Name:
                tasksList = tasksList.sorted{$0.title < $1.title}
            case TaskBoardColumn.Priority:
                tasksList = tasksList.sorted{$0.priority.rawValue < $1.priority.rawValue}
        }

        if !order {
            tasksList = tasksList.reversed()
        }

        if let category = filter {
            tasksList = tasksList.filter{
                $0.categories.contains{ $0.id == category.id }
            }
        }


        TasksGUI.printTasksList(tasksList: tasksList)
    }

    func run() {
        backPressed = false
        // TODO: refactor it :)
        let backOption = AnonymousOption(key: {return "b"}, title: { return "Back to main menu"}) {
            self.backPressed = true
        }

        let changeSort = AnonymousOption(key: {"s"}, title: {"Sort"}) {
            var sortOptions: [TaskBoardColumn] = []
            var sortValues: [String] = []
            for column in TaskBoardColumn.allCases {
                sortOptions.append(column)
                sortValues.append(column.rawValue)
            }
            let orderString: String
            if self.order {
                orderString = "ASC"
            } else {
                orderString = "DESC"
            }
            let result = GUIHelper.drawSelectBox(label:"Enter sort key \n Current order: \(orderString) \n" +
                                                 "If you select currenly selected key, the order will be reversed",
                                                 options: sortOptions, values: sortValues,
                                                 current: self.column)

            if let nextColumn = result {
                if self.column != nextColumn {
                    self.order = true
                 } else {
                     self.order = !self.order
                 }
                 self.column = nextColumn
            } else {
                Color.changeColor(Color.red)
                print("\u{274C}Wrong choice!")
                Color.resetColor()
            }
        }

        let filterOption = AnonymousOption(key: {"f"}, title: {"Filter by category"}) {
            let result = GUIHelper.drawSelectBox(label:"Please select one of categories or enter something else for no filtering", options: TaskBoard.categories,
                 values: TaskBoard.categories.map{$0.name}, current: self.filter)
            self.filter = result
        }

        let manageTask = AnonymousOption(key: {"m"}, title: {"Manage a task"}) {
            print("Please enter task ID")
            let input = readLine()
            if let taskId = input {
                for task in TaskBoard.tasks {
                    if taskId == "\(task.id)" {
                        TaskManagementGUI.show(task: task)
                        return
                    }
                }
            }

            Color.changeColor(Color.red)
            print("\u{274C}No task with specified ID found!")
            Color.resetColor()
        }

        while !self.backPressed {
            printTasks()
            _ = GUIHelper.drawMenu(name: "Actions", options: [
                backOption,
                changeSort,
                filterOption,
                manageTask,
            ])
        }
    }

}

class BackOption: CommandLineOption {
    var key: String {
        return "b"
    }

    var title: String {
        return "Back"
    }

    func run() {
        // nothing :)
    }
}

// .................... Category Options .......................

class CategoryListOption: CommandLineOption {
    var key: String {
        return "l"
    }
    var title: String {
        return "Show list of categories"
    }

    func run() {
        CategoriesManagementGUI().list()
    }
}

class DeleteCategoryOption: CommandLineOption {
    var key: String {
        return "-"
    }
    var title: String {
        return "Delete category"
    }

    func run() {
        GUIHelper.printDivider()
        print("Enter Title of category to delete in next line:")
        let title = readLine()
        if let categoryName: String = title {
            let deleted = TaskBoard.removeCategory(name: categoryName)
            if deleted {
                Color.changeColor(Color.green)
                print("\u{2705}Category deleted Successfully")
            } else {
                Color.changeColor(Color.red)
                print("\u{274C} No category found")
            }

            GUIHelper.printDivider()
        }
    }
}

class CreateCategoryOption: CommandLineOption {
    var key: String {
        return "+"
    }
    var title: String {
        return "Create new category"
    }

    func run() {
        GUIHelper.printDivider()
        print("Enter Title of your category in next line:")
        do {
            let title = readLine()
            let _ = try Category(name: title!)

            Color.changeColor(Color.green)
            print("\u{2705}Category created Successfully")
        } catch let catError as CategoryValidationError {
            Color.changeColor(Color.red)
            print("\u{274C} Category not created: \(catError.rawValue)")
        } catch {
            print("Unknown error: \(error)")
        }

        GUIHelper.printDivider()
    }
}


// ....................... Tasks Options .......................

class AddCategoryToTaskOption: CommandLineOption {
    var key: String {"c"}
    var title: String {"Add/Remove Category"}
    var task: Task

    func run() {
        let result = GUIHelper.drawSelectBox(label:"Please select one of the categories or enter something else to cancel this action \n If the task is in the category it will be removed from the category, if not, it will be added.",
             options: TaskBoard.categories, values: TaskBoard.categories.map{$0.name}, current: nil)
        if let category = result {
            if (task.categories.contains{$0 == category}) {
                task.categories = task.categories.filter{$0 != category}
                print("Category successfully removed from task")
            } else {
                task.categories.append(category)
                print("Category successfully added to task")
            }
        }
    }

    init(task: Task) {
        self.task = task
    }
}

class DeleteTaskOption: CommandLineOption {
    var key: String {"-"}
    var title: String {"Remove task"}
    var task: Task

    func run() {
        task.removeTask()
        Color.changeColor(Color.green)
        print("\u{2705}Task '\(task.id). \(task.title)' deleted Successfully")
        GUIHelper.printDivider()
    }

    init(task: Task) {
        self.task = task
    }
}

class UpdateTaskOption: CommandLineOption {
    var key: String {"u"}
    var title: String {"Update task"}
    var task: Task

    private func success() {
        Color.changeColor(Color.green)
        print("\u{2705}Task '\(task.id). \(task.title)' updated Successfully")
        GUIHelper.printDivider()

    }

    func run() {
        let what = GUIHelper.drawSelectBox(label: "Please enter what value to edit", options: [
            "title",
            "content",
            "priority"
        ], values: [
            "title",
            "content",
            "priority"
        ], current: nil)

        switch(what) {
            case "priority":
                let value = GUIHelper.drawPrioritySelectBox(label: "Please enter priority")
                if value != nil {
                    task.priority = value!
                    return self.success()
                }
            case "title":
                let value = readLine()
                if value != nil {
                    task.title = value!
                    return self.success()
                }
            case "content":
                let value = readLine()
                if value != nil {
                    task.content = value!
                    return self.success()
                }
            default:
                Color.changeColor(Color.red)
                print("\u{274C}Wrong choice! action skipped")
                Color.resetColor()
                return
        }

        Color.changeColor(Color.red)
        print("\u{274C}Wrong choice! action skipped")
        Color.resetColor()
    }

    init(task: Task) {
        self.task = task
    }
}

// ====================================  MAIN  =======================================

class MainGUI {
    static func run() {
        let options: [CommandLineOption] = [
            CreateTaskOption(),
            TaskBoardTasksOption(),
            CategoryManagementOption(),
            QuitOption()
        ]

        while true {
            _ = GUIHelper.drawMenu(name: "Main Menu", options: options)
        }
    }
}

// SEED DB

let cat1 = try Category(name: "cat 1")
let cat2 = try Category(name: "cat 2")
_ = try Category(name: "cat 3")

let task1 = Task(title: "d", content: "my task d", priority: Priority.high)
let task2 = Task(title: "c", content: "my task c", priority: Priority.low)
let task3 = Task(title: "b", content: "my task b", priority: Priority.medium)
_ = Task(title: "a", content: "my task a", priority: Priority.high)

task1.categories.append(cat1)
task2.categories.append(cat1)
task3.categories.append(cat2)


MainGUI.run()
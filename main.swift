import Foundation


// ====================================  MODELS  =======================================

enum Priority: Int {
    case high = 1, medium, low
}

class TaskBoard {
    static var tasks: [Task] = []
    static var categories: [Category] = []
    static var taskCategoryAssignments: [TaskCategoryAssingment] = []

    private init() {}

    static func addTask(task: Task) {
        tasks.append(task)
    }

    static func addCategory(category: Category) {
        categories.append(category)
    }

    static func removeTask(task: Task) {
        var taskIndex = -1
        for (index, element) in tasks.enumerated() {
            if task.id == element.id {
                taskIndex = index
                break
            } 
        }
        if taskIndex != -1 {
            tasks.remove(at: taskIndex)
        }
    }
}

class Task {
    private static var autoIncreamentId: Int = 0
    var id: Int
    var creationDate: Int
    var title: String
    var content: String
    var priority: Priority
    var completed: Bool = false 

    func editTitle(newTitle: String) {
        self.title = newTitle
    }

    func editContent(newContent: String) {
        self.content = newContent
    }

    func changePriority(newPriority: Priority) {
        self.priority = newPriority
    }

    func checkDone() {
        completed = true
    }

    func removeTask() {
        TaskBoard.removeTask(task: self)
    }

    init(creationDate: Int, title: String, content: String, priority: Priority) {
        self.id = Task.autoIncreamentId
        Task.autoIncreamentId += 1
        self.creationDate = creationDate
        self.title = title
        self.content = content
        self.priority = priority
        TaskBoard.addTask(task: self)
    }
}

class Category {
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
}

class TaskCategoryAssingment {
    var taskId: Int
    var categoryId: Int
    init(taskId: Int, categoryId: Int) {
        self.taskId = taskId
        self.categoryId = categoryId
    }
}

// ==================================== Errors =============================================

enum CategoryValidationError: Error {
    case uniqueName
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
    
    static func printDivider() {
        print("--------------------")
    }
}

class TasksGUI {
    static func printTasksList(tasksList: [Task]) {
        print("Tasks List:")
        Color.changeColor(Color.blue)
        for (index, task) in tasksList.enumerated() {
            print(String(index + 1) + ". " + task.title + ": " + task.content)
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

// ====================================  LOGIC  =======================================

protocol CommandLineOption {
    var key: String { get }
    var title: String { get }
    func run()
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
        let title = readLine()
        let content = readLine()
        let priority = readLine()
        // TODO: Validation for priority
        let _ = Task(creationDate: 1, title: title!, content: content!, priority: Priority(rawValue: Int(priority!)!)!)
        Color.changeColor(Color.green)
        print("\u{2705}Task created Successfully")
        GUIHelper.printDivider()
    }
}

class ShowTaskBoardOption: CommandLineOption {
    var key: String {
        return "b"
    }
    var title: String {
        return "Go to tasks board"
    }

    func run() {
        let options: [CommandLineOption] = [
            TaskBoardTasks(key: "1", tasks: TaskBoard.tasks, column: "default", order: false, by: nil),
            TaskBoardTasks(key: "2", tasks: TaskBoard.tasks, column: "title", order: false, by: {$0.title < $1.title}),
            TaskBoardTasks(key: "3", tasks: TaskBoard.tasks, column: "creation date", order: false,
                           by: {$0.creationDate < $1.creationDate}),
            TaskBoardTasks(key: "4", tasks: TaskBoard.tasks, column: "priority", order: false,
                           by: {$0.priority.rawValue < $1.priority.rawValue}),
            BackOption(),
        ]
        var finished = true
        repeat {
            GUIHelper.printDivider()
            finished = GUIHelper.drawMenu(name: "Task Borad", options: options)
        } while finished == false
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

class TaskBoardTasks: CommandLineOption {
    var key: String
    var tasks: [Task]
    var by: ((Task, Task) -> Bool)?
    var order: Bool
    var column: String

    var title: String {
        return "Show tasks (by: \(column))"
    }

    func run() {
        var tasksList = tasks
        if let notOptionalBy = by {
            tasksList = tasksList.sorted(by: notOptionalBy)
        }
        // TODO: order

        TasksGUI.printTasksList(tasksList: tasksList)
    }

    init(key: String, tasks: [Task], column: String, order: Bool, by: ((Task, Task) -> Bool)?) {
        self.key = key
        self.tasks = tasks
        self.by = by
        self.column = column
        self.order = order
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
            print("\u{274C} Category not created: \(catError)")
        } catch {
            print("Unknown error: \(error)")
        }

        GUIHelper.printDivider()
    }
}

// ====================================  MAIN  =======================================

class MainGUI {
    static func run() {
        let options: [CommandLineOption] = [
            CreateTaskOption(),
            ShowTaskBoardOption(),
            CategoryManagementOption(),
            QuitOption()
        ]

        while true {
            _ = GUIHelper.drawMenu(name: "Main Menu", options: options)
        }
    }
}


let _ = Task(creationDate: 1, title: "d", content: "adafgsd", priority: Priority.high)
let _ = Task(creationDate: 2, title: "c", content: "adafgsd", priority: Priority.low)
let _ = Task(creationDate: 3, title: "b", content: "adafgsd", priority: Priority.medium)
let _ = Task(creationDate: 4, title: "a", content: "adafgsd", priority: Priority.high)
MainGUI.run()
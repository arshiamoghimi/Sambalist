import Foundation

enum Priority: Int {
    case high = 1, medium, low
}

class TaskBoard {
    static var taskId: Int = 0
    static var tasks: [Task] = []

    private init() {}

    static func addTask(task: Task) {
        tasks.append(task)
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
        self.id = TaskBoard.taskId
        TaskBoard.taskId += 1
        self.creationDate = creationDate
        self.title = title
        self.content = content
        self.priority = priority
        TaskBoard.addTask(task: self)
    }
}

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
    
    static func run() {
        while true {
            drawMenu()
        }
    }

    static func drawMenu() {
        Color.changeColor(Color.reset)
        print("Main Menu:")
        print("1. Create new task")
        print("2. Go to tasks board")
        print("3. Exit")
        let response = readLine()
        switch response {
            case "1":
                createNewTask()
            case "2":
                showTaskBoard()
            case "3":
                exit(0)
            default:
                Color.changeColor(Color.red)
                print("\u{274C}Wrong choice!")
        }
    }

    static func createNewTask() {
        printDivider()
        print("Enter Title, Content and Priority of your task in 3 consecutive lines:")
        let title = readLine()
        let content = readLine()
        let priority = readLine()
        let _ = Task(creationDate: 1, title: title!, content: content!, priority: Priority(rawValue: Int(priority!)!)!)
        Color.changeColor(Color.green)
        print("\u{2705}Task created Successfully")
        printDivider()
    }

    static func printDivider() {
        print("--------------------")
    }

    static func showTaskBoard() {
        Color.changeColor(Color.reset)
        printDivider()
        print("1. Show tasks")
        print("2. Show sorted (name)")
        print("3. Show sorted (creation date)")
        print("4. Show sorted (priority)")
        print("5. Back")
        let response = readLine()
        var orederedList = TaskBoard.tasks
        switch response! {
            case "1" :
                break
            case "2":
                orederedList = TaskBoard.tasks.sorted(by: {$0.title < $1.title})
            case "3":
                orederedList = TaskBoard.tasks.sorted(by: {$0.creationDate < $1.creationDate})
            case "4": 
                orederedList = TaskBoard.tasks.sorted(by: {$0.priority.rawValue < $1.priority.rawValue})
            case "5":
                return
            default:
                Color.changeColor(Color.red)
                print("\u{274C}Wrong choice!")
                showTaskBoard()
        }
        printList(tasksList: orederedList)
        printDivider()
    }

    static func printList(tasksList tasks: [Task]) {
        print("Tasks List:")
        Color.changeColor(Color.blue)
        for (index, task) in tasks.enumerated() {
            print(String(index + 1) + ". " + task.title + ": " + task.content)
        }
        Color.resetColor()
    }
}

let _ = Task(creationDate: 1, title: "d", content: "adafgsd", priority: Priority.high)
let _ = Task(creationDate: 2, title: "c", content: "adafgsd", priority: Priority.low)
let _ = Task(creationDate: 3, title: "b", content: "adafgsd", priority: Priority.medium)
let _ = Task(creationDate: 4, title: "a", content: "adafgsd", priority: Priority.high)
GUIHelper.run()
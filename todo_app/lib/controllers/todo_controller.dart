import '../models/todo_model.dart';

class TodoController {
  // List to store ToDo items
  List<TodoModel> todos = [];

  // CRUD Operations

  // Create a ToDo item
  void addTodo(String title) {
    TodoModel newTodo = TodoModel(title: title);
    todos.add(newTodo);
  }

  //read todo
  List<TodoModel> getTodos() {
    return todos;
  }

  // Update a ToDo item
  void updateTodo(int index, String newTitle) {
    TodoModel updatedTodo = TodoModel(title: newTitle);
    todos[index] = updatedTodo;
  }

  // Delete a ToDo item
  void deleteTodo(int index) {
    todos.removeAt(index);
  }

  void completeTodo(int index) {
    todos[index].isDone = true;
  }

  // Method to add a ToDo event to the calendar
  void addEventToCalendar(String title, DateTime date, int rating) {
    // Logic to add the event to the calendar
    // This might involve using a calendar plugin or package
    // For example, you could use the `table_calendar` package
    // to display events in your calendar view.
  }
}

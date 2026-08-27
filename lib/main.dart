import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() {
    return _TodoHomePageState();
  }
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController taskController = TextEditingController();

  List<String> tasks = [];
  List<bool> completed = [];
  List<String> deletedTasks = [];
  List<String> categories = [];

  String selectedCategory = "General";
  String selectedDrawerCategory = "All Tasks";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          "TO DO List",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // DRAWER
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "My Tasks",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ALL TASKS
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("All Tasks"),
              onTap: () {
                setState(() {
                  selectedDrawerCategory = "All Tasks";
                });
                Navigator.pop(context);
              },
            ),

            // WORK
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text("Work"),
              onTap: () {
                setState(() {
                  selectedDrawerCategory = "Work";
                });
                Navigator.pop(context);
              },
            ),

            // STUDY
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Study"),
              onTap: () {
                setState(() {
                  selectedDrawerCategory = "Study";
                });
                Navigator.pop(context);
              },
            ),

            // PERSONAL
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Personal"),
              onTap: () {
                setState(() {
                  selectedDrawerCategory = "Personal";
                });
                Navigator.pop(context);
              },
            ),

            // SHOPPING
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Shopping"),
              onTap: () {
                setState(() {
                  selectedDrawerCategory = "Shopping";
                });
                Navigator.pop(context);
              },
            ),

            // RECENTLY DELETED
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text("Recently Deleted"),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Recently Deleted"),
                      content: deletedTasks.isEmpty
                          ? const Text("No deleted tasks")
                          : SizedBox(
                        width: double.maxFinite,
                        height: 300,
                        child: ListView.builder(
                          itemCount: deletedTasks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.delete),
                              title: Text(deletedTasks[index]),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Tasks",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  // CATEGORY FILTER
                  if (selectedDrawerCategory != "All Tasks" &&
                      categories[index] != selectedDrawerCategory) {
                    return const SizedBox.shrink();
                  }

                  return Card(
                    child: ListTile(
                      // CHECKBOX
                      leading: Checkbox(
                        value: completed[index],
                        onChanged: (value) {
                          setState(() {
                            completed[index] = value!;
                          });

                          if (value == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Task completed!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),

                      // TASK NAME
                      title: Text(
                        tasks[index],
                        style: TextStyle(
                          fontSize: 18,
                          decoration: completed[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),

                      // CATEGORY
                      subtitle: Text(categories[index]),

                      // DELETE BUTTON
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          String deletedTask = tasks[index];
                          bool deletedCompleted = completed[index];
                          String deletedCategory = categories[index];

                          setState(() {
                            deletedTasks.add(deletedTask);

                            tasks.removeAt(index);
                            completed.removeAt(index);
                            categories.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Task deleted!"),
                              duration: const Duration(seconds: 4),
                              action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () {
                                  setState(() {
                                    tasks.add(deletedTask);
                                    completed.add(deletedCompleted);
                                    categories.add(deletedCategory);

                                    deletedTasks.remove(deletedTask);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ADD TASK BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add New Task"),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TASK INPUT
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        hintText: "Enter a task",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // CATEGORY DROPDOWN
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "General",
                          child: Text("General"),
                        ),
                        DropdownMenuItem(
                          value: "Work",
                          child: Text("Work"),
                        ),
                        DropdownMenuItem(
                          value: "Study",
                          child: Text("Study"),
                        ),
                        DropdownMenuItem(
                          value: "Personal",
                          child: Text("Personal"),
                        ),
                        DropdownMenuItem(
                          value: "Shopping",
                          child: Text("Shopping"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),

                // BUTTONS
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (taskController.text.trim().isNotEmpty) {
                        setState(() {
                          tasks.add(taskController.text.trim());
                          completed.add(false);
                          categories.add(selectedCategory);
                        });

                        taskController.clear();

                        selectedCategory = "General";

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
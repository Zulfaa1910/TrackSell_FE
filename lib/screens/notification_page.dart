import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Task Assigned',
      detail: 'You have been assigned a new task by the admin.',
      type: NotificationType.task,
    ),
    NotificationItem(
      title: 'Confirmation Received',
      detail: 'Reseller has confirmed the task.',
      type: NotificationType.confirmation,
    ),
    NotificationItem(
      title: 'New Task Assigned',
      detail: 'You have been assigned a new task by the admin.',
      type: NotificationType.task,
    ),
    NotificationItem(
      title: 'Confirmation Received',
      detail: 'Reseller has confirmed the task.',
      type: NotificationType.confirmation,
    ),
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi'),
        backgroundColor: Colors.redAccent[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(
                  notifications[index].type == NotificationType.task
                      ? Icons.assignment
                      : Icons.check_circle,
                  color: notifications[index].type == NotificationType.task
                      ? Colors.blue
                      : Colors.green,
                ),
                title: Text(notifications[index].title),
                subtitle: Text(notifications[index].detail),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  // Handle tap on notification
                  _onNotificationTap(context, notifications[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNotificationTap(BuildContext context, NotificationItem notification) {
    // Here you can add logic to navigate or show more details about the notification
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Text(notification.detail),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Notification item class to represent each notification
class NotificationItem {
  final String title;
  final String detail;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.detail,
    required this.type,
  });
}

// Enum to represent notification types
enum NotificationType {
  task,
  confirmation,
}

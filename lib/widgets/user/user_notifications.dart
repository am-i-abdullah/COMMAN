import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/user/delete_user_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserNotifications extends ConsumerStatefulWidget {
  const UserNotifications({super.key, this.only3 = false});
  final bool only3;
  @override
  ConsumerState<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends ConsumerState<UserNotifications> {
  var notifications;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  void loadNotifications() async {
    Dio dio = Dio();
    String url = 'http://$ipAddress:8000/hrm/user/notifications/';

    try {
      Response response = await dio.get(
        url,
        options: getOpts(ref),
      );

      notifications = response.data;
      setState(() {});
    } catch (error) {
      print('error');
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: (notifications != null && notifications.isNotEmpty)
          ? [
              for (final notif in notifications
                  .take(widget.only3 ? 3 : notifications.length))
                Card(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notif['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                if (width > 500)
                                  Text(
                                    DateFormat('yyyy-MMMM-dd').format(
                                        DateTime.parse(notif['date_received'])),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                const SizedBox(width: 5),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog<void>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: DeleteUserNotification(
                                          notificationId: notif['id'],
                                        ),
                                      ),
                                    );

                                    loadNotifications();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 0),
                        Text(
                          "Details: ${notif['message']}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // mobile view
                        if (width <= 500) const SizedBox(height: 10),
                        if (width <= 500)
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              const Text('Dated: '),
                              Text(
                                DateFormat('yyyy-MMMM-dd').format(
                                    DateTime.parse(notif['date_received'])),
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                )
            ]
          : (!isLoading)
              ? [
                  const Text(
                    'no notifications',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )
                ]
              : [const Center(child: CircularProgressIndicator())],
    );
  }
}

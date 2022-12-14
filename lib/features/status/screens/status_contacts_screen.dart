import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/status/controller/status_controller.dart';
import 'package:whatsapp_ui/features/status/screens/status_screen.dart';
import 'package:whatsapp_ui/models/status_model.dart';

import '../../../colors.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      StatusScreen.routeName,
                      arguments: statusData,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: dividerColor, indent: 85),
              ],
            );
          },
          itemCount: snapshot.data!.length,
        );
      },
    );
  }
}

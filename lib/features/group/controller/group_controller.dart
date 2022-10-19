import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart' show Contact;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  const GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String name,
    File groupPic,
    List<Contact> selectedContacts,
  ) {
    groupRepository.createGroup(
      context,
      name,
      groupPic,
      selectedContacts,
    );
  }
}

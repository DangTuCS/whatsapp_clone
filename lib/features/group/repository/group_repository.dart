import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart' show Contact;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/models/group.dart';

import '../../../utils/utils.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  const GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String name,
    File groupPic,
    List<Contact> selectedContacts,
  ) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo:
                  selectedContacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          if (uids.contains(userCollection.docs[0].data()['uid'])){
            return;
          }
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }

      var groupId = const Uuid().v1();

      String groupUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('group/$groupId', groupPic);

      Group group = Group(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: 'NEW',
        groupPic: groupUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

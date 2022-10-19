import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart' show Contact;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/call/repository/call_repository.dart';
import 'package:whatsapp_ui/models/call.dart';

final callControllerProvider = Provider((ref) {
  return CallController(
    callRepository: ref.watch(callRepositoryProvider),
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final FirebaseAuth auth;
  final ProviderRef ref;

  const CallController({
    required this.callRepository,
    required this.auth,
    required this.ref,
  });

  void makeCall(
    BuildContext context,
    String receiverName,
    String receiverId,
    String receiverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: true,
      );

      Call receiverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(
          senderCallData,
          context,
          receiverCallData,
        );
      } else {
        callRepository.makeCall(senderCallData, context, receiverCallData);
      }
    });
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
    bool isGroupChat,
  ) {
    isGroupChat
        ? callRepository.endGroupCall(
            callerId,
            receiverId,
            context,
          )
        : callRepository.endCall(
            callerId,
            receiverId,
            context,
          );
  }

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
}

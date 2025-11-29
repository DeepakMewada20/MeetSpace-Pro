import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final approwalStatusProvider =
    StreamProvider.family<
      Map<String, dynamic>?,
      (String mettingId, String userId)
    >((ref, arg) {
      final (mettingId, userId) = arg;
      return FirebaseFirestore.instance
          .collection("mettings")
          .doc(mettingId)
          .collection("waitingList")
          .doc(userId)
          .snapshots()
          .map((doc) => doc.data());
    });

Stream<QuerySnapshot<Map<String, dynamic>>> fetchWaitingListparticipents(
  String mettingId,
) {
  return FirebaseFirestore.instance
      .collection('mettings')
      .doc(mettingId)
      .collection('waitingList')
      .where('status', isEqualTo: 'waiting')
      .snapshots();
}

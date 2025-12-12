import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoom_clone/modal/participant.dart';
import 'package:zoom_clone/provider/waiting_participents_provider.dart';

class HostWaitingListScreen extends ConsumerStatefulWidget {
  final String meetingId;

  const HostWaitingListScreen({super.key, required this.meetingId});

  @override
  ConsumerState<HostWaitingListScreen> createState() =>
      _HostWaitingListScreenState();
}

class _HostWaitingListScreenState extends ConsumerState<HostWaitingListScreen> {
  late List<Participant> waittinParticipants;
  late CollectionReference? _firestoreDataUpdate;

  @override
  void initState() {
    super.initState();
    _firestoreDataUpdate = FirebaseFirestore.instance
        .collection('mettings')
        .doc(widget.meetingId)
        .collection('participants');
  }

  Future<void> _manualRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _manualRefresh,
      child: StreamBuilder(
        stream: fetchWaitingListparticipents(widget.meetingId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          final doc = snapshot.data!.docs;
          waittinParticipants = doc
              .map((doc) => Participant.fromDoc(doc))
              .toList();
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              backgroundColor: colorScheme.surfaceContainer,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Waiting Room', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${waittinParticipants.length}',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'ID: ${widget.meetingId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            body: waittinParticipants.isEmpty
                ? _buildEmptyState(colorScheme)
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: waittinParticipants.length,
                          itemBuilder: (context, index) =>
                              _buildParticipantCard(
                                waittinParticipants[index],
                                colorScheme,
                              ),
                        ),
                      ),
                      _buildBottomBar(colorScheme),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildParticipantCard(Participant p, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
            backgroundImage: p.photoUrl.isNotEmpty
                ? NetworkImage(p.photoUrl)
                : null,
            child: p.photoUrl.isEmpty
                ? Icon(Icons.person, color: colorScheme.primary)
                : null,
          ),
          const SizedBox(width: 12),

          // Name & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildMediaBadge(
                      p.isCameraOn ? Icons.videocam : Icons.videocam_off,
                      p.isCameraOn,
                      colorScheme,
                    ),
                    const SizedBox(width: 8),
                    _buildMediaBadge(
                      p.isMicrophoneOn ? Icons.mic : Icons.mic_off,
                      p.isMicrophoneOn,
                      colorScheme,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              IconButton(
                onPressed: () => _admitParticipant(p),
                icon: Icon(Icons.check_circle, color: colorScheme.tertiary),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.tertiary.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _denyParticipant(p),
                icon: Icon(Icons.cancel, color: colorScheme.error),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.error.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaBadge(IconData icon, bool isOn, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isOn
            ? colorScheme.tertiary.withValues(alpha: 0.1)
            : colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 12,
            color: isOn ? colorScheme.tertiary : colorScheme.error,
          ),
          const SizedBox(width: 4),
          Text(
            isOn ? 'On' : 'Off',
            style: TextStyle(
              fontSize: 10,
              color: isOn ? colorScheme.tertiary : colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _admitAll,
            icon: Icon(Icons.group_add),
            label: Text('Admit All (${waittinParticipants.length})'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No One Waiting',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Participants will appear here',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  void _admitParticipant(Participant p) async {
    await _firestoreDataUpdate!.doc(p.userId).update({'status': 'approved'});
    //print("################################################${_firestoreDataUpdate!.doc(p.userId).snapshots().map((event) => event.data())}");
    // // setState(
    // //   () => waittinParticipants.removeWhere((item) => item.userId == p.userId),
    // // );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('${p.name} approved'),
    //     backgroundColor: Theme.of(context).colorScheme.tertiary,
    //   ),
    // );
  }

  void _denyParticipant(Participant p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deny ${p.name}?'),
        content: Text('Are you sure you want to deny entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _firestoreDataUpdate!.doc(p.userId).update({
                'status': 'denied',
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Deny'),
          ),
        ],
      ),
    );
  }

  void _admitAll() {
    // TODO: Implement admit all logic
    final count = waittinParticipants.length;
    setState(() => waittinParticipants.clear());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('All $count participants admitted')));
  }
}

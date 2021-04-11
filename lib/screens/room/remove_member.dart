import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/data_model.dart';
import '../../models/room_model.dart';
import '../subjects/subject_tile_shimmer.dart';
import 'member_room_tile.dart';

class RemoveMember extends StatelessWidget {
  static final routeName = "/removeMember";
  @override
  Widget build(BuildContext context) {
    Room room = ModalRoute.of(context).settings.arguments;
    refresh() {
      return Provider.of<RoomProvider>(context, listen: false)
          .fetchMembersRoom(room);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Remove Member"),
      ),
      body: FutureBuilder(
          future: Provider.of<RoomProvider>(context, listen: false)
              .fetchMembersRoom(room),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (ctx, index) => SubjectShimmerTile(),
              );
            } else if (dataSnapShot.hasError) {
              return Center(
                child: Text(DataModel.SOMETHING_WENT_WRONG),
              );
            } else {
              return Consumer<RoomProvider>(
                builder: (ctx, roomData, child) => RefreshIndicator(
                    child: ListView.builder(
                      itemCount: roomData.getMemberRoom.length,
                      itemBuilder: (ctx, index) => MemberRoomTile(
                        memberRoom: roomData.getMemberRoom.toList()[index],
                        type: "remove",
                        refreshFunction: refresh,
                      ),
                    ),
                    onRefresh: () {
                      return refresh();
                    }),
              );
            }
          } //  Using consumer here as if,
          ),
    );
  }
}

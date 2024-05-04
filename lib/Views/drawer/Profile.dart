import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/saveDataProvider.dart';
import '../ImageDetailView.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var auth = FirebaseAuth.instance.currentUser;
  ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      /*   appBar: AppBar(
        toolbarHeight: 200,
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Column(
          children: [       Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 60,
              child: auth!.photoURL == null
                  ? const Icon(
                Icons.person_outlined,
                size: 70,
              )
                  : Image.network(auth!.photoURL.toString()),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                auth!.displayName!.isEmpty
                    ? auth!.uid
                    : auth!.displayName.toString(),
                style: GoogleFonts.alata(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                ),
              ),
            ),],
        ),
      ),*/
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('PixelVibe')
              .doc('UserImages')
              .collection(auth!.uid.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return const Center(child: Text('no data'));
            } else if (snapshot.hasError) {
              return const Center(child: Text('has error'));
            } else {
              return CustomScrollView(
                scrollBehavior: const ScrollBehavior(),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                slivers: [
                  SliverAppBar(
                    snap: false,
                    pinned: false,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  auth!.uid,
                                  style: GoogleFonts.alata(fontSize: 15),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.person_outline_outlined),
                              ),
                            ),
                          ],
                        )), //FlexibleSpaceBar
                    expandedHeight: 150,
                    backgroundColor: Colors.transparent,
                  ),
                  SliverAppBar(
                    snap: false,
                    pinned: true,
                    floating: false,
                    leading: const SizedBox(),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                            child: SizedBox(
                              height: 40,
                              child:
                                  ClipDetail('Favourite', Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ), //FlexibleS Row(
                  ),
                  SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 300,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return imageWidget(
                        () {},
                        data['images'].toString(),
                        data['id'].toString(),
                      );
                    },
                  ),
                ],
              );
            }
          }),
      /*
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipDetail('Favourites', Colors.transparent),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('PixelVibe')
                      .doc('UserImages')
                      .collection(auth!.uid.toString())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return GridView.builder(
                        controller: controller,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 300,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return imageWidget(
                            () {},
                            data['images'].toString(),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),*/
    );
  }

  Widget imageWidget(onTap, String url, id) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                url,
              ),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Consumer<SaveDataProvider>(builder: (context, data, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      data.delete(id);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      // await ImageDownloader.downloadImage(
                      //   url,
                      // ).then((value) {
                      //   Fluttertoast.showToast(msg: 'Saved');
                      // }).onError((error, stackTrace) {
                      //   Fluttertoast.showToast(msg: error.toString());
                      // });
                    },
                    icon: const Icon(
                      Icons.download_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

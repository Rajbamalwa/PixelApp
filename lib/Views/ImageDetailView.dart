import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/saveDataProvider.dart';

class ImageDetailView extends StatefulWidget {
  final model;
  ImageDetailView({super.key, required this.model});

  @override
  State<ImageDetailView> createState() => _ImageDetailViewState();
}

class _ImageDetailViewState extends State<ImageDetailView> {
  var user = FirebaseAuth.instance.currentUser;
  bool favBool = false;
  String image = '';
  getFavBool() async {
    await FirebaseFirestore.instance
        .collection('PixelVibe')
        .doc('UserImages')
        .collection(user!.uid.toString())
        .doc(widget.model.id.toString())
        .get()
        .then((value) {
      if (mounted) {
        if (value.exists) {
          setState(() {
            favBool = value.get('favBool');
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getFavBool();
    super.initState();
  }

  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                widget.model.src!.portrait.toString(),
              ),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      onTap: () async {
                        await launchUrl(
                            Uri.parse(widget.model.photographerUrl.toString()));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/camera.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                      title: ClipDetail(widget.model.photographer, Colors.grey),
                      trailing: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              if (await Permission.storage.isDenied) {
                                Permission.storage.request();
                              } else if (await Permission.storage.isGranted) {
                                String url =
                                    widget.model.src!.portrait.toString();
                                // await ImageDownloader.downloadImage(
                                //   url,
                                // ).then((value) {
                                //   Fluttertoast.showToast(msg: 'Saved');
                                // }).onError((error, stackTrace) {
                                //   Fluttertoast.showToast(msg: error.toString());
                                // });
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Please Provide Storage Permission to download image');
                              }
                            },
                          )),
                      //trailing: Text(widget.model.photographerId.toString()),
                    ),
                    ListTile(
                      title: ClipDetail(widget.model.alt, Colors.grey),
                      trailing: Consumer<SaveDataProvider>(
                          builder: (context, data, child) {
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: IconButton(
                              tooltip: 'Like',
                              onPressed: () {
                                String url =
                                    widget.model.src!.portrait.toString();
                                String id = widget.model.id.toString();

                                String photoGrapherName =
                                    widget.model.photographer.toString();
                                String photoGrapherId =
                                    widget.model.photographerId.toString();
                                String photoGrapherUrl =
                                    widget.model.photographerUrl.toString();
                                setState(() {
                                  favBool = !favBool;
                                });
                                if (favBool == true) {
                                  data.saveToFav(
                                      widget.model.id,
                                      url,
                                      photoGrapherName,
                                      photoGrapherId,
                                      photoGrapherUrl);
                                } else {
                                  data.delete(widget.model.id);
                                }
                              },
                              icon: Icon(
                                favBool == false
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: favBool == false
                                    ? Colors.black
                                    : const Color(0xffff0000),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Container(
                      color: null,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        'Select One',
                                        style: GoogleFonts.alata(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.clear),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.white,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        String url = widget.model.src!.portrait
                                            .toString();
                                        AsyncWallpaper.setWallpaper(
                                                url: url,
                                                wallpaperLocation:
                                                    AsyncWallpaper.HOME_SCREEN)
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: 'Set on Home Screen');
                                        }).onError((error, stackTrace) {
                                          Fluttertoast.showToast(
                                              msg: error.toString());
                                        });
                                      },
                                      title: Text(
                                        'Home Screen',
                                        style: font,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        String url = widget.model.src!.portrait
                                            .toString();
                                        AsyncWallpaper.setWallpaper(
                                                url: url,
                                                wallpaperLocation:
                                                    AsyncWallpaper.LOCK_SCREEN)
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: 'Set on Lock Screen');
                                        }).onError((error, stackTrace) {
                                          Fluttertoast.showToast(
                                              msg: error.toString());
                                        });
                                      },
                                      title: Text(
                                        'Lock Screen',
                                        style: font,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () async {
                                        String url = widget.model.src!.portrait
                                            .toString();

                                        AsyncWallpaper.setWallpaper(
                                                url: url,
                                                wallpaperLocation:
                                                    AsyncWallpaper.BOTH_SCREENS)
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: 'Set on Both Screen');
                                        }).onError((error, stackTrace) {
                                          Fluttertoast.showToast(
                                              msg: error.toString());
                                        });
                                      },
                                      title: Text(
                                        'Both Screen',
                                        style: font,
                                      ),
                                      subtitle: Text('Lock & Home Screen',
                                          style: GoogleFonts.alata(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ),
                                  ],
                                );
                              });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              'Set Wallpaper',
                              style: GoogleFonts.alata(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle font = GoogleFonts.alata(fontSize: 18, color: Colors.white);
}

/*
  FloatingActionButton(
        tooltip: 'Download Image',
        onPressed: () async {
          String url = widget.model.src!.portrait.toString();
          String photoGrapherName = widget.model.photographer.toString();
          String photoGrapherId = widget.model.photographerId.toString();
          String photoGrapherUrl = widget.model.photographerUrl.toString();
          var set = FirebaseFirestore.instance
              .collection('PixelVibe')
              .doc('UserImages')
              .collection(user!.uid.toString())
              .doc();
          set.set({
            'images': url,
            'photoGrapherName': photoGrapherName,
            'photoGrapherId': photoGrapherId,
            'photoGrapherUrl': photoGrapherUrl,
            'id': set.id,
          });
          await GallerySaver.saveImage(url).then((value) {
            Fluttertoast.showToast(msg: 'Saved');
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(msg: error.toString());
          });
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.download),
      ),*/
Widget ClipDetail(text, color) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
      border: Border.all(color: Colors.white),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textDirection: TextDirection.ltr,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.start,
          style: GoogleFonts.alata(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

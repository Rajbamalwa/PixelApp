import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:pixelsvibe/Model/DataModel.dart';
import 'package:pixelsvibe/provider/saveDataProvider.dart';
import 'package:provider/provider.dart';

import '../Services/Api.dart';
import '../Services/ApiEndPoints.dart';
import 'ImageDetailView.dart';
import 'drawer/Profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DataModel model;

  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  String val = 'Trending';
  int index = 1;
  @override
  void initState() {
    super.initState();
    final pro = Provider.of<CallApi>(context, listen: false);
    pro.controller.addListener(() {});
    setState(() {
      pro.getData(val, searchApi);
      controller.addListener(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<SaveDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Text(
              'Pix',
              style: GoogleFonts.alata(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              'elsV',
              style: GoogleFonts.alata(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700),
            ),
            Text(
              'ibe',
              style: GoogleFonts.alata(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Text(
              '.',
              style: GoogleFonts.alata(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProfileView()));
                  },
                  icon: Icon(Icons.person_outline_outlined)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Marquee(
              text: 'Trending: space, sky, nature, dark, flowers:           ',
              style: GoogleFonts.alata(color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<CallApi>(builder: (context, data, child) {
                    return SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: data.controller,
                        maxLines: 1,
                        onChanged: (value) {
                          pro.getFavList;
                        },
                        keyboardAppearance: Brightness.dark,
                        decoration: InputDecoration(
                          fillColor: Colors.white10,
                          filled: true,
                          disabledBorder: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 21,
                          ),
                          hintStyle: const TextStyle(fontSize: 20),
                          label: Text('Search'),
                        ),
                      ),
                    );
                  }),
                ),
                Consumer<CallApi>(builder: (context, data, child) {
                  return IconButton(
                      onPressed: () {
                        data.getData(data.controller.text, searchApi);
                        pro.getFavList;
                      },
                      icon: const CircleAvatar(
                          backgroundColor: Colors.white10,
                          child: Icon(Icons.search)));
                }),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                clipWidget('Trending'),
                clipWidget('India'),
                clipWidget('Sea'),
                clipWidget('Football'),
                clipWidget('Wallpaper'),
                clipWidget('Pets'),
              ],
            ),
          ),
          Consumer<CallApi>(builder: (context, data, child) {
            return data.isLoading == false
                ? Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 300,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: data.model.photos!.length,
                      itemBuilder: (context, index) {
                        return imageWidget(
                          () {
                            pro.getFavList;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ImageDetailView(
                                  model: data.model.photos![index],
                                ),
                              ),
                            );
                          },
                          data.model.photos![index].id.toString(),
                          data.model.photos![index].src!.tiny.toString(),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Loading..")
                      ],
                    ),
                  );
          }),
        ],
      ),
      bottomNavigationBar: Consumer<CallApi>(builder: (context, data, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                data.getData(data.controller.text, searchApi);
              },
              child: Text(
                'Default',
                style: GoogleFonts.alata(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                data.backMore(data.controller.text, searchApi);
              },
              child: Text(
                'Back',
                style: GoogleFonts.alata(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                data.loadMore(data.controller.text, searchApi);
              },
              child: Text(
                'Load more',
                style: GoogleFonts.alata(color: Colors.blue),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget imageWidget(onTap, String name, String url) {
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
              )),
          child: Text(name),
        ),
      ),
    );
  }
}

Widget clipWidget(String text) {
  return Consumer<CallApi>(builder: (context, data, child) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          data.controller.text = text;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: GoogleFonts.alata(),
              ),
            ),
          ),
        ),
      ),
    );
  });
}

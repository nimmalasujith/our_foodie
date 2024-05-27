import 'package:flutter/material.dart';
import 'package:our_foodie/save/sharedPref_save_data.dart';
import 'package:our_foodie/shops/our_shops.dart';
import 'package:our_foodie/test.dart';

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  List<ShopDetailsConvertor> foodies=[];
  getData() async {
    foodies = await SubjectPreferences.get();
    setState(() {
      foodies;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H1Heading("SavedFoodie Places"),
        ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            shrinkWrap: true,
            itemCount: foodies.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ShopContainer(data: foodies[index],);
            }),
      ],
    ));
  }
}

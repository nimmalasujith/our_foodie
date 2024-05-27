import 'package:flutter/material.dart';
import 'package:our_foodie/shops/our_shops.dart';
import 'package:our_foodie/shops/shop_details.dart';
import 'package:our_foodie/test.dart';

class CategoriseFilterFoodies extends StatefulWidget {
  List<ShopDetailsConvertor> data;
  String FilteredItem;
   CategoriseFilterFoodies({required this.data,required this.FilteredItem});

  @override
  State<CategoriseFilterFoodies> createState() => _CategoriseFilterFoodiesState();
}

class _CategoriseFilterFoodiesState extends State<CategoriseFilterFoodies> {
  List<ShopDetailsConvertor> _searchResultByTags = [];
  void _filterSearchResultsByTags() {
    List<ShopDetailsConvertor> dummySearchList = List<ShopDetailsConvertor>.from(widget.data);
    if (widget.FilteredItem.isNotEmpty) {
      List<ShopDetailsConvertor> dummyListData = [];

      dummySearchList.forEach((item) {

        if (item.tags.any((tag) => tag.toLowerCase().contains(widget.FilteredItem.toLowerCase()))) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _searchResultByTags.clear();
        _searchResultByTags.addAll(dummyListData);
      });
    } else {
      setState(() {
        _searchResultByTags.clear();
        _searchResultByTags.addAll(widget.data);
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filterSearchResultsByTags();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            H2Heading("Filtered Foodie (${widget.FilteredItem})"),
            ListView.builder(
                itemCount: _searchResultByTags.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ShopContainer(data:_searchResultByTags[index]);
                }),


          ],
        ),
      ),
    );
  }
}

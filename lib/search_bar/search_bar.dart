import 'package:flutter/material.dart';
import 'package:our_foodie/createFoodShopsAndPlaces.dart';
import 'package:our_foodie/saveData.dart';
import 'package:our_foodie/shops/our_shops.dart';
import 'package:our_foodie/test.dart';

class SearchBarPage extends StatefulWidget {
  List<ShopDetailsConvertor> data;
  SearchBarPage({required this.data});

  @override
  State<SearchBarPage> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  TextEditingController _searchController = TextEditingController();

  List<ShopDetailsConvertor> _searchResult = [];


  @override
  void initState() {
    _searchResult.addAll(widget.data);
    _searchResultByTags.addAll(widget.data);
    super.initState();
  }

  void _filterSearchResults(String query) {
    List<ShopDetailsConvertor> dummySearchList = List<ShopDetailsConvertor>.from(widget.data);
    if (query.isNotEmpty) {
      List<ShopDetailsConvertor> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.headings.shopName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(dummyListData);
      });
    } else {
      setState(() {
        _searchResult.clear();
        _searchResult.addAll(widget.data);
      });
    }
  }
  List<ShopDetailsConvertor> _searchResultByTags = [];
  void _filterSearchResultsByTags(String query) {
    List<ShopDetailsConvertor> dummySearchList = List<ShopDetailsConvertor>.from(widget.data);
    if (query.isNotEmpty) {
      List<ShopDetailsConvertor> dummyListData = [];

      dummySearchList.forEach((item) {

        if (item.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))) {
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
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            H1Heading("Search Here"),
            Padding(
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.15))),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: (value) {
                      _filterSearchResults(value);
                      _filterSearchResultsByTags(value);
                    },
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Food Places",
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ListView.builder(
                itemCount:_searchResult.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ShopContainer(data:_searchResult[index]);
                }),
            ListView.builder(
                itemCount:_searchResultByTags.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ShopContainer(data:_searchResultByTags[index]);
                }),

          ],
        ));
  }
}

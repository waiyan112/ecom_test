import '../main.dart';
import './../config/constant.dart';
import './../config/global_style.dart';
import './../models/product_model.dart';
import 'product_detail.dart';
import './../products/search.dart';
import './../functions/cache_image_network.dart';
import './../functions/global_function.dart';
import './../functions/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ProductListsPage extends StatefulWidget {
  @override
  _ProductListsPageState createState() => _ProductListsPageState();
}

class _ProductListsPageState extends State<ProductListsPage> {
  // initialize global function and reusable widget
  final _globalFunction = GlobalFunction();
  final _reusableWidget = ReusableWidget();
  var dio = Dio();
  final List<ProductModel> _productLists = [];

  @override
  void initState() {
    super.initState();
    getProductData();
  }

  getProductData() async {
    var url = 'https://api.ooak.jp/api/v1/goods';
    final response = await dio.get(url);
    var data = response.data['data']['data'];

    for (var i = 0; i < data.length; i++) {
      setState(() {
        _productLists.add(ProductModel(
            id: i,
            name: data[i]['name'],
            price: double.parse(data[i]['prices'][0]['price'].toString()),
            image: data[i]['photos'][0]['name'],
            rating: 5,
            review: 212,
            sale: 735,
            location: 'Brooklyn'));
      });
    }
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    getProductData();
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: GlobalStyle.appBarIconThemeColor,
          ),
          elevation: GlobalStyle.appBarElevation,
          title: Text(
            'OOAK Product Page - ${Provider.of<Counter>(context).count}',
            style: GlobalStyle.appBarTitle,
          ),
          backgroundColor: GlobalStyle.appBarBackgroundColor,
          systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
          actions: [
            IconButton(
                icon: Icon(Icons.search, color: BLACK_GREY),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                }),
          ],
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
            return Future.value(true);
          },
          child: CustomScrollView(
              shrinkWrap: true,
              primary: false,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  sliver: LoadMore(
                    isFinish: true,
                    onLoadMore: _loadMore,
                    child: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: GlobalStyle.gridDelegateRatio,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _buildLastSearchCard(index);
                        },
                        childCount: _productLists.length,
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }

  Widget _buildLastSearchCard(index) {
    final double boxImageSize =
        ((MediaQuery.of(context).size.width) - 24) / 2 - 12;
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: Colors.white,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductDetailPage()));
          },
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: buildCacheNetworkImage(
                      width: boxImageSize,
                      height: boxImageSize,
                      url: _productLists[index].image)),
              Container(
                margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _productLists[index].name,
                      style: GlobalStyle.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '\¥ ' +
                                  _globalFunction.removeDecimalZeroFormat(
                                      _productLists[index].price),
                              style: GlobalStyle.productPrice),
                          Text(_productLists[index].sale.toString() + ' Sale',
                              style: GlobalStyle.productSale)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: SOFT_GREY, size: 12),
                          Text(' ' + _productLists[index].location,
                              style: GlobalStyle.productLocation)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          _reusableWidget.createRatingBar(
                              rating: _productLists[index].rating, size: 12),
                          Text(
                              '(' +
                                  _productLists[index].review.toString() +
                                  ')',
                              style: GlobalStyle.productTotalReview)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

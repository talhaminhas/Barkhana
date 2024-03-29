import 'package:flutter/material.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/ui/shop/branch/shop_branch_item.dart';
import 'package:flutterrestaurant/viewobject/shop_info.dart';

class ShopBranchListView extends StatelessWidget {
  const ShopBranchListView({
    Key? key,
    required this.data,
    required this.scrollController,
  }) : super(key: key);

  final ShopInfo data;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    if (data.branch!.isNotEmpty && data.branch![0].id != '') {
      return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8, right: PsDimens.space8),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.branch!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ShopBranchItem(
                      shopbranch: data.branch![index],
                      onTap: () {},
                    );
                  }),
            )),
      );
    } else {
      return Container();
    }
  }
}

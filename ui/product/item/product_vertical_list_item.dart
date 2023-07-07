import 'package:flutter/material.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/ui/common/ps_hero.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutterrestaurant/viewobject/product.dart';

import '../../common/ps_toast.dart';

class ProductVeticalListItem extends StatelessWidget {
  const ProductVeticalListItem(
      {Key? key,
      required this.product,
      required this.valueHolder,
      this.onTap,
      this.onBasketTap,
        this.onAddTap,
        this.onRemoveTap,
      this.animationController,
      this.animation,
      this.coreTagKey,
      this.qty})
      : super(key: key);

  final String? qty;
  final Product product;
  final Function? onTap;
  final Function? onBasketTap;
  final Function? onAddTap;
  final Function? onRemoveTap;
  final String? coreTagKey;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    Future<void> updateQty(String minimumOrder) async {
      /*setState(() {
        qty = minimumOrder;
      });*/
    }
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
            onTap: onTap as void Function()?,
            child: GridTile(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space2, vertical: PsDimens.space2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PsColors.mainColor, // Set the desired border color here
                    width: 2, // Set the border width
                  ),
                  color: PsColors.backgroundColor,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space10)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    /*Expanded(*/
                      /*child: */Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(PsDimens.space8)),
                        ),
                        child: ClipPath(
                          child: PsNetworkImage(
                            photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                            defaultPhoto: product.defaultPhoto!,
                            width: PsDimens.space180,
                            height: 110,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(product.defaultPhoto!.imgParentId!);
                              onTap!();
                            },
                          ),
                          clipper: const ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(PsDimens.space10),
                                      topRight:
                                          Radius.circular(PsDimens.space10)))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            /*left: PsDimens.space8,
                            top: PsDimens.space8*/),
                        child:
                        Container(
                            color: PsColors.black.withAlpha(210),
                            height: 38,
                            child:
                            Align(
                                alignment: Alignment.center,
                        child:
                        PsHero(
                        tag: '$coreTagKey${PsConst.HERO_TAG__TITLE}',
                        child: Text(
                          product.name!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(color: PsColors.white),

                          maxLines: 1,
                          )
                        )))
                     ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(PsDimens.space8),
                            child: Row(
                            children: <Widget>[

                              Expanded(
                            child:
                                Column(

                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[

                                    PsHero(
                                    tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                                    flightShuttleBuilder: Utils.flightShuttleBuilder,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                  '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice!,valueHolder)}',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                                    ),
                                  ),

                                    if (product.isDiscount == PsConst.ONE)...[
                                      PsHero(
                                          tag: '',/*$coreTagKey${PsConst.heroTagOriginalPrice,*/
                                          flightShuttleBuilder: Utils.flightShuttleBuilder,
                                          child: Material(
                                              color: PsColors.transparent,
                                              child: Text(
                                                '${product.currencySymbol}${Utils.getPriceFormat(product.originalPrice!,valueHolder)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(color: PsColors.discountColor)
                                                    .copyWith(
                                                    decoration: TextDecoration.lineThrough),
                                              ))),
                                      Text(
                                            '${product.discountPercent}%' +
                                                Utils.getString(context,
                                                    'product_detail__discount_off'),
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: PsColors.discountColor),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1),

                                const SizedBox(
                                  height: PsDimens.space4,
                                )
                                  ]
                                    else
                                      Container()
                                ]
                              )),
                              const SizedBox(
                                width: PsDimens.space4,
                              ),
                              /*Container(
                                decoration: BoxDecoration( border: Border.all(color: PsColors.mainColor, width: 2),
                                  borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8))
                                ),
                                child: IconButton(
                                    iconSize: PsDimens.space32,
                                    icon: Icon(Icons.add_shopping_cart_outlined, color: PsColors.mainColor),
                                    onPressed: () {
                                      onButtonTap!();
                                    }
                                ),
                              )*/

                              _IconAndTextWidget(
                                product: product,
                                updateQty: updateQty,
                                qty: qty,
                                onBasketTap: onBasketTap,
                                onAddTap: onAddTap,
                                onRemoveTap: onRemoveTap,
                              ),
                            ]
                        )
                      )
                    ),


                    /*Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space4,
                          right: PsDimens.space8),
                      child: Row(
                        children: <Widget>[

                          if (product.isDiscount == PsConst.ONE)
                            Expanded(
                              child: Text(
                                  '  ${product.discountPercent}% ' +
                                      Utils.getString(context,
                                          'product_detail__discount_off'),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: PsColors.discountColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                            )
                          else
                            Container()
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            )),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child,
          ));
      });
  }
}
class _IconAndTextWidget extends StatefulWidget {
   const _IconAndTextWidget({
    Key? key,
    required this.product,
    required this.updateQty,
    required this.qty,
    required this.onBasketTap,
     required this.onRemoveTap,
     required this.onAddTap
  }) : super(key: key);

  final Product product;
  final Function updateQty;
  final String? qty;
  final Function? onBasketTap;
   final Function? onAddTap;
   final Function? onRemoveTap;

  @override
  _IconAndTextWidgetState createState() => _IconAndTextWidgetState();
}
class _IconAndTextWidgetState extends State<_IconAndTextWidget> {
  int orderQty = 0;
  int maximumOrder = 0;
  int minimumOrder = 1; // 1 is default
  bool showBasket = true;
  void initMinimumOrder() {
    if (widget.product.minimumOrder != '0' &&
        widget.product.minimumOrder != '' &&
        widget.product.minimumOrder != null) {
      minimumOrder = int.parse(widget.product.minimumOrder!);
    }
  }

  void initMaximumOrder() {
    if (widget.product.maximumOrder != '0' &&
        widget.product.maximumOrder != '' &&
        widget.product.maximumOrder != null) {
      maximumOrder = int.parse(widget.product.maximumOrder!);
    }
  }

  void initQty() {
    if (orderQty == 0 && widget.qty != null && widget.qty != '') {
      orderQty = int.parse(widget.qty!);
    } else if (orderQty == 0) {
      orderQty = int.parse(widget.product.minimumOrder!);
    }
  }

  void _increaseItemCount() {
    if (orderQty + 1 <= maximumOrder || maximumOrder == 0) {
      setState(() {
        orderQty++;
        widget.updateQty('$orderQty');
      });
    } else {
      PsToast().showToast(
          ' ${Utils.getString(context, 'product_detail__maximum_order')}  ${widget.product.maximumOrder}');
    }
  }

  void _decreaseItemCount() {
    if (orderQty != 0 && orderQty > minimumOrder) {
      orderQty--;
      setState(() {
        widget.updateQty('$orderQty');
      });
    } else {
      /*PsToast().showToast(
          ' ${Utils.getString(context, 'product_detail__minimum_order')}  ${widget.product.minimumOrder}');*/
      setState(() {
        showBasket = true;
      });
    }
  }

  void onUpdateItemCount(int buttonType) {
    if (buttonType == 1) {
      _increaseItemCount();
    } else if (buttonType == 2) {
      _decreaseItemCount();
    }
  }


  @override
  Widget build(BuildContext context) {
    initMinimumOrder();

    initMaximumOrder();

    initQty();

    final Widget _addIconWidget = IconButton(
        iconSize: PsDimens.space32,
        icon: Icon(Icons.add_circle, color: PsColors.mainColor),
        onPressed: () {
          onUpdateItemCount(1);
          widget.onAddTap!();
          setState(() {
            showBasket = false;
          });
        });

    final Widget _removeIconWidget = IconButton(
        iconSize: PsDimens.space32,
        icon: Icon(Icons.remove_circle, color: PsColors.discountColor),
        onPressed: () {
          onUpdateItemCount(2);
        });

    return Container(
      //margin: const EdgeInsets.only(top: PsDimens.space1, bottom: PsDimens.space8),
      decoration: BoxDecoration( border: Border.all(color: PsColors.mainColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showBasket)
              Container(
                child: IconButton(
                    iconSize: PsDimens.space32,
                    icon: Icon(Icons.add_shopping_cart_outlined, color: PsColors.mainColor),
                    onPressed: () {
                      widget.onBasketTap!();
                      setState(() {
                        showBasket = false;
                      });
                    }
                ),
              ),
          if (!showBasket)...[
            _removeIconWidget,
            Center(
              child: Container(
                height: PsDimens.space24,
                alignment: Alignment.center,
                //decoration: BoxDecoration( border: Border.all(color: PsColors.mainDividerColor)),
                //padding: const EdgeInsets.only( left: PsDimens.space24, right: PsDimens.space24),
                child: Text(
                    '$orderQty', //?? widget.product.minimumOrder,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                  //.copyWith(color: PsColors.mainColor),
                ),
              ),
            ),
            _addIconWidget,
          ]
        ],
      ),
    );
  }
}
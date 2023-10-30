import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/config/ps_config.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/provider/transaction/transaction_detail_provider.dart';
import 'package:flutterrestaurant/provider/transaction/transaction_header_provider.dart';
import 'package:flutterrestaurant/provider/transaction/transaction_status_provider.dart';
import 'package:flutterrestaurant/repository/tansaction_detail_repository.dart';
import 'package:flutterrestaurant/repository/transaction_header_repository.dart';
import 'package:flutterrestaurant/repository/transaction_status_repository.dart';
import 'package:flutterrestaurant/ui/common/dialog/delivery_boy_rating_input_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/error_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/success_dialog.dart';
import 'package:flutterrestaurant/ui/common/ps_button_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/ui/transaction/detail/transaction_item_view.dart';
import 'package:flutterrestaurant/utils/ps_progress_dialog.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/common/ps_value_holder.dart';
import 'package:flutterrestaurant/viewobject/transaction_header.dart';
import 'package:flutterrestaurant/viewobject/transaction_status.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../provider/basket/basket_provider.dart';
import '../../../provider/product/product_provider.dart';
import '../../../repository/basket_repository.dart';
import '../../../repository/product_repository.dart';
import '../../../viewobject/basket.dart';
import '../../../viewobject/basket_selected_add_on.dart';
import '../../../viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import '../../common/dialog/confirm_dialog_view.dart';
import '../../dashboard/core/drawer_view.dart';

class TransactionItemListView extends StatefulWidget {
   TransactionItemListView({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  TransactionHeader transaction;



  @override
  _TransactionItemListViewState createState() =>
      _TransactionItemListViewState();
}

class _TransactionItemListViewState extends State<TransactionItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TransactionDetailRepository? repo1;
  TransactionDetailProvider? _transactionDetailProvider;
  AnimationController? animationController;
  Animation<double> ?animation;
  PsValueHolder? valueHolder;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  //BasketSelectedAddOn basketSelectedAddOn = BasketSelectedAddOn();
  ProductDetailProvider? productDetailProvider;
  ProductRepository? productRepo;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    Utils.MoveToTransactionDetail = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionDetailProvider!
            .nextTransactionDetailList(widget.transaction);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
  Utils.MoveToTransactionDetail = true;
    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    repo1 = Provider.of<TransactionDetailRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    basketRepository = Provider.of<BasketRepository>(context);
    productRepo = Provider.of<ProductRepository>(context);
    final String loginUserId = Utils.checkUserLoginId(valueHolder!);

    return WillPopScope(
        onWillPop: _requestPop,

        child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ProductDetailProvider>(
              lazy: false,
              create: (BuildContext context) {
                productDetailProvider = ProductDetailProvider(
                    repo: productRepo!, psValueHolder: valueHolder);
                return productDetailProvider!;
              },
            ),
            ChangeNotifierProvider<TransactionDetailProvider>(
                lazy: false,
                create: (BuildContext context) {
                  final TransactionDetailProvider provider =
                  TransactionDetailProvider(
                      repo: repo1!, psValueHolder: valueHolder);
                  provider.loadTransactionDetailList(widget.transaction);
                  _transactionDetailProvider = provider;
                  return provider;
                }),
            ChangeNotifierProvider<BasketProvider>(
                lazy: false,
                create: (BuildContext context) {
                  basketProvider = BasketProvider(repo: basketRepository!);
                  basketProvider!.loadBasketList();
                  return basketProvider!;
                }),
          ],
          child: Consumer<TransactionDetailProvider>(builder:
              (BuildContext context, TransactionDetailProvider provider,
                  Widget? child) {
                if (provider.transactionDetailList.data != null &&
                    provider
                        .transactionDetailList.data!.isNotEmpty) {
                  print(provider.transactionDetailList.data!.length);
                  widget.transaction.transStatus =
                      provider.transactionDetailList.data![0].transStatus;

                }

            return Scaffold(
              key: scaffoldKey,
              /*appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness:
                      Utils.getBrightnessForAppBar(context),
                ),
                iconTheme: Theme.of(context)
                    .iconTheme
                    .copyWith(color: PsColors.mainColor),
                title: Text(
                  Utils.getString(context, 'transaction_detail__title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold, color: PsColors.mainColor),
                ),
                elevation: 0,
              ),*/
              body: Stack(children: <Widget>[
                RefreshIndicator(

                  child: CustomScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[

                        SliverToBoxAdapter(
                          child: _OrderStatusWidget(
                              transaction: widget.transaction,
                              valueHolder: valueHolder!,
                              scaffoldKey: scaffoldKey),
                        ),
                        if (widget.transaction.pickAtShop == PsConst.ONE)
                          SliverToBoxAdapter(child: _SelfPickUpWidget())
                        else
                          SliverToBoxAdapter(
                            child: Container(),
                          ),
                        SliverToBoxAdapter(
                          child: _TransactionNoWidget(
                              transaction: widget.transaction,
                              valueHolder: valueHolder!,
                              scaffoldKey: scaffoldKey),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.transactionDetailList.data != null ||
                                  provider
                                      .transactionDetailList.data!.isNotEmpty) {
                                final int count =
                                    provider.transactionDetailList.data!.length;

                                return GestureDetector(
                                  onTap: () {
                                    final ProductDetailIntentHolder
                                    holder =
                                    ProductDetailIntentHolder(
                                      productId: provider.transactionDetailList.data![index].productId,
                                      heroTagImage: provider.hashCode
                                          .toString() +
                                          provider.transactionDetailList.data![index].productId! +
                                          PsConst.HERO_TAG__IMAGE,
                                      heroTagTitle: provider.hashCode
                                          .toString() +
                                          provider.transactionDetailList.data![index].productId! +
                                          PsConst.HERO_TAG__TITLE,
                                      heroTagOriginalPrice: provider
                                          .hashCode
                                          .toString() +
                                          provider.transactionDetailList.data![index].productId! +
                                          PsConst
                                              .HERO_TAG__ORIGINAL_PRICE,
                                      heroTagUnitPrice: provider
                                          .hashCode
                                          .toString() +
                                          provider.transactionDetailList.data![index].productId! +
                                          PsConst
                                              .HERO_TAG__UNIT_PRICE,
                                    );
                                    dashboardViewKey.currentState?.selectedProductDetailHolder = holder;
                                    dashboardViewKey.currentState?.updateSelectedIndexWithAnimation(
                                        Utils.getString(context, 'product_detail__title'),//Utils.getString(context, 'profile__favourite'),
                                        PsConst.REQUEST_CODE__DASHBOARD_PRODUCT_DETAIL_FRAGMENT);

                                  },
                                  child: TransactionItemView(
                                    animationController: animationController!,
                                    animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    transaction: provider.transactionDetailList.data![index],
                                  ),
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount:
                                provider.transactionDetailList.data!.length,
                          ),
                        ),
                        /*if (widget.transaction.refundStatus == PsConst.ONE)
                          SliverToBoxAdapter(
                              child: _RefundButtonWidget(
                            transactionHeader: widget.transaction,
                          ))
                        else*/
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.all(PsDimens.space10),
                              height: 50, 
                              decoration: BoxDecoration(
                                color: PsColors.mainColor,
                                borderRadius: BorderRadius.circular(PsDimens.space10), // Adjust the radius as needed
                                /*border: Border.all(
                                  color: Colors.blue, // Border color
                                  width: 2.0, // Border width
                                ),*/
                              ),
                              child: MaterialButton(
                                onPressed: () async {
                                  showDialog<dynamic>(
                                      context: context,

                                      barrierColor: PsColors.transparent,
                                      builder: (BuildContext context) {
                                        return ConfirmDialogView(
                                            description: Utils.getString(context,
                                                'Are You Sure To Add This Order Into Your Basket?'),
                                            leftButtonText: Utils.getString(
                                                context,
                                                'basket_list__comfirm_dialog_cancel_button'),
                                            rightButtonText: Utils.getString(
                                                context,
                                                'basket_list__comfirm_dialog_ok_button'),
                                            onAgreeTap: () async {
                                              Navigator.pop(context);
                                              PsProgressDialog.showDialog(context);
                                              final List<Basket> listOfBaskets = [];
                                              for (int index = 0; index < provider.transactionDetailList.data!.length; index++) {
                                                final String id =
                                                    '${provider.transactionDetailList
                                                    .data![index].productId}'
                                                /*'${basketSelectedAddOn.getSelectedaddOnIdByHeaderId()}'
                                        '${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}'*/;
                                                /* if (product.minimumOrder == '0') {
                                      product.minimumOrder = '1' ;
                                    }*/List <BasketSelectedAddOn> basketSelectedAddOn = [];
                                                if(provider.transactionDetailList.data![index].productAddonPrice != '') {
                                                  List<String> addOnPriceList =
                                                  provider.transactionDetailList.data![index].productAddonPrice!.split('#');
                                                  List<String>  addOnNameList=
                                                  provider.transactionDetailList.data![index].productAddonName!.split('#');
                                                  List<String> addOnIdList =
                                                  provider.transactionDetailList.data![index].productAddonId!.split('#');
                                                  for (int i = 0; i < addOnPriceList.length; i++) {
                                                    basketSelectedAddOn.add(
                                                        BasketSelectedAddOn(
                                                            id: addOnIdList[i],
                                                            name: addOnNameList[i],
                                                            price: addOnPriceList[i],
                                                            currencySymbol: '£'
                                                        )
                                                    );
                                                  }
                                                }
                                                await productDetailProvider!.loadProduct(
                                                    provider.transactionDetailList.data![index]
                                                        .productId!, loginUserId);
                                                print(productDetailProvider
                                                    ?.productDetail.data!.name);
                                                listOfBaskets.add(
                                                    Basket(
                                                        id: id,
                                                        productId: provider
                                                            .transactionDetailList.data![index]
                                                            .productId,
                                                        qty: provider.transactionDetailList
                                                            .data![index].qty,
                                                        shopId: valueHolder!.shopId,
                                                        //selectedColorId: colorId,
                                                        //selectedColorValue: colorValue,
                                                        basketPrice: provider
                                                            .transactionDetailList.data![index]
                                                            .price,
                                                        basketOriginalPrice: provider
                                                            .transactionDetailList.data![index]
                                                            .originalPrice,
                                                        /*selectedAttributeTotalPrice: basketSelectedAttribute
                                            .getTotalSelectedAttributePrice()
                                            .toString(),*/
                                                        product: productDetailProvider
                                                            ?.productDetail.data!,
                                                        /*basketSelectedAttributeList:
                                        basketSelectedAttribute.getSelectedAttributeList(),*/
                                                        basketSelectedAddOnList:
                                                        basketSelectedAddOn,
                                                    )
                                                );

                                              }
                                              await basketProvider!.addBasketList(listOfBaskets);
                                              PsProgressDialog.dismissDialog();

                                              dashboardViewKey.currentState?.
                                              updateSelectedIndexWithAnimation(Utils.getString(
                                                  context,
                                                  Utils.getString(context, 'home__bottom_app_bar_basket_list')),
                                                  PsConst.REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT);
                                            });
                                      });

                                },
                                child: Text(
                                  'Reorder',
                                  style: TextStyle(
                                    color: PsColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ),
                        /*if (widget.transaction.ratingStatus == PsConst.ONE)
                          SliverToBoxAdapter(
                              child: _ReviewButtonWidget(
                            transaction: widget.transaction,
                          ))
                        else
                          SliverToBoxAdapter(
                            child: Container(),
                          )*/
                      ]),
                  onRefresh: () {
                    return provider.resetTransactionDetailList(widget.transaction);
                    //return widget.provider.resetTransactionList();
                  },
                ),
                PSProgressIndicator(provider.transactionDetailList.status)
              ]),
            );
          }),
        ));
  }
}

class _SelfPickUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.backgroundColor,
      margin: const EdgeInsets.only(top: PsDimens.space8),
      padding: const EdgeInsets.only(
        left: PsDimens.space12,
        right: PsDimens.space12,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: PsDimens.space8,
                right: PsDimens.space12,
                top: PsDimens.space12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      Icon(
                        FontAwesome5.notes_medical,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      Expanded(
                        child: Text(
                            Utils.getString(
                                context, 'transaction_detail__order_type'),
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _TransactionNoTextWidget(
            transationInfoText:
                Utils.getString(context, 'transaction_detail__self_pick_up'),
            title: Utils.getString(context, 'transaction_detail__type') + ' :',
          ),
          const SizedBox(height: PsDimens.space12),
        ],
      ),
    );
  }
}

class _ReviewButtonWidget extends StatelessWidget {
  const _ReviewButtonWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    final TransactionDetailProvider provider =
        Provider.of<TransactionDetailProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(
          left: PsDimens.space18,
          right: PsDimens.space12,
          bottom: PsDimens.space24),
      child: PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'transaction_detail__give_review'),
        onPressed: () async {
          await showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return DeliveryBoyRatingInputDialog(
                  transactionHeader: transaction,
                  transactionDetailProvider: provider,
                );
              });
        },
      ),
    );
  }
}

class _OrderStatusWidget extends StatelessWidget {
  const _OrderStatusWidget({
    Key? key,
    required this.transaction,
    required this.valueHolder,
    this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final PsValueHolder valueHolder;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: PsDimens.space2,
    );
    final Widget _contentCopyIconWidget = IconButton(
      iconSize: PsDimens.space20,
      icon: Icon(
        Icons.content_copy,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: transaction.transCode!));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Tooltip(
            message: Utils.getString(context, 'transaction_detail__copy'),
            child: Text(
              Utils.getString(context, 'transaction_detail__copied_data'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: PsColors.mainColor),
            ),
            showDuration: const Duration(seconds: 5),
          ),
        ));
      },
    );

    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(PsDimens.space8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    Icon(
                      Icons.offline_pin,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    const SizedBox(
                      width: PsDimens.space8,
                    ),
                    Expanded(
                      child: Text(
                          '${Utils.getString(context, 'transaction_detail__trans_no')} : ${transaction.transCode}',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
              //_contentCopyIconWidget,
            ],
          ),
        ),
        _dividerWidget,
        if (transaction.pickAtShop == PsConst.ZERO)
          Column(
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space12,
              ),
              if (transaction.refundStatus != '2')
                _TransactionStatusListWidget(transaction: transaction)
              else
                _RefundedStatusWidget(
                  transaction: transaction,
                ),
              const SizedBox(
                height: PsDimens.space6,
              ),
            ],
          )
        else
          Container()
      ],
    ));
  }
}

class _TransactionStatusListWidget extends StatelessWidget {
  const _TransactionStatusListWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    final TransactionStatusRepository transStatusRepository =
        Provider.of<TransactionStatusRepository>(context);

    return ChangeNotifierProvider<TransactionStatusProvider>(
      lazy: false,
      create: (BuildContext context) {
        final TransactionStatusProvider provider =
            TransactionStatusProvider(repo: transStatusRepository);
        provider.loadTransactionStatusList();
        //print(provider.transactionStatusList.data![0].title);
        //print(provider.transactionStatusList.data![0].title);
        return provider;
      },
      child: Consumer<TransactionStatusProvider>(
        builder: (BuildContext context, TransactionStatusProvider provider,
            Widget? child) {
          return Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space8,
                bottom: PsDimens.space8),
            child: CustomScrollView(
                // controller: _scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (provider.transactionStatusList.data != null ||
                            provider.transactionStatusList.data!.isNotEmpty) {

                          return _ColorCircleWidget(
                            psValueHolder: psValueHolder,
                            statusTitle: provider
                                .transactionStatusList.data![index].title!,
                            statusOrdering: provider
                                .transactionStatusList.data![index].ordering!,
                            transaction: transaction,
                            statusLength:
                                provider.transactionStatusList.data!.length,
                          );
                        } else {
                          return null;
                        }
                      },
                      childCount: provider.transactionStatusList.data!.length,
                    ),
                  ),
                ]),
          );
        },
      ),
    );
  }
}

class _ColorCircleWidget extends StatelessWidget {
  const _ColorCircleWidget({
    Key? key,
    required this.statusTitle,
    required this.statusOrdering,
    required this.transaction,
    required this.statusLength,
    required this.psValueHolder,

  }) : super(key: key);

  final String statusTitle;
  final String statusOrdering;
  final TransactionHeader transaction;
  final int statusLength;
  final PsValueHolder psValueHolder;
  @override
  Widget build(BuildContext context) {
    final Widget _verticalLineWidget = Container(
      color: PsColors.mainColor,
      width: PsDimens.space4,
      height: PsDimens.space24,
    );


    return Container(
      margin:
          const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(
            width: PsDimens.space8,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: PsDimens.space24,
                  height: PsDimens.space24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: transaction.transStatus!.ordering == statusOrdering
                        ? PsColors.mainColor
                        : transaction.transStatus!.ordering != '' &&
                                int.parse(transaction.transStatus!.ordering!) >
                                    int.parse(statusOrdering)
                            ? PsColors.mainColor
                            : Colors.grey[400],
                    // border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: Text(
                    statusOrdering,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight:
                            transaction.transStatus!.ordering == statusOrdering
                                ? FontWeight.bold
                                : FontWeight.normal,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: PsDimens.space8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    statusTitle,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight:
                              transaction.transStatus!.ordering == statusOrdering
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: PsDimens.space8,
                ),
                Visibility(
                    visible: statusLength.toString() != statusOrdering,
                    child: _verticalLineWidget),
                const SizedBox(
                  width: PsDimens.space16,
                ),
                Visibility(
                  visible: statusTitle == transaction.transStatus!.title,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space16, bottom: PsDimens.space16),
                    child: Text(
                      transaction.updatedDate == ''
                          ? ''
                          : Utils.getDateFormat(transaction.updatedDate!,psValueHolder),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key? key,
    required this.transaction,
    required this.valueHolder,
    this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final PsValueHolder valueHolder;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: PsDimens.space2,
    );
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space8,
                  right: PsDimens.space12,
                  top: PsDimens.space12,
                  bottom: PsDimens.space12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Icon(
                          Octicons.note,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Expanded(
                          child: Text(
                              Utils.getString(
                                  context, 'checkout__order_summary'),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _dividerWidget,
            if (transaction.pickAtShop == PsConst.ONE)
              _TransactionNoTextWidget(
                transationInfoText:
                    '${transaction.deliveryPickupDate} ${transaction.deliveryPickupTime}',
                title:
                    '${Utils.getString(context, 'transaction_detail__order_time')} :',
              )
            else
              Container(),
            _TransactionNoTextWidget(
              transationInfoText: transaction.totalItemCount!,
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_count')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.totalItemAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_price')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.discountAmount == '0'
                  ? '-'
                  : '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.discountAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__discount')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.cuponDiscountAmount == '0'
                  ? '-'
                  : '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.cuponDiscountAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__coupon_discount')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.subTotalAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            ),
            /*_TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.taxAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__tax')}(${transaction.taxPercent} %) :',
            ),*/
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.shippingAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'checkout__delivery_cost')} :',
            ),
            /*_TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.calculateShippingTax(transaction.shippingAmount!, transaction.shippingTaxPercent!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_tax')}(${transaction.shippingTaxPercent} %) :',
            ),*/
            const SizedBox(
              height: PsDimens.space12,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: PsColors.discountColor, // Border color
                  width: 2.0,          // Border width
                ),
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.all(PsDimens.space12),
                child:Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${Utils.getString(context, 'transaction_detail__total')} :',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: PsColors.discountColor
                      ),
                    ),
                    Text(
                      '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.balanceAmount!, valueHolder)}' ,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                          color: PsColors.discountColor
                      ),
                    )
                  ],
                ),
              ),
            ),
            /*const SizedBox(
              height: PsDimens.space12,
            ),*/
          ],
        ));
  }
}

class _TransactionNoTextWidget extends StatelessWidget {
  const _TransactionNoTextWidget({
    Key? key,
    required this.transationInfoText,
    this.title,
  }) : super(key: key);

  final String transationInfoText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          top: PsDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}

class _RefundedStatusWidget extends StatelessWidget {
  const _RefundedStatusWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PsDimens.space220,
      height: PsDimens.space40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PsColors.mainLightColor,
        borderRadius: BorderRadius.circular(PsDimens.space12),
        border: Border.all(color: PsColors.mainLightColor),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(Utils.getString(context, 'refund_status_refunded'),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: PsColors.mainColor)),
      ),
    );
  }
}

class _RefundButtonWidget extends StatefulWidget {
  const _RefundButtonWidget({
    required this.transactionHeader,
  });

  final TransactionHeader transactionHeader;

  @override
  __RefundButtonWidgetState createState() => __RefundButtonWidgetState();
}

class __RefundButtonWidgetState extends State<_RefundButtonWidget> {
  PsValueHolder? valueHolder;
  TransactionHeaderRepository? transactionHeaderRepo;
  TransactionHeaderProvider? _provider;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    transactionHeaderRepo = Provider.of<TransactionHeaderRepository>(context);
    final TransactionDetailProvider transactionDetailProvider =
        Provider.of<TransactionDetailProvider>(context, listen: false);

    return ChangeNotifierProvider<TransactionHeaderProvider>(
      lazy: false,
      create: (BuildContext context) {
        final TransactionHeaderProvider transactionHeaderProvider =
            TransactionHeaderProvider(
                repo: transactionHeaderRepo!, psValueHolder: valueHolder!);

        _provider = transactionHeaderProvider;

        return _provider!;
      },
      child: Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
          TransactionHeaderProvider provider, Widget? child) {
        provider = TransactionHeaderProvider(
            repo: transactionHeaderRepo!, psValueHolder: valueHolder!);
        return Container(
          padding: const EdgeInsets.only(
              left: PsDimens.space18,
              right: PsDimens.space12,
              bottom: PsDimens.space24),
         /* child: PSButtonWidget(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'refund_button_refund'),
            onPressed: () async {
              if (widget.transactionHeader.id != '') {
                if (await Utils.checkInternetConnectivity()) {
                  await PsProgressDialog.showDialog(context);

                  final PsResource<TransactionHeader>? _transactionHeader =
                      await provider.postRefund(widget.transactionHeader.id!);

                  if (_transactionHeader != null) {
                    PsProgressDialog.dismissDialog();
                    widget.transactionHeader.refundStatus =
                        _transactionHeader.data?.refundStatus;
                    setState(() {});
                    transactionDetailProvider
                        .resetTransactionDetailList(widget.transactionHeader);
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'success_dialog__refund_success'),
                          );
                        });
                  } else {
                    PsProgressDialog.dismissDialog();
                    print('Fail');
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: Utils.getString(context, 'refund__fail'),
                          );
                        });
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              }
            },
          ),*/
        );
      }),
    );
  }
}

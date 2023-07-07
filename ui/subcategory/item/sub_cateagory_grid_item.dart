import 'package:flutter/material.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/ui/common/ps_ui_widget.dart';
import 'package:flutterrestaurant/viewobject/sub_category.dart';

class SubCategoryGridItem extends StatelessWidget {
  const SubCategoryGridItem(
      {Key? key,
      required this.subCategory,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final SubCategory subCategory;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double> ?animation;
  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
            onTap: onTap as void Function()?,
            child: Card(
                elevation: 0.3,
                child: Container(
                    decoration: BoxDecoration(
                      color: PsColors.black.withAlpha(210),
                      border: Border.all(
                        color: PsColors.mainColor, // Set the desired border color here
                        width: 2, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(10), // Set the desired border radius
                    ),
                    child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: <Widget>[
                            PsNetworkImage(
                              photoKey: '',
                              defaultPhoto: subCategory.defaultPhoto!,
                              width: PsDimens.space200,
                              height: PsDimens.space100,
                              boxfit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: PsDimens.space4,
                            ),
                            Text(
                              subCategory.name!,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: PsColors.white, fontWeight: FontWeight.bold),
                            ),
                            /*Container(
                              width: 200,
                              height: double.infinity,
                              color: PsColors.black.withAlpha(110),
                            )*/
                          ],
                        )),

                  ],
                )))),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child),
          );
        });
  }
}

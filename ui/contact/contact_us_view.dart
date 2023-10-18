import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/common/ps_resource.dart';
import 'package:flutterrestaurant/config/ps_colors.dart';
import 'package:flutterrestaurant/constant/ps_dimens.dart';
import 'package:flutterrestaurant/provider/contact/contact_us_provider.dart';
import 'package:flutterrestaurant/repository/contact_us_repository.dart';
import 'package:flutterrestaurant/ui/common/dialog/error_dialog.dart';
import 'package:flutterrestaurant/ui/common/dialog/success_dialog.dart';
import 'package:flutterrestaurant/ui/common/ps_button_widget.dart';
import 'package:flutterrestaurant/ui/common/ps_textfield_widget.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_status.dart';
import 'package:flutterrestaurant/viewobject/holder/contact_us_holder.dart';
import 'package:provider/provider.dart';

import '../../provider/user/user_provider.dart';
import '../../repository/user_repository.dart';
import '../../viewobject/common/ps_value_holder.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key, required this.animationController, this.userProvider})
      : super(key: key);
  final AnimationController animationController;
  final UserProvider? userProvider;
  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  ContactUsRepository? contactUsRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  UserRepository? userRepository;
  //UserProvider? userProvider;
  PsValueHolder? valueHolder;
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();
    contactUsRepo = Provider.of<ContactUsRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    //userProvider = Provider.of<UserProvider>(context, listen: false);
    valueHolder = Provider.of<PsValueHolder>(context);
    /*if(userProvider!.user.data != null)
      {
        nameController.text = userProvider!.user.data!.userName.toString();
      }*/
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    void checkFields(String text){
      setState(() {
      });
    }
    return MultiProvider(
        providers: [

    ChangeNotifierProvider<ContactUsProvider>(
    lazy: false,
        create: (BuildContext context) {
          final ContactUsProvider contactUsProvide =
          ContactUsProvider(repo: contactUsRepo!);
          return contactUsProvide;
        },
    ),
          /*ChangeNotifierProvider<UserProvider>(
              lazy: false,
              create: (BuildContext context) {
                userProvider = UserProvider(
                    repo: userRepository!, psValueHolder: valueHolder!);
                userProvider!.getUserFromDB(userProvider!.psValueHolder.loginUserId!);

                return userProvider!;
              }),*/
        ],
        child: Consumer<ContactUsProvider>(
          builder:
              (BuildContext context, ContactUsProvider provider, Widget ?child) {
            if(widget.userProvider!.user.data != null) {
              nameController.text = widget.userProvider!.user.data!.userName!;
              emailController.text = widget.userProvider!.user.data!.userEmail!;
              phoneController.text = widget.userProvider!.user.data!.userPhone!;
            }
                return AnimatedBuilder(
                          animation: widget.animationController,
                          child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    PsTextFieldWidget(
                                        isMandatory: true,
                                        titleText: Utils.getString(
                                            context, 'contact_us__contact_name'),
                                        textAboutMe: false,
                                        hintText: Utils.getString(
                                            context, 'contact_us__contact_name_hint'),
                                        borderColor: nameController.text == ''
                                            ? PsColors.discountColor
                                            : PsColors.mainColor,
                                        onChanged: checkFields,
                                        textEditingController: nameController
                                    ),
                                    PsTextFieldWidget(
                                        titleText: Utils.getString(
                                            context, 'contact_us__contact_email'),
                                        isMandatory: true,
                                        textAboutMe: false,
                                        hintText: Utils.getString(
                                            context, 'contact_us__contact_email_hint'),
                                        borderColor: emailController.text == ''
                                            ? PsColors.discountColor
                                            : PsColors.mainColor,
                                        onChanged: checkFields,
                                        textEditingController: emailController),
                                    PsTextFieldWidget(
                                        titleText: Utils.getString(
                                            context, 'contact_us__contact_phone'),
                                        isMandatory: true,
                                        textAboutMe: false,
                                        hintText: Utils.getString(
                                            context, 'contact_us__contact_phone_hint'),
                                        keyboardType: TextInputType.phone,
                                        phoneInputType: true,
                                        borderColor: phoneController.text == ''
                                            ? PsColors.discountColor
                                            : PsColors.mainColor,
                                        onChanged: checkFields,
                                        textEditingController: phoneController),
                                    PsTextFieldWidget(
                                        titleText: Utils.getString(
                                            context, 'contact_us__contact_message'),
                                        isMandatory: true,
                                        textAboutMe: false,
                                        height: PsDimens.space160,
                                        hintText: Utils.getString(
                                            context,
                                            'contact_us__contact_message_hint'),
                                        borderColor: messageController.text == ''
                                            ? PsColors.discountColor
                                            : PsColors.mainColor,
                                        onChanged: checkFields,
                                        textEditingController: messageController),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: PsDimens.space16,
                                          top: PsDimens.space16,
                                          right: PsDimens.space16,
                                          bottom: PsDimens.space40),
                                      child: PsButtonWidget(
                                        provider: provider,
                                        nameText: nameController,
                                        emailText: emailController,
                                        messageText: messageController,
                                        phoneText: phoneController,
                                      ),
                                    ),
                                    _largeSpacingWidget,
                                  ],
                                ),
                              )),
                          builder: (BuildContext context, Widget? child) {
                            return FadeTransition(
                                opacity: animation,
                                child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0, 100 * (1.0 - animation.value), 0.0),
                                  child: child,
                                ));
                          });

              }
        )
    );
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget({
    required this.nameText,
    required this.emailText,
    required this.messageText,
    required this.phoneText,
    required this.provider,
  });

  final TextEditingController nameText, emailText, messageText, phoneText;
  final ContactUsProvider provider;

  @override
  Widget build(BuildContext context) {
    return PSButtonWidget(
        hasShadow: true,
        width: double.infinity,
        titleText: Utils.getString(context, 'contact_us__submit'),
        onPressed: () async {
          if (nameText.text != '' &&
              emailText.text != '' &&
              messageText.text != '' &&
              phoneText.text != '') {
            if (await Utils.checkInternetConnectivity()) {
              final ContactUsParameterHolder contactUsParameterHolder =
                  ContactUsParameterHolder(
                name: nameText.text,
                email: emailText.text,
                message: messageText.text,
                phone: phoneText.text,
              );

              final PsResource<ApiStatus> _apiStatus = await provider
                  .postContactUs(contactUsParameterHolder.toMap());

              if (_apiStatus.data != null) {
                print('Success');
                nameText.clear();
                emailText.clear();
                messageText.clear();
                phoneText.clear();
                showDialog<dynamic>(
                    context: context,
                    barrierColor: PsColors.transparent,
                    builder: (BuildContext context) {
                      if (_apiStatus.data!.status == 'success') {
                        return const SuccessDialog(
                          message: 'Message Delivered',
                        );
                      } else {
                        return ErrorDialog(
                          message: _apiStatus.data!.status,
                        );
                      }
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  barrierColor: PsColors.transparent,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          } else {
            print('Fail');
            showDialog<dynamic>(
                context: context,
                barrierColor: PsColors.transparent,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString(context, 'contact_us__fail'),
                  );
                });
          }
        });
  }
}

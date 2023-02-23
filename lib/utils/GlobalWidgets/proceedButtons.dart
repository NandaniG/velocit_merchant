import 'package:flutter/material.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/textFormFields.dart';
import '../../utils/styles.dart';

/*Widget proceedButton(String name, Color color, BuildContext context,
    bool loading, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          border: Border.all(
            color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
          ),
          color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: color,
        ),
        child: loading
            ? Center(
          child: CircularProgressIndicator(color:color== ThemeApp.tealButtonColor?ThemeApp.whiteColor: ThemeApp.tealButtonColor),
        )
            : Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis,
              color: color== ThemeApp.tealButtonColor?ThemeApp.whiteColor: ThemeApp.whiteColor,
              letterSpacing: -0.25
          ),
        )),
  );
}*/

Widget proceedButton(String name, Color color, BuildContext context,
    bool loading, VoidCallback onTap) {
  return Container( width: MediaQuery.of(context).size.width,
    // padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
    decoration: BoxDecoration(
      // borderRadius: const BorderRadius.all(
      //   Radius.circular(100),
      // ),
      // border: Border.all(
      //   color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
      // ),
      // color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: color,
    ),
    child: ElevatedButton(style:
    ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(color: ThemeApp.tealButtonColor)
          )
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
      foregroundColor: MaterialStateProperty.all<Color>(ThemeApp.appLightColor),
      backgroundColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor),

      // overlayColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor)
    ),
      onPressed: onTap,
      child: Container(
        // width: MediaQuery.of(context).size.width,
        // padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        // decoration: BoxDecoration(
        //   borderRadius: const BorderRadius.all(
        //     Radius.circular(100),
        //   ),
        //   border: Border.all(
        //       color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
        //   ),
        //   color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: color,
        // ),
          child: loading
              ? Center(
            child: CircularProgressIndicator(color:color== ThemeApp.tealButtonColor?ThemeApp.whiteColor: ThemeApp.tealButtonColor),
          )
              : Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
                color: color== ThemeApp.tealButtonColor?ThemeApp.whiteColor: ThemeApp.whiteColor,
                letterSpacing: -0.25
            ),
          )),
    ),
  );
}
Widget inActiveButton(String name, BuildContext context,
 VoidCallback onTap) {
  return Container( width: MediaQuery.of(context).size.width,
    // padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
    decoration: BoxDecoration(
      // borderRadius: const BorderRadius.all(
      //   Radius.circular(100),
      // ),
      // border: Border.all(
      //   color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
      // ),
      // color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: color,
    ),
    child: ElevatedButton(style:
    ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(color: ThemeApp.lightFontColor)
          )
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
      foregroundColor: MaterialStateProperty.all<Color>(ThemeApp.whiteColor),
      backgroundColor: MaterialStateProperty.all<Color>(ThemeApp.lightFontColor),

      // overlayColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor)
    ),
      onPressed: onTap,
      child: Container(

          child:Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
                color: ThemeApp.whiteColor,
                letterSpacing: -0.25
            ),
          )),
    ),
  );
}



Widget whiteProceedButton(String name, BuildContext context, VoidCallback onTap) {

  return InkWell(
    onTap: onTap,
    child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),border: Border.all(color: ThemeApp.darkGreyTab),
          color: ThemeApp.whiteColor,
        ),
        child: TextFieldUtils()
            .usingPassTextFields(name, ThemeApp.blackColor, context)),
  );
}

Widget viewMoreButton(String name, BuildContext context, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
          color: ThemeApp.darkGreyTab,
        ),
        child: TextFieldUtils()
            .usingPassTextFields(name, ThemeApp.whiteColor, context)),
  );
}

Widget kmAwayOnMerchantImage(String name, BuildContext context) {
  return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        color: ThemeApp.textFieldBorderColor,
      ),
      child: TextFieldUtils().homePageTitlesTextFieldsWHITE(name, context));
}

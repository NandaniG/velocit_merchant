import 'package:flutter/material.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/proceedButtons.dart';
import 'package:velocit_merchant/utils/GlobalWidgets/textFormFields.dart';

import '../../utils/styles.dart';

class OkDialog extends StatefulWidget {
  final String text;

  OkDialog({required this.text});

  @override
  State<OkDialog> createState() => _OkDialogState();
}

class _OkDialogState extends State<OkDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: MediaQuery.of(context).size.height-200,
          maxWidth:MediaQuery.of(context).size.width,
        ),
        child: Container(
          alignment: Alignment.topCenter,
          decoration: new BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              color: ThemeApp.innerBoxesColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {},
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.image),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .1,
                      ),
                      TextFieldUtils().dynamicText(
                            'Deliver by OTP',
                            context,
                            TextStyle(
                                color: Colors.grey.shade700,
                                fontSize:
                                    MediaQuery.of(context).size.height * .023,
                                fontWeight: FontWeight.bold)),

                    ]),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

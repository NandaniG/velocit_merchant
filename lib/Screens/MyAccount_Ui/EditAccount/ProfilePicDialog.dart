import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Core/AppConstant/apiMapping.dart';
import '../../../../Core/repository/auth_repository.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:http/http.dart'as http;

import '../../../utils/GlobalWidgets/proceedButtons.dart';
import '../../../utils/GlobalWidgets/textFormFields.dart';
class ProfileImageDialog extends StatefulWidget {

  bool isEditAccount;

  ProfileImageDialog({ required this.isEditAccount});

  @override
  State<ProfileImageDialog> createState() => _ProfileImageDialogState();
}

class _ProfileImageDialogState extends State<ProfileImageDialog> {
  final picker = ImagePicker();

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 280.0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: TextFieldUtils().dynamicText(
                        'Upload image by choosing',
                        context,
                        TextStyle(fontSize: 20))),
                SizedBox(
                  height: 30,
                ),
                proceedButton(
                    'Camera', ThemeApp.tealButtonColor, context, false,
                        () async {
                      var image = await picker.getImage(source: ImageSource.camera);
                      final prefs = await SharedPreferences.getInstance();
                      String imagePath = image!.path;
                      await prefs.setString('profileImagePrefs', imagePath);
                      StringConstant.UserLoginId =
                          (prefs.getString('isUserId')) ?? '';
                      await  prefs.setString('userProfileImagePrefs',imagePath) ;
                      AuthRepository().updateProfileImageApi(
                          File(imagePath), StringConstant.UserLoginId, context, widget.isEditAccount);
                      // setState(() {
                      //   if (widget.isEditAccount == true) {
                      //
                      //     AuthRepository().updateProfileImageApi(
                      //         File(image.path), StringConstant.UserLoginId, context,widget.isEditAccount);
                      //
                      //     Navigator.of(context).pushReplacement(
                      //       MaterialPageRoute(
                      //         builder: (context) => const MyAccountActivity(),
                      //       ),
                      //     );
                      //   } else {
                      //     AuthRepository().updateProfileImageApi(
                      //         File(image.path), StringConstant.UserLoginId,context);
                      //
                      //     Navigator.of(context).pushReplacement(
                      //       MaterialPageRoute(
                      //         builder: (context) => EditAccountActivity(),
                      //       ),
                      //     );
                      //   }
                      // });
                    }),
                SizedBox(
                  height: 20,
                ),
                proceedButton(
                    'Gallery', ThemeApp.tealButtonColor, context, false,
                        () async {
                      final prefs = await SharedPreferences.getInstance();

                      final pickedFile = await picker.getImage(
                        source: ImageSource.gallery,);
                      print(pickedFile!.path.toString());
                      if (pickedFile != null) {
                        await  prefs.setString('userProfileImagePrefs', pickedFile.path) ;
                        await prefs.setString('profileImagePrefs', pickedFile.path);
                        StringConstant.UserLoginId =
                            (prefs.getString('isUserId')) ?? '';
                        AuthRepository().updateProfileImageApi(
                            File(pickedFile.path), StringConstant.UserLoginId, context, widget.isEditAccount);
                        //   if (widget.isEditAccount == true) {
                        //     AuthRepository().updateProfileImageApi(
                        //         File(pickedFile.path), StringConstant.UserLoginId, context);
                        //
                        //     Navigator.of(context).pushReplacement(
                        //       MaterialPageRoute(
                        //         builder: (context) => const MyAccountActivity(),
                        //       ),
                        //     );
                        //   } else {
                        //     AuthRepository().updateProfileImageApi(
                        //         File(pickedFile.path), StringConstant.UserLoginId, context);
                        //
                        //     Navigator.of(context).pushReplacement(
                        //       MaterialPageRoute(
                        //         builder: (context) => EditAccountActivity(),
                        //       ),
                        //     );
                        //   }
                      }

                    }),
              ],
            ),
          ),
        ),
      );
    }
  }
  Directory findRoot(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
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

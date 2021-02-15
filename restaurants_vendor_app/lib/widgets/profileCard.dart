import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_vendor_app/providers/authProvider.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  File _image;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);

    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          authData.getImage().then((image) {
            setState(() {
              _image = image;
            });
            if (image != null) {
              authData.isImgAvailable = true;
            }
          });
        },
        child: Container(
          height: 180,
          width: 180,
          child: Card(
              color: Colors.orange[100],
              child: _image == null
                  ? Center(
                      child: Icon(
                        CupertinoIcons.camera,
                        size: 50,
                        color: Colors.deepOrange,
                      ),
                    )
                  : Image.file(
                      _image,
                      fit: BoxFit.fill,
                    )),
        ),
      ),
    );
  }
}

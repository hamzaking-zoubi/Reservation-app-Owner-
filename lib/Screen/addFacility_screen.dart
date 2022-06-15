import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project24/myThem.dart';
import 'package:project24/provider/facility.dart';
import 'package:provider/provider.dart';
import 'package:project24/Widget/boutton.dart';
import '../Widget/_showErrorDialog.dart';
import '../provider/navigatorBarCange.dart';
import '../provider/photo.dart';

class addFacility extends StatefulWidget {
  static const routeName = "/addFacility";

  @override
  State<StatefulWidget> createState() {
    return addFacilityState();
  }
}

enum ImageType { Camera, Gallery }

class addFacilityState extends State<addFacility> {
  bool isImagePicked = false;
  var facilityType;
  bool _tv = false;
  bool _wifi = false;
  bool _fridge = false;
  bool _coffee_machine = false;
  bool _air_condition = false;
  List<Photo>? listImage;
  List<Photo>? updateAddImage;
  bool? isInitCheeek;
  bool updateAddImageToList = false;

  late TextEditingController _titleTextEditingController;
  late TextEditingController _descriptionTextEditingController;
  late TextEditingController _locationTextEditingController;
  late TextEditingController _numberGuestsTextEditingController;
  late TextEditingController _numberRoomsTextEditingController;
  late TextEditingController _costTextEditingController;

  final ImagePicker _picker = ImagePicker();
  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  var _editedFacility = Facility(
      id: ' ',
      title: '',
      description: '',
      location: '',
      listImage: [],
      type: '',
      cost: 0.0,
      numberGuests: 0,
      numberRooms: 0,
      wifi: false,
      tv: false,
      fridge: false,
      rate: 0,
      coffee_machine: false,
      air_condition: false);
  var _isInit = true;
  var _isLoading = false;

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _descriptionTextEditingController.dispose();
    _locationTextEditingController.dispose();
    _numberGuestsTextEditingController.dispose();
    _numberRoomsTextEditingController.dispose();
    _costTextEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      isInitCheeek = true;
      listImage = [];
      updateAddImage = [];
      _titleTextEditingController = TextEditingController();
      _descriptionTextEditingController = TextEditingController();
      _locationTextEditingController = TextEditingController();
      _numberGuestsTextEditingController = TextEditingController();
      _numberRoomsTextEditingController = TextEditingController();
      _costTextEditingController = TextEditingController();
      final String? productId =
          ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedFacility =
            Provider.of<Facilities>(context, listen: false).findById(productId);
        listImage = _editedFacility.listImage;
        isImagePicked = true;
        facilityType = _editedFacility.type;
        _tv = _editedFacility.tv;
        _fridge = _editedFacility.fridge;
        _coffee_machine = _editedFacility.coffee_machine;
        _air_condition = _editedFacility.air_condition;
        _wifi = _editedFacility.wifi;
        _titleTextEditingController.text = _editedFacility.title;
        _descriptionTextEditingController.text = _editedFacility.description;
        _locationTextEditingController.text = _editedFacility.location;
        _numberGuestsTextEditingController.text =
            _editedFacility.numberGuests.toString();
        _numberRoomsTextEditingController.text =
            _editedFacility.numberRooms.toString();
        _costTextEditingController.text = _editedFacility.cost.toString();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm(context) async {
    isInitCheeek = false;
    setState(() {});

    if (_errorTitle != null ||
        _errorNumberGuests != null ||
        _errorNumberRooms != null ||
        _errorLocation != null ||
        _errorDescription != null ||
        _errorCost != null) {
      print("====================qqqq1q====================");
      return;
    } else if (listImage!.isEmpty ||
        facilityType == '' ||
        facilityType == null ||
        facilityType.length == 0) {
      print("====================qqqqq2====================");
      _showDialog();
      return;
    } else {
      print("====================qqqqq3====================");
      setState(() {
        _isLoading = true;
      });
      try {
        print("====================/////====================");

        print("tv:${_tv}");
        print("_fridge:${_fridge}");
        print("_coffee_machine:${_coffee_machine}");
        print("_air_condition:${_air_condition}");
        print("title:${_titleTextEditingController.text}");
        print("cost:${_costTextEditingController.text}");
        print("description:${_descriptionTextEditingController.text}");
        print("type:${facilityType}");
        print("numberGuests:${_numberGuestsTextEditingController.text}");
        print("numberRooms:${_numberRoomsTextEditingController.text}");
        print("location:${_locationTextEditingController.text}");
        print("wifi:${_wifi}");
        listImage!.forEach((element) {
          print(element.path_photo);
        });
        print("=================1====================");

        print("=================2====================");

        //Update
        if (_editedFacility.id != ' ' && _editedFacility.id != null) {
          print("=================3====================");
          _editedFacility = Facility(
              title: _titleTextEditingController.text,
              cost: double.parse(_costTextEditingController.text),
              description: _descriptionTextEditingController.text,
              listImage: listImage!,
              id_user: _editedFacility.id_user,
              id: _editedFacility.id,
              location: _locationTextEditingController.text,
              type: facilityType,
              numberGuests: int.parse(_numberGuestsTextEditingController.text),
              numberRooms: int.parse(_numberRoomsTextEditingController.text),
              wifi: _wifi,
              tv: _tv,
              fridge: _fridge,
              coffee_machine: _coffee_machine,
              air_condition: _air_condition);
          await Provider.of<Facilities>(context, listen: false)
              .updateFacility(_editedFacility, _editedFacility.id)
              .catchError((error) {
            print("--------------------------------------------------------");
            print("${error}");
            print("---------------------------------------------------------");
            showErrorDialog(error,context);

          }).then((value) {
            setState(() {
              _isLoading = false;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MainWidget.routeName, (Route<dynamic> route) => false);
            });
          });
        } else {
          _editedFacility = Facility(
              title: _titleTextEditingController.text,
              cost: double.parse(_costTextEditingController.text),
              description: _descriptionTextEditingController.text,
              listImage: listImage!,
              id: " ",
              id_user: " ",
              location: _locationTextEditingController.text,
              type: facilityType,
              numberGuests: int.parse(_numberGuestsTextEditingController.text),
              numberRooms: int.parse(_numberRoomsTextEditingController.text),
              wifi: _wifi,
              tv: _tv,
              fridge: _fridge,
              coffee_machine: _coffee_machine,
              air_condition: _air_condition);
          print(
              "==============================4=============******************************");

          await Provider.of<Facilities>(context, listen: false)
              .addFacility(_editedFacility)
              .catchError((error) {
            showErrorDialog(error,context);
          }).then((value) {
            setState(() {
              _isLoading = false;
              Provider.of<NavigatorBarChange>(context, listen: false)
                  .currentTab = 2;
            });
          });
        }
      } catch (error) {
        print(error);
      } finally {
        setState(() {
          _isLoading = false;
        });
//          Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("add Facility"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm(context);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: deviceSize / 10,
                  ),
                  FormF(),
                  SizedBox(
                    height: 25,
                  ),
                  radioGroup(),
                  SizedBox(
                    height: 25,
                  ),
                  checkBox(),
                  SizedBox(
                    height: 25,
                  ),
                  if (!isImagePicked /*&& listImage!.isEmpty*/)
                    addImageIcon(),
                  if (isImagePicked)
                    ImageList(),
                  SizedBox(
                    height: 10,
                  ),
                  if (_editedFacility.id != ' ' /* && listImage!.isNotEmpty*/)
                    Container(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Text("add Image",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.white, fontSize: 19.5)),
                          ),
                          onPressed: () async {
                            updateAddImageToList = true;
                            addImageButton();

                          }),
                    ),
                  SizedBox(height:10 ,),
                  if (_editedFacility.id != ' ' &&
                     /* listImage!.isNotEmpty &&*/
                      updateAddImage!.isNotEmpty)
                    Container(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              primary: Theme.of(context).primaryColor,
                            ),
                            child: Center(child: Text("upload new Image")),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              updateAddImageToList = false;
                              // addImageButton();
                              print("update ${updateAddImage!.length}");
                              print("listimage ${listImage!.length}");

                              await Provider.of<Facilities>(context,
                                      listen: false)
                                  .addImage(_editedFacility.id, updateAddImage)
                                  .catchError((error) {
                                print("--------------------------");
                                print(error);
                                showErrorDialog(error,context);
                                print("--------------------------");
                              }).then((value) {
                                listImage!.addAll(updateAddImage!);
                                updateAddImage!.clear();
                              });
                              setState(() {
                                _isLoading = false;

                              });
                            })),
                  SizedBox(height:10 ,)
                ],
              ),
            ),
    );
  }

  Widget FormF() {
    return Column(
      children: [
        TextField(
            controller: _titleTextEditingController,
            autofocus: true,
            onChanged: (val) {
//              setState(() {
//
//              });
            },
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1)),
              label: Text("Title"),
              hintText: "Enter  title",
              //  errorText: _validateTitle ? 'Please enter title.' : null,
              errorText: isInitCheeek == true ? null : _errorTitle,
            )),
        SizedBox(
          height: 15,
        ),
        TextField(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            controller: _locationTextEditingController,
            onChanged: (val) {
//             setState(() {
//
//             });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1)),
              label: Text("Location"),
              errorText: isInitCheeek == true ? null : _errorLocation,
              // errorText: _validateLocation ? "Please provide a value." : null,
              hintText: 'Enter Location',
            )),
        SizedBox(
          height: 15,
        ),
        TextField(
            keyboardType: TextInputType.number,
            //   focusNode: _priceFocusNode,
            textInputAction: TextInputAction.next,
            controller: _costTextEditingController,
            onChanged: (val) {
//              setState(() {
//
//              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1)),
              label: Text("Cost in Day"),
              //errorText: _validateCost ? "enter valid Number" : null,
              errorText: isInitCheeek == true ? null : _errorCost,
              hintText: 'Enter Price in Day',
            )),
        SizedBox(
          height: 15,
        ),
        TextField(
            keyboardType: TextInputType.number,
//                focusNode: _numberRoomsFocusNode,
            textInputAction: TextInputAction.next,
            controller: _numberRoomsTextEditingController,
            onChanged: (val) {
//              setState(() {
//
//              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1)),
              label: Text("number Rooms"),
              //errorText: _validateNumberRooms ? "enter valid Number" : null,
              errorText: isInitCheeek == true ? null : _errorNumberRooms,
              hintText: 'Enter numberRooms',
            )),
        SizedBox(
          height: 15,
        ),
        TextField(
            keyboardType: TextInputType.number,
            // focusNode: _numberGuestsFocusNode,
            textInputAction: TextInputAction.next,
            controller: _numberGuestsTextEditingController,
            onChanged: (val) {
//              setState(() {
//
//              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(width: 1)),
              label: Text("number Guests"),
              // errorText: _validateNumberGuests ? "enter valid Number" : null,
              errorText: isInitCheeek == true ? null : _errorNumberGuests,
              hintText: 'Enter number Guests',
            )),
        SizedBox(
          height: 15,
        ),
        TextField(
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          controller: _descriptionTextEditingController,
          onChanged: (val) {
//            setState(() {
//
//            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1)),
            label: Text("Description"),
            errorText: isInitCheeek == true ? null : _errorDescription,
            //_validateDescription ? "enter valid Description" : null,
            hintText: 'Enter Description',
          ),
        ),
      ],
    );
  }

  String? get _errorTitle {
    final text = _titleTextEditingController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    if (text.length > 45) {
      return 'Too long';
    }
    return null;
  }

  String? get _errorDescription {
    final text = _descriptionTextEditingController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 20) {
      return 'Too short';
    }
    if (text.length > 700) {
      return 'Too long';
    }
    return null;
  }

  String? get _errorLocation {
    final text = _locationTextEditingController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 3) {
      return 'Too short';
    }
    if (text.length > 50) {
      return 'Too long';
    }
    return null;
  }

  String? get _errorNumberRooms {
    final text = _numberRoomsTextEditingController.value.text;
    if (text.isEmpty) {
      return 'Please enter a number Rooms.';
    }
    if (int.tryParse(text) == null) {
      return 'Please enter a valid number.';
    }
    if (int.parse(text) <= 0) {
      return 'Please enter a number greater than zero.';
    }
    if (int.parse(text) < 1 || int.parse(text) > 100) {
      return 'Please enter a number between 1 an 100.';
    }
    if (text.length > 6) {
      return 'Please enter a valid number.';
    }
    return null;
  }

  String? get _errorNumberGuests {
    final text = _numberGuestsTextEditingController.value.text;
    if (text.isEmpty) {
      return 'Please enter a number Guests.';
    }
    if (int.tryParse(text) == null) {
      return 'Please enter a valid number.';
    }
    if (int.parse(text) <= 0) {
      return 'Please enter a number greater than zero.';
    }
    if (int.parse(text) < 1 || int.parse(text) > 100) {
      return 'Please enter a number between 1 an 100.';
    }
    if (text.length > 6) {
      return 'Please enter a valid number.';
    }

    return null;
  }

  String? get _errorCost {
    final text = _costTextEditingController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (double.tryParse(text) == null) {
      return 'Please enter a valid number.';
    }
    if (double.parse(text) <= 0) {
      return 'Please enter a number greater than zero.';
    }
    if (double.parse(text) < 10 || double.parse(text) > 1000) {
      return 'Please enter a number between 10 an 10000.';
    }
    if (text.length > 6) {
      return 'Please enter a valid number.';
    }
    return null;
  }

  Widget checkBox() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(" Properties of the Facility",
                    style: Theme.of(context).textTheme.headline6
                  //.copyWith(color: Colors.black87, fontSize: 18.0),
                ),
              ],
            ),
          ),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.tv,color:Theme.of(context).primaryColor ),
              title: Text("TV",style: Theme.of(context).textTheme.subtitle1),
              value: _tv,
              activeColor: ThemeData().primaryColor,
              onChanged: (valu) {
                setState(() {
                  _tv = valu!;
                });
              }),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.filter_center_focus,color:Theme.of(context).primaryColor ),
              title: Text("Fridge",style: Theme.of(context).textTheme.subtitle1),
              activeColor: ThemeData().primaryColor,
              value: _fridge,
              onChanged: (valu) {
                setState(() {
                  _fridge = valu!;
                });
              }),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.coffee,color:Theme.of(context).primaryColor),
              title: Text("Coffee-Machine",style: Theme.of(context).textTheme.subtitle1),
              activeColor: ThemeData().primaryColor,
              value: _coffee_machine,
              onChanged: (valu) {
                setState(() {
                  _coffee_machine = valu!;
                  print(_coffee_machine);
                });
              }),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.air,color:Theme.of(context).primaryColor ),
              title: Text("Air-Condition",style: Theme.of(context).textTheme.subtitle1),
              activeColor: ThemeData().primaryColor,
              value: _air_condition,
              onChanged: (valu) {
                setState(() {
                  _air_condition = valu!;
                });
              }),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.wifi,color:Theme.of(context).primaryColor ),
              title: Text("Wi-Fi",style: Theme.of(context).textTheme.subtitle1),
              activeColor: ThemeData().primaryColor,
              value: _wifi,
              onChanged: (valu) {
                setState(() {
                  _wifi = valu!;
                });
              }),
        ],
      ),
    );
  }

  Widget radioGroup() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(" Type of the Facility",
                    style: Theme.of(context).textTheme.headline6
                    //.copyWith(color: Colors.black87, fontSize: 18.0),
                    ),
              ],
            ),
          ),
          RadioListTile(
              secondary: Icon(Icons.chalet,color:Theme.of(context).primaryColor ,),
              activeColor: Theme.of(context).accentColor,
              selected: facilityType == "chalet" ? true : false,
              title: Text('Chalet',style: Theme.of(context).textTheme.subtitle1 ,
                ),
            
              value: "chalet",
              groupValue: facilityType,
              onChanged: (val) {
                setState(() {
                  facilityType = val;
                  print(facilityType);
                });
              }),
          RadioListTile(
              secondary: Icon(Icons.hotel,color:Theme.of(context).primaryColor ,),
                      activeColor: Theme.of(context).accentColor,
              selected: facilityType == "hostel" ? true : false,
              title: Text('Hostel',style: Theme.of(context).textTheme.subtitle1 ),
              value: "hostel",
              groupValue: facilityType,
              onChanged: (val) {
                setState(() {
                  facilityType = val;
                  print(facilityType);
                });
              }),
          RadioListTile(
              secondary: Icon(Icons.grass,color:Theme.of(context).primaryColor ,),
              activeColor: Theme.of(context).accentColor,
              selected: facilityType == "farmer" ? true : false,
              title: Text('Resort',style: Theme.of(context).textTheme.subtitle1 ),
              value: "farmer",
              groupValue: facilityType,
              onChanged: (val) {
                setState(() {
                  facilityType = val;
                  print(facilityType);
                });
              }),
        ],
      ),
    );
  }

  Widget addImageIcon() {
    return InkWell(
      onTap: () {
        addImageButton();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1),
        ),
        height: 250,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'add Image',
              style:
              Theme.of(context).textTheme.headline4
              //TextStyle(fontSize: 17),
            ),
            Icon(Icons.add,color:Theme.of(context).primaryColor  ,size: 120),
          ],
        ),
      ),
    );
  }

  Widget ImageList() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listImage!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are you want delete this Image"),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            if ((_editedFacility.id != ' ' ||
                                    _editedFacility.id != null) &&
                                _editedFacility.listImage.length > 0) {
                              await Provider.of<Facilities>(context,
                                      listen: false)
                                  .deleteOneImage(
                                      _editedFacility.id, listImage![i].id)
                                  .catchError((error) {
                                /// Navigator.of(context).pop();
                                showErrorDialog(error,context);

                              }).then((_) {
                                print("delete Image web ");

                                setState(() {
                                  if (listImage!.isEmpty) {
                                    isImagePicked = false;
                                  }
                                });
                                Navigator.of(context).pop();
                                //  Navigator.of(context).pop();
                              });
                            } else {
                              if (listImage!.isNotEmpty)
                                listImage!.removeAt(i);
                              print("delete Image add ");
                              setState(() {
                                if (listImage!.isEmpty) {
                                  isImagePicked = false;
                                }
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('oky'),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("No"))
                      ],
                    );
                  });
            },
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      //color: MyTheme.kPrimaryColor
                    ),
                  ),
                  child: Card(
                    child: listImage![i].id == ' '
                        ? Image.file(
                            File(listImage![i].path_photo),
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            Facilities.ApI + "${listImage![i].path_photo}",
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _showDialog() {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(" An error occurred"),
              content: listImage!.isEmpty
                  ? Text("Select Image")
                  : Text("Select Facility type"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Okay"))
              ],
            ));
  }



  uploadImage(imageType) async {
    try {
      if (ImageType.Gallery == imageType) {
        var pickedfiles = await _picker.pickMultiImage();
        if (pickedfiles != null) {
          // addListImage!.addAll(pickedfiles);
          pickedfiles.forEach((element) {
            print("/*/*/*//**/**/*/*/*/*/*//*/**//*/*/*/**/**//*/**/");
            if (_editedFacility.id != ' ' && updateAddImageToList) {
              updateAddImage!.add(new Photo(path_photo: element.path));
            } else
              listImage!.add(new Photo(path_photo: element.path));

            print(element.path);
            print("/*/*/*//**/**/*/*/*/*/*//*/**//*/*/*/**/**//*/**/");
          });
          isImagePicked = true;
          setState(() {});
        } else {
          print("No image is selected.");
        }
      } else if (ImageType.Camera == imageType) {
        final XFile? pickedfiles =
            await _picker.pickImage(source: ImageSource.camera);
        if (pickedfiles != null) {
          //  addListImage!.add(pickedfiles);
          //if(_editedFacility.id!=' ')
          if (_editedFacility.id != ' ' && updateAddImageToList) {
            updateAddImage!.add(new Photo(path_photo: pickedfiles.path));
          } else
            listImage!.add(new Photo(path_photo: pickedfiles.path));
          isImagePicked = true;
          setState(() {});
        } else {
          print("No image is selected.");
        }
      }
    } catch (e) {
      print("error while picking file.");
      print(e);
    } finally {}
  }

  addImageButton() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(width: 1)),
            title: Text(
              'Please Choose Image',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 90,
                width: 160,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        uploadImage(ImageType.Gallery);

                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(
                              Icons.photo_outlined,
                              size: 25,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('From Gallery',
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        uploadImage(ImageType.Camera);
                      },
                      child: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera,
                                size: 25,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("From Camera",
                                  style: TextStyle(fontSize: 20)),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/screen/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:donation_nature/screen/location_list.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({Key? key}) : super(key: key);

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  //PickedFile? _image;
  final ImagePicker _picker = ImagePicker();

  List<String> locationGuList = [];
  String? _selectedDo = null;
  String? _selectedGu = null;
  //서울 부산만 있음
  List<String> disasterList = [
    "가뭄",
    "폭염",
    "홍수",
    "태풍",
    "호우",
    "강풍",
  ];

  int selectedIndex = -1;
  var _editedPost = Post(
    title: '',
    writer: '',
    date: null,
    content: '',
    locationSiDo: '',
    locationGuGunSi: '',
    tagDisaster: '', // 재난 태그
    tagMore: '', // 그 외 태그
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("글쓰기"),
          ),
          body: postForm()),
    );
  }

  Form postForm() {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleForm(),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputChip(
                  backgroundColor: Color(0xff9fc3a8),
                  label: Text("위치"),
                ),
                locationDropdown(),
              ],
            ),
            contentForm(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer),
                      SizedBox(width: 10),
                      Text("재난 태그: ")
                    ],
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: disasterChips()),
            ),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            Center(
              child: uploadImage(),
            ),
            Center(child: uploadButton())
          ],
        ),
      ),
    );
  }

  Row locationDropdown() {
    return Row(
      children: [
        Container(
          width: 100,
          child: DropdownButton(
            hint: Text("시/도"),
            value: _selectedDo,
            isExpanded: true,
            items: locationDoList.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (dynamic value) {
              if (value == '서울') {
                locationGuList = locationGuSeoulList;
              } else if (value == '부산') {
                locationGuList = locationGuBusanList;
              } else if (value == '대구') {
                locationGuList = locationGuDaeguList;
              } else if (value == '인천') {
                locationGuList = locationGuIncheonList;
              } else if (value == '광주') {
                locationGuList = locationGuGwangjuList;
              } else if (value == '대전') {
                locationGuList = locationGuDaejeonList;
              } else if (value == '울산') {
                locationGuList = locationGuUlsanList;
              } else if (value == '세종') {
                locationGuList = locationGuSejongList;
                //전체로만
              } else if (value == '경기') {
                locationGuList = locationSiGyeonggiList;
              } else if (value == '강원') {
                locationGuList = locationSiGangwonList;
              } else if (value == '충북') {
                locationGuList = locationSiChungbukList;
              } else if (value == '충남') {
                locationGuList = locationSiChungnamList;
              } else if (value == '전북') {
                locationGuList = locationSiJeonbukList;
              } else if (value == '전남') {
                locationGuList = locationSiJeonnamList;
              } else if (value == '경북') {
                locationGuList = locationSiGyeongbukList;
              } else if (value == '경남') {
                locationGuList = locationSiGyeongnamList;
              } else if (value == '제주') {
                locationGuList = locationSiJejuList;
              }
              setState(() {
                _selectedDo = value;
                _selectedGu = null;
                _editedPost.locationSiDo = _selectedDo;
              });
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 100,
          child: DropdownButton(
            hint: Text("구/군/시"),
            value: _selectedGu,
            isExpanded: true,
            items: locationGuList.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _selectedGu = value;

                _editedPost.locationGuGunSi = _selectedGu;
              });
            },
          ),
        ),
      ],
    );
  }

  GestureDetector uploadImage() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                children: [
                  SimpleDialogOption(
                    onPressed: () async {
                      // Future getImageFromCam() async {
                      //   //카메라에서 가져오기
                      //   var image = await ImagePicker.platform
                      //       .pickImage(source: ImageSource.camera);
                      //   setState(() {
                      //     _image = image!;
                      //   });
                      // }
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.photo_camera),
                        SizedBox(
                          width: 8,
                        ),
                        Text("카메라에서 가져오기")
                      ],
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      // Future getImageFromGallery() async {
                      //   //갤러리에서 가져오기
                      //   var image = await ImagePicker.platform
                      //       .pickImage(source: ImageSource.gallery);
                      //   setState(() {
                      //     _image = image!;
                      //   });
                      // }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        SizedBox(
                          width: 8,
                        ),
                        Text("갤러리에서 가져오기")
                      ],
                    ),
                  )
                ],
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 80,
        width: 80,
        child: Center(child: Icon(Icons.add_to_photos)),
      ),
    );
  }

  TextFormField titleForm() {
    return TextFormField(
      controller: titleEditingController,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: '제목을 입력하세요',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      validator: (String? val) {
        if (val!.isEmpty) {
          return "제목은 비워둘 수 없습니다";
        }
      },
    );
  }

  TextFormField contentForm() {
    return TextFormField(
      controller: contentEditingController,
      maxLines: 20,
      validator: (String? val) {
        if (val!.isEmpty) {
          return "내용은 비워둘 수 없습니다";
        }
      },
      decoration: InputDecoration(
        hintText: '내용을 입력하세요',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  ElevatedButton uploadButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate() &&
              selectedIndex != -1 &&
              (_editedPost.locationSiDo != null ||
                  _editedPost.locationGuGunSi != null)) {
            //validation 성공하면 폼 저장하기
            _formkey.currentState!.save();
            addPost();
          } else if (_formkey.currentState!.validate() && selectedIndex == -1) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('재난태그 지정필요')));
          } else if (_formkey.currentState!.validate() &&
              selectedIndex != -1 &&
              _editedPost.locationSiDo == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('위치태그 지정필요')));
          }
        },
        style: ElevatedButton.styleFrom(primary: Color(0xff9fc3a8)),
        child: Text("글쓰기"));
  }

  List<Widget> disasterChips() {
    List<Widget> chips = [];
    for (int i = 0; i < disasterList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          backgroundColor: Color(0xff9fc3a8),
          selectedColor: Color.fromARGB(255, 7, 65, 29),
          selected: selectedIndex == i,
          onSelected: (bool value) {
            setState(() {
              selectedIndex = i;
              _editedPost.tagDisaster = disasterList[selectedIndex];
            });
          },
          label: Text(
            disasterList[i],
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  void addPost() {
    PostService _postService = PostService();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("게시글을 등록하시겠습니까?"),
          actions: [
            FlatButton(
                onPressed: () {
                  // _editedPost = Post(
                  //   content: contentEditingController.text,
                  //   title: titleEditingController.text,
                  // );
                  _editedPost.date = Timestamp.now();
                  DateTime datetime = _editedPost.date!.toDate();
                  _editedPost.content = contentEditingController.text;
                  _editedPost.title = titleEditingController.text;
                  print("date " + _editedPost.date.toString());
                  print("datetime " + datetime.toString());
                  _editedPost.date = Timestamp.now();
                  print("시/도: " + _editedPost.locationSiDo!);
                  print("구: " + _editedPost.locationGuGunSi!);
                  print(_editedPost.tagDisaster);
                  print(_editedPost.title! + ' ' + _editedPost.content!);

                  // Firebase 연동
                  _postService.createPost(_editedPost.toJson());

                  //저장되었습니다 스낵바 띄우기
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('저장되었습니다')));

//네비게이터
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoardScreen(),
                      )).then((value) {
                    setState(() {});
                  });

                  // Navigator.of(context).pop();
                },
                child: Text("예")),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("아니오"))
          ],
        );
      },
    );
  }
}

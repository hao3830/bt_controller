import 'package:bluetooth_control_path/constants/create_profile_keys.dart';
import 'package:bluetooth_control_path/db/db.dart';
import 'package:bluetooth_control_path/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateProfile extends StatefulWidget {
  static const String name = 'create_profile';

  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProifileState createState() => _CreateProifileState();
}

class _CreateProifileState extends State<CreateProfile> {
  MyDatabase db = MyDatabase(
      name: "Profiles",
      path: r"D:\project_flutter\bluetooth_control_pad\lib\db\profile.db");

  String profileName = "None",
      left = 'left',
      right = 'right',
      up = 'up',
      down = 'down';

  Future<void> sumbit() async {
    await db.init();

    CreateProfileKeys prefsKeys = CreateProfileKeys(
        profileName: profileName, left: left, right: right, up: up, down: down);

    await db.createProfile(prefsKeys);
    // Profile.profiles
    List<Map> resList = await db.getAllProfiles("Profiles");

    setState(() {
      Profile.profiles = [...Profile.profiles, ...resList];
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Profile()),
      (Route<dynamic> route) => false,
    ).then((value) => setState(() {}));
  }

  void _init() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Create Profile')),
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        heightFactor: 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                  color: Colors.grey[300],
                ),
                child: TextField(
                  onChanged: (value) => profileName = value,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.book,
                        size: 20,
                        color: Colors.blue,
                      ),
                      hintText: "Enter name of profile"),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                  color: Colors.grey[300],
                ),
                child: TextField(
                  onChanged: (value) => left = value,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.arrow_circle_left_outlined,
                        color: Colors.blue,
                      ),
                      hintText: "Enter left button"),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                  color: Colors.grey[300],
                ),
                child: TextField(
                  onChanged: (value) => right = value,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.blue,
                      ),
                      hintText: "Enter right button"),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),

                  color: Colors.grey[300],
                ),
                child: TextField(
                  onChanged: (value) => up = value,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.arrow_circle_up_outlined,
                        color: Colors.blue,
                      ),
                      hintText: "Enter top button"),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                  color: Colors.grey[300],
                ),
                child: TextField(
                  onChanged: (value) => down = value,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.arrow_circle_down_outlined,
                        color: Colors.blue,
                      ),
                      hintText: "Enter bottom button"),
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue),
                  color: Colors.blue[300],
                ),
                child: TextButton(
                    onPressed: sumbit,
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 17),
                    ),
                    child: const Text('Submit')))
          ],
        ),
      ),
    );
  }
}

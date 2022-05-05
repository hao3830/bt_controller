import 'package:bluetooth_control_path/constants/create_profile_keys.dart';
import 'package:bluetooth_control_path/constants/constant.dart';
import 'package:bluetooth_control_path/db/db.dart';
import 'package:bluetooth_control_path/screens/control_pad_page.dart';
import 'package:bluetooth_control_path/screens/create_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static const String name = 'profile_page';
  static List<Map> profiles = [];
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MyDatabase db = MyDatabase(
      name: "Profiles",
      path: r"D:\project_flutter\bluetooth_control_pad\lib\db\profile.db");

  Future<void> init() async {
    await db.init();

    List<Map> resList = await db.getAllProfiles("Profiles");

    setState(() {
      Profile.profiles = [...resList];
    });
  }

  Widget buidProfile(Map profile, int index) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              spreadRadius: 2,
              offset: Offset(0, 1))
        ],
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Name of profile:",
              style: TextStyle(fontSize: 13),
            ),
            Text(
              profile['name'],
              style: const TextStyle(fontSize: 15, color: Colors.blue),
            ),
          ],
        ),
        trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Index:",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                index.toString(),
                style: const TextStyle(fontSize: 17, color: Colors.blue),
              ),
            ]),
        onTap: () {
          CreateProfileKeys(
              left: profile['left'],
              right: profile['right'],
              up: profile['top'],
              down: profile['bottom']);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ControlPadPage(
                      device: AppConstants.device,
                    )),
            (Route<dynamic> route) => false,
          ).then((value) => setState(() {}));
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Delete profile"),
              content: const Text("Are you sure?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    init();
                    db.deleteProfile(profile['id']);
                    setState(() {
                      Profile.profiles.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProfiles(profiles) {
    // ignore: unrelated_type_equality_checks
    if (profiles.isNotEmpty != 0) {
      return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            return buidProfile(profiles[index], index);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: AppBar(title: const Text('Profiles')),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(10.0),
                            primary: Colors.white,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateProfile()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text('Create Profile'),
                        ),
                      ])),
                  buildProfiles(Profile.profiles),
                ]))));
  }
}

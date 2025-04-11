import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get_your_fit/modules/home/controller/home.controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resume Matcher',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.redAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 40),

            MaterialButton(
              onPressed: () => homeController.pickFile(),
              visualDensity: VisualDensity.compact,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.zero,
              minWidth: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Text("Pick Resume(PDF)")),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                setState(() {
                  homeController.jobDescription = text;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter Job Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () => homeController.matchResume(),
              visualDensity: VisualDensity.compact,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.zero,
              minWidth: 0,
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                  child: Text("Match Resume")),
            ),
            SizedBox(height: 20),
            GetBuilder<HomeController>(
              init: homeController,
              builder: (_) {
                return Text(homeController.result, textAlign: TextAlign.center);
              },
            ),
          ],
        ),
      ),
    );
  }
}

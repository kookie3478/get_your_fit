import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;


class HomeController extends GetxController{

  File? selectedFile;
  String jobDescription = "";
  String result = "";



  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      selectedFile = File(result.files.single.path!);
    }
  }

  Future<void> matchResume() async {
    try {
      print("Preparing request...");
      if (selectedFile != null && jobDescription.isNotEmpty) {
        var request = http.MultipartRequest(
            'POST', Uri.parse('http://172.16.112.29/match'));
        request.files.add(
            await http.MultipartFile.fromPath('resume', selectedFile!.path));
        request.fields['jd'] = jobDescription;

        print("Sending request...");
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print("Response received: $responseBody");

        var data = jsonDecode(responseBody);
        result = "Match Score: ${data['score']}%\nFeedback: ${data['feedback']}";
      } else {
        result = "Please upload a resume and provide job description.";
      }
    } catch (e) {
      result = "Error occurred: $e";
      print("ERROR: $e");
    }

    update();
  }


}
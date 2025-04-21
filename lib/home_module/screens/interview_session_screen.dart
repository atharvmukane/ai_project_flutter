// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:localstorage/localstorage.dart';
import 'package:project_interview/colors.dart';
import 'package:project_interview/commonWidgets/asset_svg_icon.dart';
import 'package:project_interview/commonWidgets/custom_button.dart';
import 'package:project_interview/commonWidgets/custom_cancel_button.dart';
import 'package:project_interview/commonWidgets/gradient_widget.dart';
import 'package:project_interview/home_module/providers/home_provider.dart';
import 'package:project_interview/navigation/arguments.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:record_mp3/record_mp3.dart';

import '../../auth_module/models/user_model.dart';
import '../../auth_module/providers/auth_provider.dart';
import '../../commonWidgets/circular_loader.dart';
// import '../../commonWidgets/custom_app_bar.dart';
import '../../common_functions.dart';
import '../../navigation/navigators.dart';
import '../models/recording_model.dart';

class InterviewSessionScreen extends StatefulWidget {
  final InterviewSessionScreenArguments args;
  const InterviewSessionScreen({Key? key, required this.args}) : super(key: key);

  @override
  InterviewSessionScreenState createState() => InterviewSessionScreenState();
}

class InterviewSessionScreenState extends State<InterviewSessionScreen> {
  final LocalStorage storage = LocalStorage('interview_flow');
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  late User user;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;

  int questionIndex = 0;

// For player
  Duration currentPos = Duration.zero;
  Duration playerDuration = Duration.zero;
  // final player = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  bool isInitializingPlayer = false;
  int newCount = 1;

// For recorder
  String? recordedAudio;
  int totalDuration = 0;
  String statusText = '';
  String? recordFilePath;
  bool isRecordingStarted = false;
  int recordDuration = 0;
  Timer? _timer;

  bool isSavingResponse = false;
  bool isEndingSession = false;

  List recordings = [];
  Recording? recording;

  Timer? screenTimer;
  int screenSeconds = 0;
  int screenMinutes = 0;

  void startScreenTimer() {
    final durationParts = widget.args.interview.duration.split(' ');

    for (int i = 0; i < durationParts.length; i++) {
      if (durationParts[i].contains('hr')) {
        screenMinutes += int.parse(durationParts[i - 1]) * 60;
      } else if (durationParts[i].contains('mins')) {
        screenMinutes += int.parse(durationParts[i - 1]);
      } else if (durationParts[i].contains('secs')) {
        screenSeconds += int.parse(durationParts[i - 1]);
      }
    }

    screenTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          screenSeconds++;
          if (screenSeconds >= 60) {
            screenSeconds = 0;
            screenMinutes++;
          }
        });
      },
    );
  }

  String getScreenTimerValueForBackend() {
    if (screenMinutes >= 60) {
      int totalMinutes = screenMinutes + (screenSeconds ~/ 60);
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;
      return '${hours} hr ${minutes} mins';
    } else {
      return '${screenMinutes} mins ${screenSeconds % 60} secs';
    }
  }

  fetchData() async {
    setState(() => isLoading = true);
    setState(() => isLoading = false);
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    // String sdPath = "${storageDirectory.path}/record";

    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    // return sdPath + "/audio_${widget.index}.mp3";
    await storage.ready;
    // storage.deleteItem('recordCount');
    final countJson = await storage.getItem('recordCount');
    if (countJson != null) {
      final count = json.decode(countJson);
      if (count != null) {
        newCount = count + 1;
      }
    }
    storage.setItem('recordCount', newCount.toString());
    return "$sdPath/recorded_audio_${newCount.toString()}.m4a";
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // For recorder

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      // statusText = "Recording...";
      recordFilePath = await getFilePath();

      // isRecordingStarted = true;

      await Future.delayed(const Duration(milliseconds: 500), () async {
        // RecordMp3.instance.start(recordFilePath!, (type) {
        //   setState(() {});
        // });

        await recorder.startRecorder(toFile: recordFilePath, codec: Codec.aacMP4);
        setState(() {
          isRecordingStarted = true;
        });
      });

      recordDuration = 0;
      seconds = 0;

      startTimer();
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  saveRecording() async {
    final recordFilePath = await recorder.stopRecorder();
    _timer?.cancel();
    isRecordingStarted = false;

    setState(() {
      isSavingResponse = true;
    });

    Map<String, String> files = {};

    files['audio'] = recordFilePath!;

    if (recording == null) {
      final response = await Provider.of<HomeProvider>(context, listen: false).saveRecording(
        body: {
          'duration': getAudioDurationText(),
          'interviewId': widget.args.interview.id,
          'questionIndex': questionIndex.toString(),
          'totalDuration': getScreenTimerValueForBackend(), // Pass the screen timer value to the backend
        },
        files: files,
        accessToken: user.accessToken,
      );

      setState(() {
        isSavingResponse = false;
      });

      if (response['success']) {
        if (questionIndex < widget.args.interview.interviewQAA.length - 1) {
          questionIndex++;
        } else {
          endInterviewSession();
        }
      } else {
        showSnackbar(language[response['message']]);
      }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        setState(() {
          recordDuration++;
          seconds++;
        });
      },
    );
  }

  int seconds = 0;
  int minutes = 0;

  endInterviewSession() async {
    setState(() => isEndingSession = true);
    final response = await Provider.of<HomeProvider>(context, listen: false).endInterviewSession(accessToken: user.accessToken, body: {
      'interviewId': widget.args.interview.id,
      'totalDuration': getScreenTimerValueForBackend(), // Pass the screen timer value to the backend
    });

    setState(() => isEndingSession = false);

    if (response['success']) {
    } else {
      showSnackbar(response['message']);
    }
  }

  getAudioDurationText() {
    minutes = (recordDuration / 60).floor();
    if (seconds >= 60) seconds = 0;
    return '${minutes < 10 ? '0$minutes' : minutes} : ${seconds < 10 ? '0$seconds' : seconds}';
  }

  final recorder = FlutterSoundRecorder();

  setIndex() {
    for (int i = 0; i < widget.args.interview.interviewQAA.length; i++) {
      if (widget.args.interview.interviewQAA[questionIndex].answer != '') {
        questionIndex++;
        continue;
      }
      break;
    }
  }

  Widget buildTimerDisplay() {
    String displayTime;
    if (screenMinutes >= 60) {
      int hours = screenMinutes ~/ 60;
      int minutes = screenMinutes % 60;
      displayTime = '${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}';
    } else {
      displayTime = '${screenMinutes < 10 ? '0$screenMinutes' : screenMinutes}:${screenSeconds < 10 ? '0$screenSeconds' : screenSeconds}';
    }

    return Text(
      displayTime,
      style: textTheme.bodyLarge!.copyWith(
        fontSize: tS * 18,
        color: redColor,
      ),
    );
  }

  ///
  // ///

  // SpeechToText _speechToText = SpeechToText();
  // bool _speechEnabled = false;
  // String _lastWords = '';

  // /// This has to happen only once per app
  // void initSpeech() async {
  //   _speechEnabled = await _speechToText.initialize();
  //   setState(() {});
  // }

  // /// Each time to start a speech recognition session
  // void startListening() async {
  //   await _speechToText.listen(onResult: _onSpeechResult);
  //   setState(() {});
  // }

  // /// Manually stop the active speech recognition session
  // /// Note that there are also timeouts that each platform enforces
  // /// and the SpeechToText plugin supports setting timeouts on the
  // /// listen method.
  // void stopListening() async {
  //   await _speechToText.stop();
  //   setState(() {});
  // }

  // /// This is the callback that the SpeechToText plugin calls when
  // /// the platform returns recognized words.
  // void _onSpeechResult(SpeechRecognitionResult result) {
  //   setState(() {
  //     _lastWords = result.recognizedWords;
  //   });
  // }

  ///
  ///

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    recorder.openRecorder();
    // initSpeech();

    setIndex();
    fetchData();
    startScreenTimer(); // Start the screen timer when the screen opens
  }

  @override
  void dispose() {
    super.dispose();

    recorder.closeRecorder();
    screenTimer?.cancel(); // Stop the screen timer when the screen is exited
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(child: screenBody()),
      ),
    );
  }

  screenBody() {
    return SizedBox(
      height: dH,
      width: dW,
      child: isLoading
          ? const Center(child: CircularLoader())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      alignment: Alignment.center,
                      width: dW * 0.4,
                      child: Image.asset(
                        'assets/images/interview_flow.png',
                        width: dW * 0.4,
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: dW * horizontalPaddingFactor,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: isRecordingStarted || isEndingSession || isLoading ? null : pop,
                            child: Container(
                              padding: EdgeInsets.all(dW * 0.02),
                              decoration: BoxDecoration(
                                color: isRecordingStarted || isEndingSession || isLoading ? themeBlue.withOpacity(0.6) : themeBlue,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 4),
                                    spreadRadius: 1,
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              child: AssetSvgIcon('back_arrow', width: 25, color: white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 10),
                  child: buildTimerDisplay(),
                ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 90),
                      margin: EdgeInsets.only(
                        left: dW * horizontalPaddingFactor,
                        right: dW * horizontalPaddingFactor,
                      ),
                      child: Container(
                        decoration: commonBoxDecoration(20).copyWith(),
                        padding: EdgeInsets.only(
                          top: 60,
                          left: dW * horizontalPaddingFactor,
                          right: dW * horizontalPaddingFactor,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              // width: dW * 0.78,
                              child: Text(
                                widget.args.interview.interviewQAA[questionIndex].question,
                                // textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: tS * 16,
                                  color: blackColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        // color: redColor,
                        alignment: Alignment.center,
                        height: dW * 0.3,
                        width: dW * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/interviewee.png',
                            height: dW * 0.3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: dW * 0.25,
                      left: dW * 0.1,
                      right: 0,
                      child: Text('Q.${questionIndex + 1}.',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: tS * 20,
                            color: themeBlue,
                            fontFamily: 'Inter',
                          )),
                    ),

                    //   // next button

                    // if (questionIndex < widget.args.interview.interviewQAA.length - 1)
                    //   Positioned(
                    //     top: 50,
                    //     right: 0,
                    //     child: Container(
                    //       // color: redColor,
                    //       alignment: Alignment.center,
                    //       height: dW * 0.3,
                    //       width: dW * 0.3,
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(20),
                    //         child: GestureDetector(
                    //           onTap: () => setState(() => questionIndex++),
                    //           child: AssetSvgIcon('next_qs', width: 43),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                // const SizedBox(height: 15),
                // Container(
                //   margin: screenHorizontalPadding(dW),
                //   decoration: commonBoxDecoration(20).copyWith(),
                //   padding: EdgeInsets.only(
                //     top: 60,
                //     left: dW * horizontalPaddingFactor,
                //     right: dW * horizontalPaddingFactor,
                //   ),
                //   child: Text(
                //     _lastWords,
                //     style: textTheme.bodyMedium!.copyWith(
                //       fontSize: tS * 12,
                //       color: themeBlue,
                //     ),
                //   ),
                // ),

                const Spacer(),
                Container(
                    margin: EdgeInsets.only(bottom: dW * 0.05),
                    padding: screenHorizontalPadding(dW),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          width: dW * 0.6,
                          buttonTextSyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: tS * 17, color: white, letterSpacing: .3),
                          buttonColor: redColor,
                          height: dW * 0.14,
                          elevation: 0.5,
                          onPressed: isSavingResponse || isRecordingStarted ? null : endInterviewSession,
                          diabledButtonColor: redColor.withOpacity(0.3),
                          isLoading: isEndingSession,
                          radius: 40,
                          buttonText: 'End Session',
                        ),
                        Container(
                          // padding: EdgeInsets.only(bottom: 40),
                          child:
                              // isSavingResponse
                              //     ? Container(
                              //         width: 40,
                              //         height: 40,
                              //         margin: EdgeInsets.only(bottom: 20),
                              //         decoration: BoxDecoration(shape: BoxShape.circle),
                              //         child: CircularProgressIndicator(
                              //           strokeWidth: 3,
                              //           backgroundColor: Colors.white,
                              //           color: themeBlue,
                              //         ))
                              //     :
                              isRecordingStarted
                                  ? GestureDetector(
                                      onTap: () => saveRecording(),
                                      // onTap: () => stopListening(),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                offset: const Offset(0, 6),
                                                spreadRadius: 0,
                                                blurRadius: 15,
                                              )
                                            ],
                                          ),
                                          child: Image.asset(
                                            'assets/images/mic_record_ani.gif',
                                            width: 80,
                                            // color: greenColor,
                                          )),
                                    )
                                  : GestureDetector(
                                      onTap: !isSavingResponse
                                          ? () => {
                                                startRecord(),
                                                // startListening(),
                                              }
                                          : null,
                                      child: Container(
                                        margin: EdgeInsets.all(7.5),
                                        child: Stack(
                                          children: [
                                            AssetSvgIcon('mic', width: 65, color: isSavingResponse ? themeBlue.withOpacity(.75) : null),
                                            if (isSavingResponse)
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.1),
                                                          offset: const Offset(0, 6),
                                                          spreadRadius: 0,
                                                          blurRadius: 15,
                                                        )
                                                      ],
                                                    ),
                                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: white)),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                        ),
                      ],
                    )),
                // Expanded(
                //   child: SingleChildScrollView(
                //     padding: screenHorizontalPadding(dW),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         SizedBox(height: dW * 0.05),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }
}

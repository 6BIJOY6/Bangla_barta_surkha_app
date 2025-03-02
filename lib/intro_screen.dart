import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'permission_handler.dart';
import 'sms_collection.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          titleWidget: const Text(
            'বাংলা বার্তা সুরক্ষা অ্যাপে স্বাগতম',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'এই স্লাইডগুলো আপনাদের অ্যাপ সম্পর্কে জানার জন্য সাহায্য করবে। দয়া করে এগুলো মনোযোগ দিয়ে পড়ুন। পড়া শেষ হলে, স্ক্রিনের বাম পাশে টানুন অথবা পরবর্তী বাটনে ক্লিক করুন।\n\nএই অ্যাপটি আপনার মোবাইলের সকল মেসেজকে দুটি আলাদা ট্যাবে বিভক্ত করতে সাহায্য করবে। প্রথম ট্যাবে আপনার কন্টাক্ট লিস্টের মেসেজগুলো থাকবে এবং দ্বিতীয় ট্যাবে কন্টাক্ট লিস্টে না থাকা নাম্বারগুলো, যেমন বিভিন্ন কোম্পানির মেসেজগুলো থাকবে।',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          image: Center(
            child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Image.asset('assets/images/welcome.jpg')),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            'মেসেজ ম্যানেজমেন্ট এবং কন্টেইনার স্থানান্তর',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'এই অ্যাপটি আপনাকে সর্বশেষ মেসেজের ভিত্তিতে নাম্বার অনুযায়ী কন্টেইনার প্রদর্শন করবে। আপনি যে কোনো সময় কন্টেইনারে ক্লিক করে নির্দিষ্ট নাম্বার থেকে আসা মেসেজগুলো দেখতে পারবেন। প্রয়োজন হলে, একটি ট্যাব থেকে অন্য ট্যাবে কন্টেইনার টেনে স্থানান্তর করতে পারবেন এবং পরিবর্তনগুলি স্বয়ংক্রিয়ভাবে সংরক্ষিত থাকবে। এর মাধ্যমে, আপনি দ্রুত গুরুত্বপূর্ণ মেসেজগুলো দেখতে পারবেন এবং প্রায়ই ব্যবহৃত নাম্বারগুলো সহজেই Approved Contacts ট্যাবে সংরক্ষণ করতে পারবেন।',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          image: Center(
            child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Image.asset('assets/images/swipe.jpg')),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            'স্প্যাম এবং নিরাপদ মেসেজ চিহ্নিতকরণ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.all(5.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 16, color: Colors.black), // Default style
                children: <TextSpan>[
                  TextSpan(
                      text:
                          'মেসেজগুলো সহজে চিহ্নিত করার জন্য চারটি রঙ ব্যবহার করা হয়েছে। '),
                  TextSpan(
                      text: 'কালো রঙ', style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text:
                          ' নির্দেশ করে মেসেজটি হাম বা স্প্যাম কিনা, তা এখনও প্রক্রিয়াধীন রয়েছে। '),
                  TextSpan(text: 'লাল রঙ', style: TextStyle(color: Colors.red)),
                  TextSpan(text: ' নির্দেশ করে যে মেসেজটি স্প্যাম। '),
                  TextSpan(
                      text: 'সবুজ রঙ', style: TextStyle(color: Colors.green)),
                  TextSpan(text: ' নির্দেশ করে এটি একটি নিরাপদ মেসেজ। '),
                  TextSpan(
                      text: 'অ্যাম্বার রঙ',
                      style: TextStyle(color: Colors.amber)),
                  TextSpan(
                      text:
                          ' ব্যবহার করা হয়েছে অন্য ভাষায় লেখা মেসেজ চিহ্নিত করার জন্য।'),
                ],
              ),
            ),
          ),
          image: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Image.asset('assets/images/selection.jpg'),
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            'গোপনীয়তা এবং নিরাপত্তা নিশ্চিতকরণ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'এই অ্যাপটি দুটি গুরুত্বপূর্ণ অনুমতি চায়। প্রথমটি আপনার মোবাইলের বার্তাগুলো অ্যাক্সেস করার জন্য এবং দ্বিতীয়টি আপনার মোবাইলে সংরক্ষিত নাম্বারগুলোর তথ্য জানার জন্য। আমরা আপনার বার্তা এবং সংরক্ষিত নাম্বারগুলোর গোপনীয়তা নিশ্চিত করি। কোনো তৃতীয় পক্ষ বা আমাদের কেউই এগুলো অ্যাক্সেস করতে পারবে না।',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          image: Container(
              margin: const EdgeInsets.only(top: 4),
              child: Image.asset('assets/images/protect.jpg')),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
        PageViewModel(
          titleWidget: const Text(
            'অ্যাপের উন্নয়ন এবং আপনার পরামর্শ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          bodyWidget: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'আমরা ভবিষ্যতে এই অ্যাপে আরও উন্নত ফিচার যুক্ত করার পরিকল্পনা করছি, যেমন: মেসেজ ফিল্টারিং এবং কোনো প্রকার নেটওয়ার্কের প্রয়োজন না থাকা। আপনার কোনো পরামর্শ থাকলে, দয়া করে আমাদের জানান। আমরা আমাদের অ্যাপের ব্যবহারকারীদের অভিজ্ঞতা উন্নত করার জন্য সর্বদা প্রস্তুত',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
          image: Center(
            child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Image.asset('assets/images/feedback.jpg')),
          ),
          decoration: const PageDecoration(
            pageColor: Colors.white,
          ),
        ),
      ],
      onDone: () {
        _requestPermission(context);
      },
      showSkipButton: true,
      skip: const Text('এড়িয়ে যান',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      next: const Text('পরবর্তী',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      done: const Text("পরবর্তী",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    );
  }
}

Future<void> _requestPermission(BuildContext context) async {
  await updatePermissionStatus();
  if (!isPermissionGranted) {
    await requestPermission();
  }
  if (isPermissionGranted) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SmsCollection()));
    }
  } else {
    if (context.mounted) {
      _showPermissionDeniedDialog(context);
    }
  }
}

void _showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing the dialog by tapping outside
    builder: (context) => AlertDialog(
      title: const Text("Permission Required"),
      content: const Text(
          "This app requires SMS and Contact read permissions to function. Please grant permission to proceed."),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              SystemNavigator.pop(); // Close the app
            },
            child: const Text("Close App"),
          ),
        ),
      ],
    ),
  );
}

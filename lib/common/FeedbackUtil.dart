import 'package:url_launcher/url_launcher.dart';

class FeedbackUtil {
  static final String _feedbackUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLScljCi90h2S95rlwvadRMQplNjPxZkqgbZCyBM_jL-XJCsDfw/viewform?usp=sf_link";

  static void enterGoogleForm() async {
    await canLaunch(_feedbackUrl) ? await launch(_feedbackUrl) : {};
  }

  static void enterUrl(String url) async {
    await canLaunch(url) ? await launch(url) : {};
  }
}

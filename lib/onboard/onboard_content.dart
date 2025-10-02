class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Mahila Mitra",
    image: "assets/images/image1.png",
    desc: "Your safety companion that helps you stay protected in emergencies.",
  ),
  OnboardingContents(
    title: "Emergency Assistance",
    image: "assets/images/image2.png",
    desc:
"Send distress signals to nearby contacts and authorities with a single tap.",
  ),
  OnboardingContents(
    title: "Peace of Mind",
    image: "assets/images/image3.png",
    desc:
    "Stay secure knowing that help is just a tap away, wherever you are.",
  ),
  OnboardingContents(
    title: "Let's Get Started",
    image: "assets/images/image4.png",
    desc:
    "Make a new account to access all the safety features",
  ),
];
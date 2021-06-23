class Survey {
  static String getIntro() {
    return "During the last 30 days, about how often did you ...";
  }

  static List<String> getQuestions() {
    return [
      "feel tired out for no good reason?",
      "feel nervous?",
      "feel so nervous that nothing could calm you down?",
      "feel hopeless?",
      "feel restless or fidgety?",
      "feel so restless you could not sit still?",
      "feel depressed?",
      "feel that everything was an effort?",
      "feel so sad that nothing could cheer you up?",
      "feel worthless?",
    ];
  }

  static List<OptionScore> _optionScores = [
    OptionScore("None of the time", 1),
    OptionScore("A little of the time", 2),
    OptionScore("Some of the time", 3),
    OptionScore("Most of the time", 4),
    OptionScore("All of the time", 5),
  ];

  static List<String> getOptions() {
    return _optionScores.map((optionScore) => optionScore.option).toList();
  }
}

class OptionScore {
  String option = "";
  int score = 0;
  OptionScore(String option, int score) {
    this.option = option;
    this.score = score;
  }
}

class Survey {
  static String getIntro() {
    return "During the last 30 days, about how often did you ...";
  }

  static List<String> _questions = [
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

  static List<String> getQuestions() {
    return _questions;
  }

  static List<OptionScore> _optionScores = [
    OptionScore("Unselected", 0), // User can't select this to submit.
    OptionScore("None of the time", 1),
    OptionScore("A little of the time", 2),
    OptionScore("Some of the time", 3),
    OptionScore("Most of the time", 4),
    OptionScore("All of the time", 5),
  ];

  static List<OptionScore> getOptionScores() {
    return _optionScores;
  }

  static int getQuestionSize() {
    return _questions.length;
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

class Survey {
  String getIntro() {
    return "";
  }

  List<String> getQuestions() {
    return [];
  }

  List<OptionScore> getOptionScores() {
    return [];
  }

  int getQuestionSize() {
    return -1;
  }
}

class EnSurvey implements Survey {
  @override
  String getIntro() {
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

  @override
  List<String> getQuestions() {
    return _questions;
  }

  static List<OptionScore> _optionScores = [
    OptionScore("-", 0), // User can't select this to submit.
    OptionScore("None", 1),
    OptionScore("Little", 2),
    OptionScore("Some", 3),
    OptionScore("Most", 4),
    OptionScore("All", 5),
  ];

  @override
  List<OptionScore> getOptionScores() {
    return _optionScores;
  }

  @override
  int getQuestionSize() {
    return _questions.length;
  }
}

class ZhSurvey implements Survey {
  @override
  String getIntro() {
    return "過去四星期中，有多經常出現以下情況？";
  }

  static List<String> _questions = [
    "無故感到疲倦？",
    "感到緊張？",
    "緊張得沒法平復？",
    "感覺無助？",
    "感到焦躁或坐立不安？",
    "煩躁得不能坐下來？",
    "感到抑鬱？",
    "感到所有事都很費力？",
    "沒有東西能令您感到愉快？",
    "覺得自己沒有價值？",
  ];

  @override
  List<String> getQuestions() {
    return _questions;
  }

  static List<OptionScore> _optionScores = [
    OptionScore("請選擇", 0), // User can't select this to submit.
    OptionScore("從不", 1),
    OptionScore("很少", 2),
    OptionScore("有時", 3),
    OptionScore("頗多", 4),
    OptionScore("總是", 5),
  ];

  @override
  List<OptionScore> getOptionScores() {
    return _optionScores;
  }

  @override
  int getQuestionSize() {
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

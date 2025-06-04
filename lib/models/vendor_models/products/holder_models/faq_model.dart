class ParentFAQModel {
  ParentFAQModel({
    List<FAQModel>? listFaq,
    List<String>? listExistingFaqs,
  })  : listFaq = listFaq ?? [],
        listExistingFaqs = listExistingFaqs ?? [];
  List<FAQModel> listFaq;
  List<String> listExistingFaqs;
}

class FAQModel {
  FAQModel({
    this.question = '',
    this.answer = '',
  });
  String question;
  String answer;

  @override
  String toString() => 'FAQModel(question: $question, answer: $answer)';
}

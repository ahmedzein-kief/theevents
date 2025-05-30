
class ParentFAQModel {
  List<FAQModel> listFaq;
  List<String> listExistingFaqs;

  ParentFAQModel({
    List<FAQModel>? listFaq,
    List<String>? listExistingFaqs,
  })  : listFaq = listFaq ?? [],
        listExistingFaqs = listExistingFaqs ?? [];
}

class FAQModel {
  String question;
  String answer;

  FAQModel({
    this.question = '',
    this.answer = '',
  });

  @override
  String toString() {
    return 'FAQModel(question: $question, answer: $answer)';
  }
}

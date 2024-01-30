enum ENewsType { all, recent, popular, interesting }

class NewsItem {
  String? title;
  String? image;
  String? text;
  String? date;
  String? author;
  ENewsType? type;

  NewsItem(
      {this.title, this.image, this.author, this.text, this.date, this.type});
}

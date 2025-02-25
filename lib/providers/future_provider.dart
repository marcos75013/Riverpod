import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';
import 'package:http/http.dart' as http;

//1: Provider

final delayProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  return "Hello World";
});

final articleProvider = FutureProvider<List<Article>>((ref) async {
  final articles = await RSSService.shared.getArticles();
  return articles;
});

//2. Consumer

class RSSLoaderScreen extends ConsumerWidget {
  const RSSLoaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(articleProvider);
    return Center(
      child: articles.when(
        data: (items) => ListView.separated(
          itemCount: items.length,
          itemBuilder: ((context, index) => ArticleTile(article: items[index])),
          separatorBuilder: (context, index) => const Divider(),       
        ),
        error: (error, stack) => Text('Error: $error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}

//3. Classes et Services

class ArticleTile extends StatelessWidget {
  final Article article;

  const ArticleTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Spacer(),
              Text(
                article.dateTime.toString(),
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          elevation: 8,
          child: (article.imageUrl != "")
              ? Image.network(article.imageUrl!, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,)
              : const SizedBox.shrink(), 
        ),
        Text(article.title ?? 'No Title', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(article.description ?? '' ,style: const TextStyle(fontStyle: FontStyle.italic),),)
      ],
    );
  }
}

class RSSService {
  static var shared = RSSService();
  final String urlString = "https://www.francebleu.fr/rss/infos.xml";

  Future<List<Article>> getArticles() async {
    final client = http.Client();
    final url = Uri.parse(urlString);
    final clientResponse = await client.get(url);
    final feed = RssFeed.parse(utf8.decode(clientResponse.bodyBytes));
    final items = feed.items;
    if (items == null) {
      throw Exception("No items found");
    } else {
      List<Article> articles = items.map((item) => Article(item: item)).toList();
      return articles;
    }
  }
}

class Article {
  String? _title;
  String? _description;
  String? _link;
  DateTime? _dateTime;
  String? _imageUrl;

  String? get title => _title;
  String? get description => _description;
  String? get link => _link;
  DateTime? get dateTime => _dateTime ?? DateTime.now();
  String? get imageUrl => _imageUrl;
  Uri? get imageUri => Uri.parse(imageUrl!);

  Article({required RssItem item}) {
    _title = item.title;
    _description = item.description;
    _link = item.link;
    _dateTime = item.pubDate;
    _imageUrl = item.enclosure?.url;
  }
}

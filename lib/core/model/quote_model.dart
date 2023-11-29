class QuoteModel {
  final String icon;
  final String quote;

  const QuoteModel._({
    required this.icon,
    required this.quote,
  });

  static List<QuoteModel> getQuotesFromAssetType(QuotesType type) {
    switch (type) {
      case QuotesType.aug:
        return _digitalGoldQuotes;
      case QuotesType.flo:
        return _flowQuotes;
    }
  }

  static const _flowQuotes = [
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/map.png",
      quote:
          "Earning a 12% interest rate on your investments is like discovering a secret treasure map that leads to a vault filled with financial goodies.",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/donut.png",
      quote:
          "Earning 12% interest is so satisfying that it's like getting an extra financial donut in every dozen.",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/graph.png",
      quote:
          "Sit back and relax and let your savings do the work for you with Fello Flo 12%",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/popcorn.png",
      quote:
          "Auto-investing on P2P platforms is like having a financial robot assistant - it does the work, so you can enjoy more Netflix!",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/food.png",
      quote:
          "Diversifying your investments is like having a buffet at an all-you-can-eat restaurant - it's more fun, and you're less likely to regret your choices.",
    ),
  ];

  static const _digitalGoldQuotes = [
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/graph.png",
      quote: "Gold grew by 11% in the last year",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/star.png",
      quote:
          "If all gold was made into bricks it would end up in a block 20 metres cubed. This means if all the gold in the world was gathered, it would fill just one house.",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/flower_pot.png",
      quote:
          "India's love for gold is as strong as its love for spicy food! Gold here isn't just an accessory; it's our way of saying, “I'm rich and I know it!”",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/fleur.png",
      quote:
          "India's relationship with gold is stronger than a Bollywood plot twist! We buy gold like it's going out of style, but it never does—talk about timeless fashion!",
    ),
    QuoteModel._(
      icon: "https://ik.imagekit.io/9xfwtu0xm/Quotes/crown.png",
      quote:
          "India and gold: a match made in heaven, like chai and conversations. We love our gold so much, even our savings shine brighter than the sun!",
    ),
  ];
}

enum QuotesType {
  flo,
  aug;
}

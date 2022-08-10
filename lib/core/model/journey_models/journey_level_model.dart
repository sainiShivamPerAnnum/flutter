class JourneyLevel {
  int start;
  int end;
  int breakpoint;
  int pageEnd;
  int level;

  JourneyLevel(
      {this.start, this.end, this.breakpoint, this.pageEnd, this.level});

  JourneyLevel.fromMap(Map<String, dynamic> map) {
    start = map['start'];
    end = map['end'];
    breakpoint = map['breakpoint'];
    pageEnd = map['pageEnd'];
    level = map['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['breakpoint'] = this.breakpoint;
    data['pageEnd'] = this.pageEnd;
    data['level'] = this.level;
    return data;
  }
}

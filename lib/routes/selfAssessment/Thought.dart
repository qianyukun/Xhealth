class Thought {
  final int id;
  final String thoughtAdj;
  final String thoughtNoun;

  Thought({required this.id, required this.thoughtAdj, required this.thoughtNoun});

  @override
  String toString() {
    return 'Thought{id: $id, thoughtAdj: $thoughtAdj, thoughtNoun: $thoughtNoun}';
  }
}

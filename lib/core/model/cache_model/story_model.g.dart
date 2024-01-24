// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStoryCollectionCollection on Isar {
  IsarCollection<StoryCollection> get storyCollections => this.collection();
}

const StoryCollectionSchema = CollectionSchema(
  name: r'StoryCollection',
  id: 4212988923909663616,
  properties: {
    r'order': PropertySchema(
      id: 0,
      name: r'order',
      type: IsarType.long,
    ),
    r'seen': PropertySchema(
      id: 1,
      name: r'seen',
      type: IsarType.bool,
    ),
    r'storyId': PropertySchema(
      id: 2,
      name: r'storyId',
      type: IsarType.string,
    )
  },
  estimateSize: _storyCollectionEstimateSize,
  serialize: _storyCollectionSerialize,
  deserialize: _storyCollectionDeserialize,
  deserializeProp: _storyCollectionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _storyCollectionGetId,
  getLinks: _storyCollectionGetLinks,
  attach: _storyCollectionAttach,
  version: '3.1.0+1',
);

int _storyCollectionEstimateSize(
  StoryCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.storyId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _storyCollectionSerialize(
  StoryCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.order);
  writer.writeBool(offsets[1], object.seen);
  writer.writeString(offsets[2], object.storyId);
}

StoryCollection _storyCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StoryCollection(
    order: reader.readLongOrNull(offsets[0]) ?? 0,
    seen: reader.readBoolOrNull(offsets[1]),
    storyId: reader.readStringOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _storyCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _storyCollectionGetId(StoryCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _storyCollectionGetLinks(StoryCollection object) {
  return [];
}

void _storyCollectionAttach(
    IsarCollection<dynamic> col, Id id, StoryCollection object) {
  object.id = id;
}

extension StoryCollectionQueryWhereSort
    on QueryBuilder<StoryCollection, StoryCollection, QWhere> {
  QueryBuilder<StoryCollection, StoryCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StoryCollectionQueryWhere
    on QueryBuilder<StoryCollection, StoryCollection, QWhereClause> {
  QueryBuilder<StoryCollection, StoryCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StoryCollectionQueryFilter
    on QueryBuilder<StoryCollection, StoryCollection, QFilterCondition> {
  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      orderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      orderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      orderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'order',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      orderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'order',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      seenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seen',
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      seenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seen',
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      seenEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seen',
        value: value,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'storyId',
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'storyId',
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'storyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'storyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'storyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'storyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'storyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'storyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'storyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storyId',
        value: '',
      ));
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterFilterCondition>
      storyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'storyId',
        value: '',
      ));
    });
  }
}

extension StoryCollectionQueryObject
    on QueryBuilder<StoryCollection, StoryCollection, QFilterCondition> {}

extension StoryCollectionQueryLinks
    on QueryBuilder<StoryCollection, StoryCollection, QFilterCondition> {}

extension StoryCollectionQuerySortBy
    on QueryBuilder<StoryCollection, StoryCollection, QSortBy> {
  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> sortByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy>
      sortByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> sortBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy>
      sortBySeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.desc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> sortByStoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storyId', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy>
      sortByStoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storyId', Sort.desc);
    });
  }
}

extension StoryCollectionQuerySortThenBy
    on QueryBuilder<StoryCollection, StoryCollection, QSortThenBy> {
  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> thenByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy>
      thenByOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'order', Sort.desc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> thenBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy>
      thenBySeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.desc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy> thenByStoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storyId', Sort.asc);
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QAfterSortBy>
      thenByStoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storyId', Sort.desc);
    });
  }
}

extension StoryCollectionQueryWhereDistinct
    on QueryBuilder<StoryCollection, StoryCollection, QDistinct> {
  QueryBuilder<StoryCollection, StoryCollection, QDistinct> distinctByOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'order');
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QDistinct> distinctBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seen');
    });
  }

  QueryBuilder<StoryCollection, StoryCollection, QDistinct> distinctByStoryId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storyId', caseSensitive: caseSensitive);
    });
  }
}

extension StoryCollectionQueryProperty
    on QueryBuilder<StoryCollection, StoryCollection, QQueryProperty> {
  QueryBuilder<StoryCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StoryCollection, int, QQueryOperations> orderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'order');
    });
  }

  QueryBuilder<StoryCollection, bool?, QQueryOperations> seenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seen');
    });
  }

  QueryBuilder<StoryCollection, String?, QQueryOperations> storyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storyId');
    });
  }
}

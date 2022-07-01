// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetCacheModelCollection on Isar {
  IsarCollection<CacheModel> get cacheModels => getCollection();
}

const CacheModelSchema = CollectionSchema(
  name: 'CacheModel',
  schema:
      '{"name":"CacheModel","idName":"id","properties":[{"name":"data","type":"String"},{"name":"expireAfterTimestamp","type":"Long"},{"name":"hashCode","type":"Long"},{"name":"key","type":"String"},{"name":"ttl","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'data': 0,
    'expireAfterTimestamp': 1,
    'hashCode': 2,
    'key': 3,
    'ttl': 4
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _cacheModelGetId,
  setId: _cacheModelSetId,
  getLinks: _cacheModelGetLinks,
  attachLinks: _cacheModelAttachLinks,
  serializeNative: _cacheModelSerializeNative,
  deserializeNative: _cacheModelDeserializeNative,
  deserializePropNative: _cacheModelDeserializePropNative,
  serializeWeb: _cacheModelSerializeWeb,
  deserializeWeb: _cacheModelDeserializeWeb,
  deserializePropWeb: _cacheModelDeserializePropWeb,
  version: 3,
);

int _cacheModelGetId(CacheModel object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _cacheModelSetId(CacheModel object, int id) {
  object.id = id;
}

List<IsarLinkBase> _cacheModelGetLinks(CacheModel object) {
  return [];
}

void _cacheModelSerializeNative(
    IsarCollection<CacheModel> collection,
    IsarRawObject rawObj,
    CacheModel object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.data;
  IsarUint8List _data;
  if (value0 != null) {
    _data = IsarBinaryWriter.utf8Encoder.convert(value0);
  }
  dynamicSize += (_data?.length ?? 0) as int;
  final value1 = object.expireAfterTimestamp;
  final _expireAfterTimestamp = value1;
  final value2 = object.hashCode;
  final _hashCode = value2;
  final value3 = object.key;
  IsarUint8List _key;
  if (value3 != null) {
    _key = IsarBinaryWriter.utf8Encoder.convert(value3);
  }
  dynamicSize += (_key?.length ?? 0) as int;
  final value4 = object.ttl;
  final _ttl = value4;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _data);
  writer.writeLong(offsets[1], _expireAfterTimestamp);
  writer.writeLong(offsets[2], _hashCode);
  writer.writeBytes(offsets[3], _key);
  writer.writeLong(offsets[4], _ttl);
}

CacheModel _cacheModelDeserializeNative(IsarCollection<CacheModel> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = CacheModel(
    data: reader.readStringOrNull(offsets[0]),
    expireAfterTimestamp: reader.readLongOrNull(offsets[1]),
    key: reader.readStringOrNull(offsets[3]),
    ttl: reader.readLongOrNull(offsets[4]),
  );
  object.id = id;
  return object;
}

P _cacheModelDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _cacheModelSerializeWeb(
    IsarCollection<CacheModel> collection, CacheModel object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'data', object.data);
  IsarNative.jsObjectSet(
      jsObj, 'expireAfterTimestamp', object.expireAfterTimestamp);
  IsarNative.jsObjectSet(jsObj, 'hashCode', object.hashCode);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'key', object.key);
  IsarNative.jsObjectSet(jsObj, 'ttl', object.ttl);
  return jsObj;
}

CacheModel _cacheModelDeserializeWeb(
    IsarCollection<CacheModel> collection, dynamic jsObj) {
  final object = CacheModel(
    data: IsarNative.jsObjectGet(jsObj, 'data'),
    expireAfterTimestamp: IsarNative.jsObjectGet(jsObj, 'expireAfterTimestamp'),
    key: IsarNative.jsObjectGet(jsObj, 'key'),
    ttl: IsarNative.jsObjectGet(jsObj, 'ttl'),
  );
  object.id = IsarNative.jsObjectGet(jsObj, 'id');
  return object;
}

P _cacheModelDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'data':
      return (IsarNative.jsObjectGet(jsObj, 'data')) as P;
    case 'expireAfterTimestamp':
      return (IsarNative.jsObjectGet(jsObj, 'expireAfterTimestamp')) as P;
    case 'hashCode':
      return (IsarNative.jsObjectGet(jsObj, 'hashCode')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'key':
      return (IsarNative.jsObjectGet(jsObj, 'key')) as P;
    case 'ttl':
      return (IsarNative.jsObjectGet(jsObj, 'ttl')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _cacheModelAttachLinks(IsarCollection col, int id, CacheModel object) {}

extension CacheModelQueryWhereSort
    on QueryBuilder<CacheModel, CacheModel, QWhere> {
  QueryBuilder<CacheModel, CacheModel, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension CacheModelQueryWhere
    on QueryBuilder<CacheModel, CacheModel, QWhereClause> {
  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<CacheModel, CacheModel, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension CacheModelQueryFilter
    on QueryBuilder<CacheModel, CacheModel, QFilterCondition> {
  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'data',
      value: null,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'data',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'data',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'data',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'data',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'data',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'data',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'data',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> dataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'data',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expireAfterTimestampIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'expireAfterTimestamp',
      value: null,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expireAfterTimestampEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'expireAfterTimestamp',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expireAfterTimestampGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'expireAfterTimestamp',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expireAfterTimestampLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'expireAfterTimestamp',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      expireAfterTimestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'expireAfterTimestamp',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hashCodeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'hashCode',
      value: null,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hashCode',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'hashCode',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'hashCode',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'hashCode',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'key',
      value: null,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'key',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'key',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'key',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> ttlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'ttl',
      value: null,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> ttlEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'ttl',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> ttlGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'ttl',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> ttlLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'ttl',
      value: value,
    ));
  }

  QueryBuilder<CacheModel, CacheModel, QAfterFilterCondition> ttlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'ttl',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension CacheModelQueryLinks
    on QueryBuilder<CacheModel, CacheModel, QFilterCondition> {}

extension CacheModelQueryWhereSortBy
    on QueryBuilder<CacheModel, CacheModel, QSortBy> {
  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByData() {
    return addSortByInternal('data', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByDataDesc() {
    return addSortByInternal('data', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy>
      sortByExpireAfterTimestamp() {
    return addSortByInternal('expireAfterTimestamp', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy>
      sortByExpireAfterTimestampDesc() {
    return addSortByInternal('expireAfterTimestamp', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByHashCode() {
    return addSortByInternal('hashCode', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByHashCodeDesc() {
    return addSortByInternal('hashCode', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByKey() {
    return addSortByInternal('key', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByKeyDesc() {
    return addSortByInternal('key', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByTtl() {
    return addSortByInternal('ttl', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> sortByTtlDesc() {
    return addSortByInternal('ttl', Sort.desc);
  }
}

extension CacheModelQueryWhereSortThenBy
    on QueryBuilder<CacheModel, CacheModel, QSortThenBy> {
  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByData() {
    return addSortByInternal('data', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByDataDesc() {
    return addSortByInternal('data', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy>
      thenByExpireAfterTimestamp() {
    return addSortByInternal('expireAfterTimestamp', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy>
      thenByExpireAfterTimestampDesc() {
    return addSortByInternal('expireAfterTimestamp', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByHashCode() {
    return addSortByInternal('hashCode', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByHashCodeDesc() {
    return addSortByInternal('hashCode', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByKey() {
    return addSortByInternal('key', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByKeyDesc() {
    return addSortByInternal('key', Sort.desc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByTtl() {
    return addSortByInternal('ttl', Sort.asc);
  }

  QueryBuilder<CacheModel, CacheModel, QAfterSortBy> thenByTtlDesc() {
    return addSortByInternal('ttl', Sort.desc);
  }
}

extension CacheModelQueryWhereDistinct
    on QueryBuilder<CacheModel, CacheModel, QDistinct> {
  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByData(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('data', caseSensitive: caseSensitive);
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct>
      distinctByExpireAfterTimestamp() {
    return addDistinctByInternal('expireAfterTimestamp');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByHashCode() {
    return addDistinctByInternal('hashCode');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('key', caseSensitive: caseSensitive);
  }

  QueryBuilder<CacheModel, CacheModel, QDistinct> distinctByTtl() {
    return addDistinctByInternal('ttl');
  }
}

extension CacheModelQueryProperty
    on QueryBuilder<CacheModel, CacheModel, QQueryProperty> {
  QueryBuilder<CacheModel, String, QQueryOperations> dataProperty() {
    return addPropertyNameInternal('data');
  }

  QueryBuilder<CacheModel, int, QQueryOperations>
      expireAfterTimestampProperty() {
    return addPropertyNameInternal('expireAfterTimestamp');
  }

  QueryBuilder<CacheModel, int, QQueryOperations> hashCodeProperty() {
    return addPropertyNameInternal('hashCode');
  }

  QueryBuilder<CacheModel, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<CacheModel, String, QQueryOperations> keyProperty() {
    return addPropertyNameInternal('key');
  }

  QueryBuilder<CacheModel, int, QQueryOperations> ttlProperty() {
    return addPropertyNameInternal('ttl');
  }
}

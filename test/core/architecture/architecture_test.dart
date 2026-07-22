import 'package:bankyar/core/architecture/aggregate_root.dart';
import 'package:bankyar/core/architecture/data_source.dart';
import 'package:bankyar/core/architecture/entity.dart';
import 'package:bankyar/core/architecture/filtering.dart';
import 'package:bankyar/core/architecture/mapper.dart';
import 'package:bankyar/core/architecture/pagination.dart';
import 'package:bankyar/core/architecture/repository.dart';
import 'package:bankyar/core/architecture/sorting.dart';
import 'package:bankyar/core/architecture/use_case.dart';
import 'package:bankyar/core/architecture/validator.dart';
import 'package:bankyar/core/architecture/value_object.dart';
import 'package:bankyar/core/errors/failures.dart';
import 'package:bankyar/core/utils/result.dart';
import 'package:bankyar/core/utils/result_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

// Sample implementations for testing
class MyEntity extends Entity<String> {
  const MyEntity(super.id, this.name);
  final String name;
}

class MyAggregateRoot extends AggregateRoot<String> {
  const MyAggregateRoot(super.id, this.value);
  final String value;
}

class MyValueObject extends ValueObject<int> {
  const MyValueObject(super.value);
}

class MyMapper implements Mapper<String, int> {
  @override
  int map(String input) => int.parse(input);
}

class MyBidirectionalMapper implements BidirectionalMapper<String, int> {
  @override
  int map(String input) => int.parse(input);

  @override
  String mapBack(int output) => output.toString();
}

class MyValidator implements Validator<String> {
  @override
  Result<void> validate(String value) {
    if (value.isEmpty) {
      return const Result.failure(
        UnknownFailure(code: 'BY_EMPTY', message: 'Empty string'),
      );
    }
    return const Result.success(null);
  }
}

class MyUseCase implements UseCase<int, String> {
  @override
  Future<Result<int>> call(String params) async {
    try {
      final value = int.parse(params);
      return Result.success(value);
    } catch (e) {
      return Result.failure(
        UnknownFailure(code: 'BY_PARSE_ERR', message: e.toString()),
      );
    }
  }
}

class MyRepository extends Repository {}

class MyLocalDataSource extends LocalDataSource {}

class MyRemoteDataSource extends RemoteDataSource {}

void main() {
  group('Clean Architecture Base Abstractions Tests', () {
    test('UseCase and NoParams work correctly', () async {
      final useCase = MyUseCase();
      final success = await useCase.call('123');
      expect(success.isSuccess, isTrue);
      expect(success.dataOrNull, equals(123));

      final failure = await useCase.call('not-a-number');
      expect(failure.isFailure, isTrue);

      const params1 = NoParams();
      const params2 = NoParams();
      expect(params1, equals(params2));
      expect(params1.hashCode, equals(0));
    });

    test('Repository and DataSource markers are subclassable', () {
      final repo = MyRepository();
      final local = MyLocalDataSource();
      final remote = MyRemoteDataSource();

      expect(repo, isA<Repository>());
      expect(local, isA<LocalDataSource>());
      expect(remote, isA<RemoteDataSource>());
    });

    test('Mapper and BidirectionalMapper map correctly', () {
      final mapper = MyMapper();
      expect(mapper.map('456'), equals(456));

      final biMapper = MyBidirectionalMapper();
      expect(biMapper.map('789'), equals(789));
      expect(biMapper.mapBack(789), equals('789'));
    });

    test('Validator validates correctly', () {
      final validator = MyValidator();
      expect(validator.validate('hello').isSuccess, isTrue);
      expect(validator.validate('').isFailure, isTrue);
    });

    test('ValueObject checks equality and hashCode correctly', () {
      const val1 = MyValueObject(42);
      const val2 = MyValueObject(42);
      const val3 = MyValueObject(100);

      expect(val1, equals(val2));
      expect(val1, isNot(equals(val3)));
      expect(val1.hashCode, equals(val2.hashCode));
      expect(val1.toString(), contains('MyValueObject(42)'));
    });

    test('Entity checks equality based on ID', () {
      const entity1 = MyEntity('id1', 'Alice');
      const entity2 = MyEntity('id1', 'Bob');
      const entity3 = MyEntity('id2', 'Alice');

      expect(entity1, equals(entity2)); // IDs match, so they are equal
      expect(entity1, isNot(equals(entity3)));
      expect(entity1.hashCode, equals(entity2.hashCode));
      expect(entity1.toString(), contains('MyEntity(id: id1)'));
    });

    test('AggregateRoot is subclassable and acts as an Entity', () {
      const agg = MyAggregateRoot('agg1', 'Value');
      expect(agg, isA<Entity<String>>());
      expect(agg.id, equals('agg1'));
    });
  });

  group('Pagination, Filtering, and Sorting Models Tests', () {
    test('PaginatedList maps items correctly', () {
      final list = PaginatedList<String>(
        items: ['1', '2', '3'],
        nextPageAnchor: 'anchor-id',
        hasMore: true,
      );

      expect(list.items, equals(['1', '2', '3']));
      expect(list.nextPageAnchor, equals('anchor-id'));
      expect(list.hasMore, isTrue);

      final mapped = list.map((item) => int.parse(item));
      expect(mapped.items, equals([1, 2, 3]));
      expect(mapped.nextPageAnchor, equals('anchor-id'));
      expect(mapped.hasMore, isTrue);
    });

    test('PaginationParams create correctly', () {
      const offsetParams = OffsetPaginationParams(limit: 10, offset: 20);
      expect(offsetParams.limit, equals(10));
      expect(offsetParams.offset, equals(20));

      const keysetParams = KeysetPaginationParams(
        limit: 15,
        anchorValue: 'time',
        anchorId: 'uuid',
      );
      expect(keysetParams.limit, equals(15));
      expect(keysetParams.anchorValue, equals('time'));
      expect(keysetParams.anchorId, equals('uuid'));
    });

    test(
      'FilterCriteria manages parameters and computes hashCode/equality correctly',
      () {
        const criteria1 = FilterCriteria({
          'category': 'food',
          'minAmount': 100,
        });
        expect(criteria1.isEmpty, isFalse);
        expect(criteria1.getValue<String>('category'), equals('food'));
        expect(criteria1.getValue<int>('minAmount'), equals(100));

        final criteria2 = criteria1.copyWith({'maxAmount': 500});
        expect(criteria2.getValue<int>('maxAmount'), equals(500));
        expect(criteria2.getValue<String>('category'), equals('food'));

        final criteria3 = criteria2.remove('category');
        expect(criteria3.getValue<String>('category'), isNull);
        expect(criteria3.getValue<int>('maxAmount'), equals(500));

        const c1 = FilterCriteria({'category': 'food'});
        const c2 = FilterCriteria({'category': 'food'});
        const c3 = FilterCriteria({'category': 'other'});
        expect(c1, equals(c2));
        expect(c1, isNot(equals(c3)));
        expect(c1.toString(), contains('category: food'));
      },
    );

    test('SortCriteria constructs and manages parameters correctly', () {
      const sort1 = SortCriteria(
        field: 'timestamp',
        direction: SortDirection.descending,
      );
      expect(sort1.field, equals('timestamp'));
      expect(sort1.direction, equals(SortDirection.descending));
      expect(sort1.isDescending, isTrue);

      final sort2 = sort1.copyWith(direction: SortDirection.ascending);
      expect(sort2.isDescending, isFalse);
      expect(sort2.field, equals('timestamp'));

      const s1 = SortCriteria(field: 'amount');
      const s2 = SortCriteria(field: 'amount');
      const s3 = SortCriteria(
        field: 'amount',
        direction: SortDirection.ascending,
      );
      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
      expect(s1.hashCode, equals(s2.hashCode));
      expect(s1.toString(), contains('field: amount'));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lockers_app/infrastructure/db_service.dart';
import 'package:lockers_app/models/locker.dart';
import 'package:lockers_app/models/student.dart';
import 'package:lockers_app/providers/lockers_student_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDBService extends Mock implements DBService {}

main() {
  late MockDBService mockDbService;
  late LockerStudentProvider sut;

  late List<Locker> lockersListForTest;
  late Locker lockerForTest;
  late List<Locker> lockersListForTestWithoutSecondItem;
  late Locker lockerToRemove;

  late List<Student> studentsListForTest;
  late Student studentForTest;
  late List<Student> studentsListForTestWithoutSecondItem;
  late Student studentToRemove;

  setUp(() {
    mockDbService = MockDBService();
    sut = LockerStudentProvider(mockDbService);

    lockersListForTest = [
      Locker(
          id: "0",
          nbKey: 2,
          lockerNumber: 1,
          floor: "D",
          idEleve: "0",
          job: "ict",
          remark: "",
          isAvailable: false,
          lockNumber: 12345),
      Locker(
          id: "1",
          nbKey: 2,
          lockerNumber: 2,
          floor: "C",
          idEleve: "",
          job: "ict",
          remark: "",
          isAvailable: true,
          lockNumber: 12346),
      Locker(
          id: "2",
          nbKey: 1,
          lockerNumber: 3,
          floor: "E",
          idEleve: "",
          job: "ict",
          remark: "La serrure est cassé",
          isAvailable: false,
          lockNumber: 12347),
    ];

    lockerForTest = Locker(
        id: "2",
        nbKey: 2,
        lockerNumber: 3,
        floor: "E",
        idEleve: "",
        job: "ict",
        remark: "La serrure est un peu plier donc difficile à fermer",
        isAvailable: false,
        lockNumber: 12347);

    lockersListForTestWithoutSecondItem = [
      Locker(
          id: "0",
          nbKey: 2,
          lockerNumber: 1,
          floor: "D",
          idEleve: "0",
          job: "ict",
          remark: "",
          isAvailable: false,
          lockNumber: 12345),
      Locker(
          id: "2",
          nbKey: 1,
          lockerNumber: 3,
          floor: "E",
          idEleve: "",
          job: "ict",
          remark: "La serrure est cassé",
          isAvailable: false,
          lockNumber: 12347),
    ];

    lockerToRemove = Locker(
        id: "1",
        nbKey: 2,
        lockerNumber: 2,
        floor: "C",
        idEleve: "",
        job: "ict",
        remark: "",
        isAvailable: true,
        lockNumber: 12346);

    studentsListForTest = [
      Student(
          id: "0",
          firstName: "Elias",
          lastName: "Tormos",
          job: "ict",
          manager: "JHI",
          caution: 20,
          lockerNumber: 1),
      Student(
          id: "1",
          firstName: "Timo",
          lastName: "Portal",
          job: "ict",
          manager: "JHI",
          caution: 20,
          lockerNumber: 2),
      Student(
          id: "2",
          firstName: "Fabio",
          lastName: "Serra",
          job: "ict",
          manager: "JHI",
          caution: 20,
          lockerNumber: 0),
    ];
    studentForTest = Student(
        id: "2",
        firstName: "Fabio",
        lastName: "Leite",
        job: "ict",
        manager: "JHI",
        caution: 20,
        lockerNumber: 3);
    studentsListForTestWithoutSecondItem = [
      Student(
          id: "0",
          firstName: "Elias",
          lastName: "Tormos",
          job: "ict",
          manager: "JHI",
          caution: 20,
          lockerNumber: 1),
      Student(
          id: "2",
          firstName: "Fabio",
          lastName: "Serra",
          job: "ict",
          manager: "JHI",
          caution: 20,
          lockerNumber: 0),
    ];
    studentToRemove = Student(
        id: "1",
        firstName: "Timo",
        lastName: "Portal",
        job: "ict",
        manager: "JHI",
        caution: 20,
        lockerNumber: 2);
  });

  Future<Locker> turnALockerIntoAFuture(Locker locker) {
    return Future<Locker>.value(locker);
  }

  Future<List<Locker>> futureLockersListForTests(Invocation invocation) {
    return Future<List<Locker>>.value(lockersListForTest);
  }

  Future<List<Student>> futureStudentsListForTests(Invocation invocation) {
    return Future<List<Student>>.value(studentsListForTest);
  }

  Future<Student> turnAStudentIntoAFuture(Student student) {
    return Future<Student>.value(student);
  }

  // test('Tests variables initial values', () {
  //   sut = LockerStudentProvider(mockDbService);
  //   expect(sut.lockerItems, []);
  //   expect(sut.deletedLocker, null);
  //   expect(sut.deletedLockerIndex, null);
  // });

  group('fetchAndSetLockers', () {
    void makesThatTheServicesGetLockerMethodReturns3Objects() {
      when(mockDbService.getAllLockers).thenAnswer(futureLockersListForTests);
    }

    test(
        'Tests that the GetAllLockersLockers method of the service is only called once',
        () async {
      makesThatTheServicesGetLockerMethodReturns3Objects();
      await sut.fetchAndSetLockers();
      verify(mockDbService.getAllLockers).called(1);
    });

    test('Tests that LoadLockers put the values on the list', () async {
      makesThatTheServicesGetLockerMethodReturns3Objects();
      await sut.fetchAndSetLockers();
      expect(sut.lockerItems, lockersListForTest);
    });

    test('Tests that the method removes all items before adding new ones',
        () async {
      makesThatTheServicesGetLockerMethodReturns3Objects();
      await sut.fetchAndSetLockers();
      await sut.fetchAndSetLockers();
      expect(sut.lockerItems, lockersListForTest);
    });
  });

  group('addLocker', () {
    void makesThatTheServicesAddLockerMethodReturnsAnObject() {
      when(() => mockDbService.addLocker(lockerForTest)).thenAnswer(
          (Invocation invocation) => turnALockerIntoAFuture(lockerForTest));
    }

    test('tests that the method of the service is called once', () async {
      makesThatTheServicesAddLockerMethodReturnsAnObject();
      await sut.addLocker(lockerForTest);
      verify(() => mockDbService.addLocker(lockerForTest)).called(1);
    });

    test('Tests that the method adds an objet in the list', () async {
      makesThatTheServicesAddLockerMethodReturnsAnObject();
      await sut.addLocker(lockerForTest);
      expect(sut.lockerItems[0], lockerForTest);
    });
  });

  group('updateLocker', () {
    setUp(() {
      for (var item in lockersListForTest) {
        when(() => mockDbService.addLocker(item)).thenAnswer(
            (Invocation invocation) => turnALockerIntoAFuture(item));
        sut.addLocker(item);
      }
    });
    void makesThatTheServicesUpdateLockerMethodReturnsAnObject() {
      when(() => mockDbService.updateLocker(lockerForTest)).thenAnswer(
          (Invocation invocation) => turnALockerIntoAFuture(lockerForTest));
    }

    test('tests that the method of the service is called only once', () async {
      makesThatTheServicesUpdateLockerMethodReturnsAnObject();
      await sut.updateLocker(lockerForTest);
      verify(() => mockDbService.updateLocker(lockerForTest)).called(1);
    });

    test('tests that the method changes the item on the list', () async {
      makesThatTheServicesUpdateLockerMethodReturnsAnObject();
      await sut.updateLocker(lockerForTest);
      expect(sut.lockerItems[2], lockerForTest);
    });
  });

  group('deleteLocker', () {
    setUp(() {
      for (var item in lockersListForTest) {
        when(() => mockDbService.addLocker(item)).thenAnswer(
            (Invocation invocation) => turnALockerIntoAFuture(item));
        sut.addLocker(item);
      }
    });

    void makesThatTheServicesDeleteLockerMethodReturnsAnObject() {
      when(() => mockDbService.deleteLocker("1")).thenAnswer(
          (Invocation invocation) => turnALockerIntoAFuture(lockerForTest));
    }

    test('tests that the method of the service is called only once', () async {
      makesThatTheServicesDeleteLockerMethodReturnsAnObject();
      await sut.deleteLocker("1");
      verify(() => mockDbService.deleteLocker("1")).called(1);
    });

    test('tests that the method removes an item from the list', () async {
      makesThatTheServicesDeleteLockerMethodReturnsAnObject();
      await sut.deleteLocker("1");
      expect(sut.lockerItems, lockersListForTestWithoutSecondItem);
    });

    // test(
    //     'tests that the method gives the right values to the recovering variables',
    //     () async {
    //   makesThatTheServicesDeleteLockerMethodReturnsAnObject();
    //   await sut.deleteLocker("1");
    //   expect(sut.deletedLocker, lockerToRemove);
    //   expect(sut.deletedLockerIndex, 1);
    // });
  });

  group('insertLocker', () {
    setUp(() {
      for (var item in lockersListForTestWithoutSecondItem) {
        when(() => mockDbService.addLocker(item)).thenAnswer(
            (Invocation invocation) => turnALockerIntoAFuture(item));
        sut.addLocker(item);
      }
    });
    void makesThatTheServicesUpdateLockerMethodReturnsAnObject() {
      when(() => mockDbService.updateLocker(lockerToRemove)).thenAnswer(
          (Invocation invocation) => turnALockerIntoAFuture(lockerToRemove));
    }

    test('tests that the updateLocker method is called only once', () {
      makesThatTheServicesUpdateLockerMethodReturnsAnObject();
      sut.insertLocker(1, lockerToRemove);
      verify(() => mockDbService.updateLocker(lockerToRemove)).called(1);
    });

    test('tests that method inserts the correct object at the correct place',
        () async {
      makesThatTheServicesUpdateLockerMethodReturnsAnObject();
      await sut.insertLocker(1, lockerToRemove);
      expect(sut.lockerItems, lockersListForTest);
    });
  });

  group('GetLocker', () {
    setUp(() {
      for (var item in lockersListForTest) {
        when(() => mockDbService.addLocker(item)).thenAnswer(
            (Invocation invocation) => turnALockerIntoAFuture(item));
        sut.addLocker(item);
      }
    });

    test('Tests that the method returns the right object', () {
      var item = sut.getLocker("1");
      expect(item, lockersListForTest[1]);
    });

    test('tests that the method returns the error template if id not found',
        () {
      var item = sut.getLocker("Unknown-One");
      expect(item, Locker.error());
    });
  });

  group('getAvailableLockers', () {
    setUp(() {
      for (var item in lockersListForTest) {
        when(() => mockDbService.addLocker(item)).thenAnswer(
            (Invocation invocation) => turnALockerIntoAFuture(item));
        sut.addLocker(item);
      }
    });

    test('tests that it only returns available lockers', () async {
      var items = await sut.getAvailableLockers();
      expect(items, [
        Locker(
          id: "1",
          nbKey: 2,
          lockerNumber: 2,
          floor: "C",
          idEleve: "",
          job: "ict",
          remark: "",
          isAvailable: true,
          lockNumber: 12346,
        ),
      ]);
    });
  });

  test('Tests variables initial values', () {
    sut = LockerStudentProvider(mockDbService);
    expect(sut.studentItems, []);
  });
  group('fetchAndSetStudents', () {
    void makesThatTheServicesGetStudentMethodReturns3Objects() {
      when(mockDbService.getAllStudents).thenAnswer(futureStudentsListForTests);
    }

    test(
        'Tests that the GetAllStudents method of the service is only called once',
        () async {
      makesThatTheServicesGetStudentMethodReturns3Objects();
      await sut.fetchAndSetStudents();
      verify(mockDbService.getAllStudents).called(1);
    });
    test('Tests that LoadStudents put the values on the list', () async {
      makesThatTheServicesGetStudentMethodReturns3Objects();
      await sut.fetchAndSetStudents();
      expect(sut.studentItems, studentsListForTest);
    });
    test('Tests that the method removes all items before adding new ones',
        () async {
      makesThatTheServicesGetStudentMethodReturns3Objects();
      await sut.fetchAndSetStudents();
      await sut.fetchAndSetStudents();
      expect(sut.studentItems, studentsListForTest);
    });
  });
  group('addStudent', () {
    void makesThatTheServicesAddStudentMethodReturnsAnObject() {
      when(() => mockDbService.addStudent(studentForTest)).thenAnswer(
          (Invocation invocation) => turnAStudentIntoAFuture(studentForTest));
    }

    test('tests that the method of the service is called once', () async {
      makesThatTheServicesAddStudentMethodReturnsAnObject();
      await sut.addStudent(studentForTest);
      verify(() => mockDbService.addStudent(studentForTest)).called(1);
    });
    test('Tests that the method adds an objet in the list', () async {
      makesThatTheServicesAddStudentMethodReturnsAnObject();
      await sut.addStudent(studentForTest);
      expect(sut.studentItems[0], studentForTest);
    });
  });
  group('updateStudent', () {
    setUp(() {
      for (var item in studentsListForTest) {
        when(() => mockDbService.addStudent(item)).thenAnswer(
            (Invocation invocation) => turnAStudentIntoAFuture(item));
        sut.addStudent(item);
      }
    });
    void makesThatTheServicesUpdateStudentMethodReturnsAnObject() {
      when(() => mockDbService.updateStudent(studentForTest)).thenAnswer(
          (Invocation invocation) => turnAStudentIntoAFuture(studentForTest));
    }

    test('tests that the method changes the item on the list', () async {
      makesThatTheServicesUpdateStudentMethodReturnsAnObject();
      await sut.updateStudent(studentForTest);
      expect(sut.studentItems[2], studentForTest);
    });
  });
  group('deleteStudent', () {
    setUp(() {
      for (var item in studentsListForTest) {
        when(() => mockDbService.addStudent(item)).thenAnswer(
            (Invocation invocation) => turnAStudentIntoAFuture(item));
        sut.addStudent(item);
      }
    });
    void makesThatTheServicesDeleteStudentMethodReturnsAnObject() {
      when(() => mockDbService.deleteStudent("1")).thenAnswer(
          (Invocation invocation) => turnAStudentIntoAFuture(studentForTest));
    }

    test('tests that the method of the service is called only once', () async {
      makesThatTheServicesDeleteStudentMethodReturnsAnObject();
      await sut.deleteStudent("1");
      verify(() => mockDbService.deleteStudent("1")).called(1);
    });
    test('tests that the method removes an item from the list', () async {
      makesThatTheServicesDeleteStudentMethodReturnsAnObject();
      await sut.deleteStudent("1");
      expect(sut.studentItems, studentsListForTestWithoutSecondItem);
    });
  });
  group('insertStudent', () {
    setUp(() {
      for (var item in studentsListForTestWithoutSecondItem) {
        when(() => mockDbService.addStudent(item)).thenAnswer(
            (Invocation invocation) => turnAStudentIntoAFuture(item));
        sut.addStudent(item);
      }
    });
    void makesThatTheServicesUpdateStudentMethodReturnsAnObject() {
      when(() => mockDbService.updateStudent(studentToRemove)).thenAnswer(
          (Invocation invocation) => turnAStudentIntoAFuture(studentToRemove));
    }

    test('tests that the updateStudent method is called only once', () {
      makesThatTheServicesUpdateStudentMethodReturnsAnObject();
      sut.insertStudent(1, studentToRemove);
      verify(() => mockDbService.updateStudent(studentToRemove)).called(1);
    });
    test('tests that method inserts the correct object at the correct place',
        () async {
      makesThatTheServicesUpdateStudentMethodReturnsAnObject();
      await sut.insertStudent(1, studentToRemove);
      expect(sut.studentItems, studentsListForTest);
    });
  });
  group('GetStudent', () {
    setUp(() {
      for (var item in studentsListForTest) {
        when(() => mockDbService.addStudent(item)).thenAnswer(
            (Invocation invocation) => turnAStudentIntoAFuture(item));
        sut.addStudent(item);
      }
    });
    test('Tests that the method returns the right object', () {
      var item = sut.getStudent("1");
      expect(item, studentsListForTest[1]);
    });
    test('tests that the method returns the error template if id not found',
        () {
      var item = sut.getStudent("Unknown-One");
      expect(item, Student.error());
    });
  });
  group('getAvailableStudents', () {
    setUp(() {
      for (var item in studentsListForTest) {
        when(() => mockDbService.addStudent(item)).thenAnswer(
            (Invocation invocation) => turnAStudentIntoAFuture(item));
        sut.addStudent(item);
      }
    });
    test('tests that it only returns available students', () async {
      var items = await sut.getAvailableStudents();
      expect(items, [
        Student(
            id: "2",
            firstName: "Fabio",
            lastName: "Serra",
            job: "ict",
            manager: "JHI",
            caution: 20,
            lockerNumber: 0)
      ]);
    });
  });
}

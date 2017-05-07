//
//  EasyMapping
//
//  Copyright (c) 2012-2017 Lucas Medeiros.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest

class ManagedTestCase : XCTestCase {
    let context = Storage.shared.context
    
    override func setUp() {
        super.setUp()
        ManagedCar.register(ManagedMappingProvider.carMapping())
        ManagedPhone.register(ManagedMappingProvider.phoneMapping())
        ManagedPerson.register(ManagedMappingProvider.personMapping())
    }
    
    override func tearDown() {
        super.tearDown()
        
        ManagedCar.register(nil)
        ManagedPhone.register(nil)
        ManagedPerson.register(nil)
        
        Storage.shared.resetStorage()
        Storage.shared.context.rollback()
        Storage.shared.context.reset()
    }
    
    func numberOfObjects<T:NSManagedObject>(_ type: T.Type) -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        return (try? context.count(for: request)) ?? 0
    }
    
    func insert<T:NSManagedObject>(_ type: T.Type) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self),
                                                   into: context) as! T
    }
}

class EKManagedObjectMapperTestCase: ManagedTestCase {
    
    func testSimpleObjectFromExternalRepresentationWithMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Car.json")
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                               with: ManagedMappingProvider.carMapping(),
                                               in: context) as! ManagedCar
        
        XCTAssertEqual(car.model, info["model"] as? String)
        XCTAssertEqual(car.year, info["year"] as? String)
    }
    
    func testObjectWithRootKey() {
        let rootInfo = FixtureLoader.dictionary(fromFileNamed: "CarWithRoot.json")
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: rootInfo,
                                               with: ManagedMappingProvider.carWithRootKeyMapping(),
                                               in: context) as? ManagedCar
        let info = (rootInfo["data"] as? [String:Any])?["car"] as? [String:Any]
        
        XCTAssertEqual(car?.model, info?["model"] as? String)
        XCTAssertEqual(car?.year, info?["year"] as? String)
    }
    
    func testNestedInformation() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithNestedAttributes.json")
        
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                               with: ManagedMappingProvider.carNestedAttributesMapping(),
                                               in: context) as? ManagedCar
        
        XCTAssertEqual(car?.model, info["model"] as? String)
        XCTAssertEqual(car?.year, (info["information"] as? [String:Any])?["year"] as? String)
    }
    
    func testObjectWithDateFormatter() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithDate.json")
        
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                               with: ManagedMappingProvider.carWithDateMapping(),
                                               in: context) as? ManagedCar
        
        XCTAssertEqual(car?.model, info["model"] as? String)
        XCTAssertEqual(car?.year, info["year"] as? String)
        
        let formatter = ManagedMappingProvider.iso8601DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let expected = formatter.date(from: info["created_at"] as? String ?? "")
        
        XCTAssertEqual(car?.createdAt, expected)
    }
    
    func testExistingObject() {
        let oldCar = insert(ManagedCar.self)
        oldCar.carID = 1
        oldCar.year = "1980"
        oldCar.model = "i20"
        
        try! context.save()
        
        let info = ["id":1,"model":"i30","year":"2013"] as [String : Any]
        
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                               with: ManagedMappingProvider.carMapping(),
                                               in: context) as! ManagedCar
        
        XCTAssertEqual(car, oldCar)
        XCTAssertEqual(car.carID, oldCar.carID)
        XCTAssertEqual(car.model, info["model"] as? String)
        XCTAssertEqual(car.year, info["year"] as? String)
        XCTAssertEqual(numberOfObjects(ManagedCar.self), 1)
    }
    
    func testMissingValuesShouldNotBeCleared() {
        let old = insert(ManagedCar.self)
        old.carID = 1
        old.year = "1980"
        old.model = ""
        old.createdAt = Date()
        
        _ = try? context.save()
        
        let info = ["id":1,"model":"i30"] as [String : Any]
        let mapping = ManagedMappingProvider.carWithDateMapping()
        mapping.ignoreMissingFields = true
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                               with: mapping,
                                               in: context) as! ManagedCar
        
        XCTAssertEqual(car.carID, old.carID)
        XCTAssertEqual(car.model, info["model"] as? String)
        XCTAssertEqual(car.year, old.year)
        XCTAssertEqual(car.createdAt, old.createdAt)
        XCTAssertEqual(numberOfObjects(ManagedCar.self), 1)
    }
    
    func testExplicitlyNilAttributesShouldBeReplaced() {
        let old = insert(ManagedCar.self)
        old.carID = 1
        old.year = "1980"
        old.model = ""
        old.createdAt = Date()
        _ = try? context.save()
        
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithAttributesRemoved.json")
        let mapping = ManagedMappingProvider.carWithDateMapping()
        mapping.ignoreMissingFields = true
        let car = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                               with: mapping,
                                               in: context) as? ManagedCar
        
        XCTAssertEqual(car?.carID, old.carID)
        XCTAssertNil(car?.model)
        XCTAssertEqual(car?.year, old.year)
        XCTAssertNil(car?.createdAt)
        XCTAssertEqual(numberOfObjects(ManagedCar.self), 1)
    }
    
    func testHasOneMapping() {
        let expected = insert(ManagedCar.self)
        expected.model = "i30"
        expected.year = "2013"
        
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        
        let person = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                                  with: ManagedMappingProvider.personMapping(),
                                                  in: context) as! ManagedPerson
        
        XCTAssertEqual(person.car.model, expected.model)
        XCTAssertEqual(person.car.year, expected.year)
    }
    
    func testHasOneMappingWithSeveralNonNestedKeys() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonNonNested.json")
        ManagedPerson.register(ManagedMappingProvider.personNonNestedMapping())
        
        let person = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                                  with: ManagedMappingProvider.personNonNestedMapping(),
                                                in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.name, "Lucas")
        XCTAssertEqual(person?.car.carID, 3)
        XCTAssertEqual(person?.car.model, "i30")
        XCTAssertEqual(person?.car.year, "2013")
    }
    
    func testHasManyMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        
        let person = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                                  with: ManagedMappingProvider.personMapping(),
                                                  in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.phones.count, 2)
        XCTAssertEqual(numberOfObjects(ManagedPerson.self), 1)
        XCTAssertEqual(numberOfObjects(ManagedPhone.self), 2)
    }
    
    func testArrayOfObjects() {
        let info = FixtureLoader.array(fromFileNamed: "Cars.json")
        
        let cars = EKManagedObjectMapper.arrayOfObjects(fromExternalRepresentation: info,
                                                        with: ManagedMappingProvider.carMapping(),
                                                        in: context)
        cars.forEach { XCTAssert($0 is ManagedCar) }
        XCTAssertEqual(cars.count, info.count)
    }
    
    func testArrayOfObjectsWithSameObjects() {
        let info = FixtureLoader.array(fromFileNamed: "PersonsWithSamePhones.json")
        
        let people = EKManagedObjectMapper.arrayOfObjects(fromExternalRepresentation: info,
                                                          with: ManagedMappingProvider.personWithPhonesMapping(),
                                                          in: context) as? [ManagedPerson]
        let phone = people?.first?.phones.first
        let phone2 = people?.last?.phones.first
        
        XCTAssertEqual(phone, phone2)
    }
    
    func testRecursiveMappings() {
        let info = FixtureLoader.dictionary(fromFileNamed: "RecursiveDuplicates.json")
        
        let recursive = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                                     with: Recursive.objectMapping(),
                                                     in: context) as? NSManagedObject
        
        XCTAssertEqual(recursive?.value(forKey: "id") as? String, "1")
        XCTAssertEqual((recursive?.value(forKey: "link") as? NSManagedObject)?.value(forKey: "id") as? String, "2")
        
        XCTAssertEqual(
            ((recursive?.value(forKey: "link") as? NSManagedObject)?
                .value(forKey: "link") as? NSManagedObject)?
                .value(forKey: "id") as? String,"1"
        )
    }
    
    func testSyncArrayFromExternalRepresentationSamePhones() {
        let phones = FixtureLoader.dictionary(fromFileNamed: "Person.json")["phones"] as? [[String:Any]] ?? []
        let zeroPhones = FixtureLoader.dictionary(fromFileNamed: "PersonWithZeroPhones.json")["phones"] as? [[String:Any]] ?? []
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedPhone")
        var phonesArray = EKManagedObjectMapper.syncArrayOfObjects(fromExternalRepresentation: phones, with: ManagedMappingProvider.phoneMapping(), fetchRequest: request, in: Storage.shared.context)
        
        XCTAssertEqual(phonesArray.count, 2)
        XCTAssertEqual(numberOfObjects(ManagedPhone.self), 2)
        
        phonesArray = EKManagedObjectMapper.syncArrayOfObjects(fromExternalRepresentation: zeroPhones,
                                                               with: ManagedMappingProvider.phoneMapping(),
                                                               fetchRequest: request,
                                                               in: Storage.shared.context)
        XCTAssertEqual(phonesArray.count, 0)
        XCTAssertEqual(numberOfObjects(ManagedPhone.self), 0)
    }
}

class EKManagedObjectMapperIncrementalDataTests: ManagedTestCase {
    
    func testHasManyMappingIncrementalData() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = ManagedMappingProvider.personMapping()
        mapping.incrementalData = true
        let person = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.phones.count, 2)
        XCTAssertEqual(numberOfObjects(ManagedPerson.self), 1)
        XCTAssertEqual(numberOfObjects(ManagedPhone.self), 2)
    }
    
    func testHasManyMappingAndNoIncrementalData() {
        let personInfo = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let personWithPhones = FixtureLoader.dictionary(fromFileNamed: "PersonWithOtherPhones.json")
        let mapping = ManagedMappingProvider.personMapping()
        
        var person = EKManagedObjectMapper.object(fromExternalRepresentation: personInfo,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        person = EKManagedObjectMapper.object(fromExternalRepresentation: personWithPhones,
                                              with: mapping,
                                              in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.phones.count, 2)
    }
    
    func testHasManyMappingAndIncrementalData() {
        let personInfo = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let personWithPhones = FixtureLoader.dictionary(fromFileNamed: "PersonWithOtherPhones.json")
        let mapping = ManagedMappingProvider.personMapping()
        mapping.incrementalData = true
        
        var person = EKManagedObjectMapper.object(fromExternalRepresentation: personInfo,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        person = EKManagedObjectMapper.object(fromExternalRepresentation: personWithPhones,
                                              with: mapping,
                                              in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.phones.count, 4)
    }
    
    func testHasManyMappingWithEmptyArrayAndNoIncrementalData() {
        let personInfo = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let personWithPhones = FixtureLoader.dictionary(fromFileNamed: "PersonWithZeroPhones.json")
        let mapping = ManagedMappingProvider.personMapping()
        
        var person = EKManagedObjectMapper.object(fromExternalRepresentation: personInfo,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        person = EKManagedObjectMapper.object(fromExternalRepresentation: personWithPhones,
                                              with: mapping,
                                              in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.phones.count, 0)
    }
    
    func testHasManyMappingWithEmptyArrayAndIncrementalData() {
        let personInfo = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let personWithPhones = FixtureLoader.dictionary(fromFileNamed: "PersonWithZeroPhones.json")
        let mapping = ManagedMappingProvider.personMapping()
        mapping.incrementalData = true
        
        var person = EKManagedObjectMapper.object(fromExternalRepresentation: personInfo,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        person = EKManagedObjectMapper.object(fromExternalRepresentation: personWithPhones,
                                              with: mapping,
                                              in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.phones.count, 2)
    }
    
    func testIncrementalDataWithRecursiveMappings() {
        let personRecursive = FixtureLoader.dictionary(fromFileNamed: "PersonRecursive.json")
        let mapping = ManagedMappingProvider.personMapping()
        mapping.incrementalData = true
        
        let person = EKManagedObjectMapper.object(fromExternalRepresentation: personRecursive,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        
        XCTAssertEqual(person?.relative.name, "Loreen")
        XCTAssertEqual(person?.relative.email, "loreen@gmail.com")
        XCTAssertEqual(person?.relative.gender, "female")
        XCTAssertEqual(person?.children.count, 2)
        person?.children.forEach({ child in
            if child.name == "Masha" {
                XCTAssertEqual(child.relative.name, "Alexey")
                XCTAssertEqual(child.children.count, 0)
            } else if child.name == "Elena" {
                XCTAssertNil(child.relative)
                XCTAssertEqual(child.children.count, 0)
            } else { XCTFail() }
        })
    }
}

class EKManagedObjectMapperIgnoreMissingFieldsTestCase : ManagedTestCase
{
    func testIgnoreMissingFields() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let infoPartial = FixtureLoader.dictionary(fromFileNamed: "PersonWithoutRelations.json")
        let mapping = ManagedMappingProvider.personMapping()
        
        var person = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                                  with: mapping,
                                                  in: context) as? ManagedPerson
        // Check default behaviour
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
        
        EKManagedObjectMapper.fillObject(person!,
                                         fromExternalRepresentation: infoPartial,
                                         with: mapping,
                                         in: context)
        XCTAssertNil(person?.car)
        XCTAssertEqual(person?.phones.count, 0)
        
        // Check behaviour with set ignoreMissingFields property
        person = EKManagedObjectMapper.object(fromExternalRepresentation: info,
                                              with: mapping,
                                              in: context) as? ManagedPerson
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
        
        mapping.ignoreMissingFields = true
        
        EKManagedObjectMapper.fillObject(person!,
                                         fromExternalRepresentation: infoPartial,
                                         with: mapping,
                                         in: context)
        XCTAssertNotNil(person?.car)
        XCTAssertNotNil(person?.phones)
    }
}

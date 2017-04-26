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

class EKMapperBaseTestCase : XCTestCase {
    override func setUp() {
        super.setUp()
        Car.register(MappingProvider.carMapping())
        Phone.register(MappingProvider.phoneMapping())
        Person.register(MappingProvider.personMapping())
    }
    
    override func tearDown() {
        super.tearDown()
        Car.register(nil)
        Phone.register(nil)
        Person.register(nil)
    }
}

class EKMapperTestCase: EKMapperBaseTestCase {
    
    func testSimpleObject() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Car.json")
        let car = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.carMapping()) as? Car
        
        XCTAssertNotNil(car?.model)
        XCTAssertNotNil(car?.year)
        XCTAssertEqual(car?.model, info["model"] as? String)
        XCTAssertEqual(car?.year, info["year"] as? String)
    }
    
    func simpleObjectWithRootPath() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithRoot.json")
        let car = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.carWithRootKeyMapping()) as? Car
        
        XCTAssertNotNil(car?.model)
        XCTAssertNotNil(car?.year)
        XCTAssertEqual(car?.model, info["model"] as? String)
        XCTAssertEqual(car?.year, info["year"] as? String)
        XCTAssertEqual(car?.carId, 1)
    }
    
    func testWithNestedInformation() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithNestedAttributes.json")
        let car = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.carNestedAttributesMapping()) as? Car
        
        XCTAssertNotNil(car?.model)
        XCTAssertNotNil(car?.year)
        XCTAssertEqual(car?.model, info["model"] as? String)
        XCTAssertEqual(car?.year, (info["information"] as? [String:Any])?["year"] as? String)
    }
    
    func testWithDateFormattter() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithDate.json")
        let car = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.carWithDateMapping()) as? Car
        
        XCTAssertNotNil(car?.model)
        XCTAssertNotNil(car?.year)
        XCTAssertEqual(car?.model, info["model"] as? String)
        XCTAssertEqual(car?.year, info["year"] as? String)
        let formatter = MappingProvider.iso8601DateFormatter()
        let expected = formatter.date(from: info["created_at"] as? String ?? "")
        XCTAssertEqual(car?.createdAt, expected)
    }
    
    func testWithValueBlock() {
        let male = EKMapper.object(fromExternalRepresentation: FixtureLoader.dictionary(fromFileNamed: "Male.json"),
                                   with: MappingProvider.personWithOnlyValueBlockMapping()) as? Person
        let female = EKMapper.object(fromExternalRepresentation: FixtureLoader.dictionary(fromFileNamed: "Female.json"),
                                     with: MappingProvider.personWithOnlyValueBlockMapping()) as? Person
        
        XCTAssert(male?.gender == .male)
        XCTAssert(female?.gender == .female)
    }
    
    func testWithCustomObjectInValueBlock() {
        let address = EKMapper.object(fromExternalRepresentation: FixtureLoader.dictionary(fromFileNamed: "Address.json"), with: MappingProvider.addressMapping()) as? Address
        
        XCTAssertNotNil(address?.location)
    }
    
    func testUsingMappingBlocks() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let person = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.personMapping()) as? Person
        XCTAssertEqual(person?.socialURL, URL(string: "https://www.twitter.com/EasyMapping"))
    }
    
    func testDateMappingNull() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CarWithDate.json")
        var car = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.carWithDateMapping()) as? Car
        
        let infoRemovedAttributes = FixtureLoader.dictionary(fromFileNamed: "CarWithAttributesRemoved.json")
        let mapping = MappingProvider.carWithDateMapping()
        mapping.ignoreMissingFields = true
        car = EKMapper.fillObject(car!, fromExternalRepresentation: infoRemovedAttributes, with: mapping) as? Car
        
        XCTAssertNotNil(car?.year)
        XCTAssertNil(car?.model)
        XCTAssertNil(car?.createdAt)
    }
    
    func testHasOneMapping() {
        let expected = Car.i30
        let person = EKMapper.object(fromExternalRepresentation: FixtureLoader.dictionary(fromFileNamed: "Person.json"), with: MappingProvider.personMapping()) as? Person
        
        XCTAssertEqual(person?.car.model, expected.model)
        XCTAssertEqual(person?.car.year, expected.year)
    }
    
    func testHasOneMappingWithDifferentNaming() {
        let expected = Car.i30
        let mapping = EKObjectMapping(objectClass: Person.self)
        mapping.hasOne(Car.self, forKeyPath: "vehicle", forProperty: "car")
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithDifferentNaming.json")
        
        let person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        
        XCTAssertNotNil(person?.car)
        XCTAssertEqual(person?.car.model, expected.model)
        XCTAssertEqual(person?.car.year, expected.year)
    }
    
    func testHasOneMappingWithNull() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithNullCar.json")
        let person = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.personMapping()) as? Person
        
        XCTAssertNotNil(person?.phones)
        XCTAssertNil(person?.car)
    }
    
    func testHasManyMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let person = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.personMapping()) as? Person
        
        XCTAssertEqual(person?.phones.count, 2)
    }
    
    func testHasManyMappingWithDifferentNaming() {
        let mapping = EKObjectMapping(objectClass: Person.self)
        mapping.hasMany(Phone.self, forKeyPath: "cellphones", forProperty: "phones")
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithDifferentNaming.json")
        let person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        
        XCTAssertEqual(person?.phones.count, 2)
        XCTAssertEqual(person?.phones.last?.number, "2222-222")
    }
    
    func testHasManyMappingWithNull() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithNullPhones.json")
        let person = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.personMapping()) as? Person
        
        XCTAssertNil(person?.phones)
        XCTAssertNotNil(person)
        XCTAssertNotNil(person?.car)
    }
    
    func testWithNativeProperties() {
        let mapping = Native.objectMapping()
        let native = EKMapper.object(fromExternalRepresentation: FixtureLoader.dictionary(fromFileNamed: "Native.json"), with: mapping) as? Native
        
        XCTAssertEqual(native?.charProperty, 99)
        XCTAssertEqual(native?.unsignedCharProperty, 117)
        
        XCTAssertEqual(native?.shortProperty, 1)
        XCTAssertEqual(native?.unsignedShortProperty, 2)
        XCTAssertEqual(native?.intProperty, 3)
        XCTAssertEqual(native?.unsignedIntProperty, 4)
        XCTAssertEqual(native?.integerProperty, 5)
        XCTAssertEqual(native?.unsignedIntegerProperty, 6)
        XCTAssertEqual(native?.longProperty, 7)
        XCTAssertEqual(native?.unsignedLongProperty, 8)
        XCTAssertEqual(native?.longLongProperty, 9)
        XCTAssertEqual(native?.unsignedLongLongProperty, 10)
        
        XCTAssertEqual(native?.floatProperty, 11.1)
        XCTAssertEqual(native?.cgFloatProperty, 12.2)
        XCTAssertEqual(native?.doubleProperty, 13.3)
        
        XCTAssertEqual(native?.boolProperty, true)
        XCTAssertEqual(native?.smallBoolProperty, true)
    }
    
    func testWithNativePropertyThatIsNull() {
        let mapping = MappingProvider.nativeMappingWithNullPropertie()
        let values = ["age":NSNull()]
        let cat = EKMapper.object(fromExternalRepresentation: values, with: mapping) as? Cat
        
        XCTAssertNotNil(cat)
        XCTAssertEqual(cat?.age, 0)
    }
    
    func testArrayOfObjects() {
        let info = FixtureLoader.array(fromFileNamed: "Cars.json")
        let cars = EKMapper.arrayOfObjects(fromExternalRepresentation: info, with: MappingProvider.carMapping()) as? [Car]
        
        XCTAssertEqual(cars?.count, 2)
    }
    
    func testArrayOfObjectsWithNullItems() {
        let info = FixtureLoader.optionalArray(fromFileNamed: "CarsWithNullItem.json")
        let cars = EKMapper.arrayOfObjects(fromExternalRepresentation: info.map { $0 as Any }, with: MappingProvider.carMapping()) as? [Car]
        
        XCTAssertEqual(cars?.count, info.count - 1)
    }
    
    func testDifferentSetRepresentations() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Plane.json")
        let mapping = EKObjectMapping(for: Plane.self) {
            $0.hasMany(Person.self, forKeyPath: "persons")
            $0.hasMany(Person.self, forKeyPath: "pilots")
            $0.hasMany(Person.self, forKeyPath: "stewardess")
            $0.hasMany(Person.self, forKeyPath: "stars")
        }
        let plane = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Plane
        
        XCTAssertEqual(plane?.persons.count, 3)
        XCTAssertEqual(plane?.pilots.count, 2)
        XCTAssertEqual(plane?.stewardess.count, 1)
        XCTAssertEqual(plane?.stars.count, 1)
        XCTAssert(plane?.persons is Set<Person>)
    }
    
    func testHasManyMappingWithDifferentKeyName() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Plane.json")
        let mapping = EKObjectMapping(for: Seaplane.self) {
            $0.hasMany(Person.self, forKeyPath: "persons", forProperty: "passengers")
        }
        let plane = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Seaplane
        
        XCTAssertEqual(plane?.passengers.count, 3)
    }
    
    func testHasManyMappingWithMutableArray() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Alien.json")
        let alien = EKMapper.object(fromExternalRepresentation: info, with: Alien.objectMapping()) as? Alien
        
        XCTAssertEqual(alien?.fingers.count, 2)
    }
    
    func testRecursiveHasManyMapping() {
        let info = FixtureLoader.dictionary(fromFileNamed: "CommentsRecursive.json")["comments"] as? [[String:Any]] ?? []
        let comments = EKMapper.arrayOfObjects(fromExternalRepresentation: info, with: CommentObject.objectMapping()) as? [CommentObject]
        
        XCTAssertEqual(comments?.count, 2)
        XCTAssertEqual(comments?.first?.subComments.count, 1)
        
        let firstSubSubComment = comments?.first?.subComments.first?.subComments.first
        
        XCTAssertEqual(comments?.first?.subComments?.first?.subComments.count, 1)
        XCTAssertEqual(firstSubSubComment?.name, "Bob")
        XCTAssertEqual(firstSubSubComment?.message, "It's a TRAP!")
        XCTAssertNil(firstSubSubComment?.subComments)
    }
    
    func testRecursiveHasOneMapping() {
        Person.register(MappingProvider.personWithRelativeMapping())
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonRecursive.json")
        
        let person = EKMapper.object(fromExternalRepresentation: info, with: MappingProvider.personWithRelativeMapping()) as? Person
        
        XCTAssertEqual(person?.relative.name, "Loreen")
        XCTAssertEqual(person?.relative.email, "loreen@gmail.com")
        XCTAssert(person?.relative.gender == .female)
        XCTAssertEqual(person?.children.count, 2)
        
        XCTAssertEqual(person?.children.first?.relative.name, "Alexey")
    }
    
    func testHasOneMappingWithSeveralNonNestedKeys() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonNonNested.json")
        Person.register(MappingProvider.personNonNestedMapping())
        
        let person = EKMapper.object(fromExternalRepresentation: info,
                                     with: MappingProvider.personNonNestedMapping()) as? Person
        
        XCTAssertEqual(person?.name, "Lucas")
        XCTAssertEqual(person?.car.carId, 3)
        XCTAssertEqual(person?.car.model, "i30")
        XCTAssertEqual(person?.car.year, "2013")
    }
    
    func testMapKeypathToPropertyShouldConvertPropertiesToMutableIfTheyAreMutableByDefinition() {
        let info = FixtureLoader.dictionary(fromFileNamed: "MutableFoundationClass.json")
        let instance = MutableFoundationClass(properties: info)
        
        XCTAssert(instance.array.isKind(of: NSMutableArray.self))
        XCTAssertEqual(instance.array as NSArray as? [Int] ?? [], [2,4])
        
        XCTAssert(instance.dictionary.isKind(of: NSMutableDictionary.self))
        XCTAssertEqual(instance.dictionary as? [String:String] ?? [:], ["foo":"bar"])
        
        XCTAssert(instance.mutableSet.isKind(of: NSMutableSet.self))
        XCTAssertEqual(instance.mutableSet as NSSet as? Set<String>, Set(["1"]))
        
        XCTAssert(instance.mutableOrderedSet.isKind(of: NSMutableOrderedSet.self))
        XCTAssertEqual(instance.mutableOrderedSet as NSOrderedSet, NSOrderedSet(array: [3]))
        
        XCTAssertEqual(instance.set.count, 3)
        
        XCTAssert(instance.orderedSet.isKind(of: NSOrderedSet.self))
        XCTAssertEqual(instance.mutableOrderedSet as NSOrderedSet, NSOrderedSet(array: [3]))
    }
}

class EKMapperIncrementalDataTestCase: EKMapperBaseTestCase
{
    func testHasManyMappingWithoutIncrementalData() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = MappingProvider.personMapping()
        var person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        let otherInfo = FixtureLoader.dictionary(fromFileNamed: "PersonWithOtherPhones.json")
        person = EKMapper.fillObject(person!, fromExternalRepresentation: otherInfo, with: mapping) as? Person
        
        XCTAssertEqual(person?.phones.count, 2)
    }
    func testHasManyMappingWithIncrementalData() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = MappingProvider.personMapping()
        mapping.incrementalData = true
        var person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        let otherInfo = FixtureLoader.dictionary(fromFileNamed: "PersonWithOtherPhones.json")
        person = EKMapper.fillObject(person!, fromExternalRepresentation: otherInfo, with: mapping) as? Person
        
        XCTAssertEqual(person?.phones.count, 4)
    }
    
    func testHasManyMappingEmptyAndNoIncrementalData() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = MappingProvider.personMapping()
        var person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        let otherInfo = FixtureLoader.dictionary(fromFileNamed: "PersonWithZeroPhones.json")
        person = EKMapper.fillObject(person!, fromExternalRepresentation: otherInfo, with: mapping) as? Person
        
        XCTAssertNotNil(person?.phones)
        XCTAssertEqual(person?.phones.count, 0)
    }
    
    func testHasManyMappingEmptyAndIncrementalData() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        let mapping = MappingProvider.personMapping()
        mapping.incrementalData = true
        var person = EKMapper.object(fromExternalRepresentation: info, with: mapping) as? Person
        let otherInfo = FixtureLoader.dictionary(fromFileNamed: "PersonWithZeroPhones.json")
        person = EKMapper.fillObject(person!, fromExternalRepresentation: otherInfo, with: mapping) as? Person
        
        XCTAssertEqual(person?.phones.count, 2)
    }
}

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
import EasyMapping

class EKObjectMappingTestCase: XCTestCase {
    
    func testMappingForClassConstructor() {
        let mapping = EKObjectMapping(contextProvider: EKObjectContextProvider(objectClass: Car.self))
        
        XCTAssert(mapping.objectClass == Car.self)
    }
    
    func testMappingForClassWithRootPathConstructor() {
        let mapping = EKObjectMapping(contextProvider: EKObjectContextProvider(objectClass: Car.self),
                                      rootPath: "car")
        
        XCTAssert(mapping.objectClass == Car.self)
        XCTAssertEqual(mapping.rootPath, "car")
    }
    
}

class EKObjectMappingPropertyMappingTestCase : XCTestCase {
    var mapping : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        mapping = EKObjectMapping(contextProvider: EKObjectContextProvider(objectClass: Car.self))
    }
    
    func testMapKeyPathToProperty() {
        mapping.mapKeyPath("created_at", toProperty: "createdAt")

        let sut = mapping.propertyMappings["created_at"] as? EKPropertyMapping
        
        XCTAssertEqual(sut?.keyPath, "created_at")
        XCTAssertEqual(sut?.property, "createdAt")
    }
    
    func testMapPropertiesFromArray() {
        mapping.mapProperties(from: ["name","email"])
        
        let name = mapping.propertyMappings["name"] as? EKPropertyMapping
        let email = mapping.propertyMappings["email"] as? EKPropertyMapping
        
        XCTAssertEqual(name?.keyPath, "name")
        XCTAssertEqual(name?.property, "name")
        
        XCTAssertEqual(email?.keyPath, "email")
        XCTAssertEqual(email?.property, "email")
    }
    
    func testMapPropertiesFromArrayToPascalCase() {
        mapping.mapPropertiesFromArray(toPascalCase: ["name","email"])
        
        let name = mapping.propertyMappings["Name"] as? EKPropertyMapping
        let email = mapping.propertyMappings["Email"] as? EKPropertyMapping
        
        XCTAssertEqual(name?.keyPath, "Name")
        XCTAssertEqual(name?.property, "name")
        
        XCTAssertEqual(email?.keyPath, "Email")
        XCTAssertEqual(email?.property, "email")
    }
    
    func testMapPropertiesFromUnderscoreToCamelCase() {
        mapping.mapPropertiesFromUnderscore(toCamelCase: ["model","year","created_at","car_id"])
        
        let createdAt = mapping.propertyMappings["created_at"] as? EKPropertyMapping
        let carID = mapping.propertyMappings["car_id"] as? EKPropertyMapping
        let model = mapping.propertyMappings["model"] as? EKPropertyMapping
        
        XCTAssertEqual(createdAt?.keyPath, "created_at")
        XCTAssertEqual(createdAt?.property, "createdAt")
        
        XCTAssertEqual(carID?.keyPath, "car_id")
        XCTAssertEqual(carID?.property, "carId")
        
        XCTAssertEqual(model?.keyPath, "model")
        XCTAssertEqual(model?.property, "model")
    }
    
    func testMapPropertiesFromDictionary() {
        mapping.mapProperties(from: [
                "id":"identifier",
                "contact.email":"email"
            ])
        
        let id = mapping.propertyMappings["id"] as? EKPropertyMapping
        let email = mapping.propertyMappings["contact.email"] as? EKPropertyMapping
        
        XCTAssertEqual(id?.keyPath, "id")
        XCTAssertEqual(id?.property, "identifier")
        
        XCTAssertEqual(email?.keyPath, "contact.email")
        XCTAssertEqual(email?.property, "email")
    }
    
    func testMapKeyPathToPropertyWithDateFormatter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US")
        let date = Date(timeIntervalSince1970: 0)
        let string = formatter.string(from: date)
        
        mapping.mapKeyPath("birthdate", toProperty: "birthdate", with: formatter)
        
        let sut = mapping.propertyMappings["birthdate"] as? EKPropertyMapping
        
        XCTAssertEqual(sut?.keyPath, "birthdate")
        XCTAssertEqual(sut?.property, "birthdate")
        let context = EKMappingContext(keyPath: "birthdate", value: string)
        XCTAssertEqual(sut?.valueBlock?(context) as? Date, date)
        let nilAny : String? = nil
        let nilValue = EKMappingContext(keyPath: "birthdate", value: nilAny as Any)
        XCTAssert(sut?.valueBlock?(nilValue) as? NSNull === NSNull())
        
        let intValue = EKMappingContext(keyPath: "birthdate", value: 5)
        XCTAssertNil(sut?.valueBlock?(intValue))
        
        let reverseContext = EKMappingContext(keyPath: "birthdate", value: date)
        XCTAssertEqual(sut?.reverseBlock?(reverseContext) as? String, "01 Jan 1970")
        
        let nilContext = EKMappingContext(keyPath: "birthdate", value: nilAny as Any)
        XCTAssertNil(sut?.reverseBlock?(nilContext))
        
        let intContext = EKMappingContext(keyPath: "birthdate", value: nilAny as Any)
        XCTAssertNil(sut?.reverseBlock?(intContext))
    }
    
    func testMapKeyPathToPropertyWithValueBlock() {
        let genders = ["male": Gender.male, "female":Gender.female]
        mapping.mapKeyPath("gender", toProperty: "gender") { context in
            return genders[context.value as? String ?? ""]
        }
        
        let sut = mapping.propertyMappings["gender"] as? EKPropertyMapping
        
        let context = EKMappingContext(keyPath: "gender", value: "male")
        XCTAssert(sut?.valueBlock?(context) as? Gender == Gender.male)
    }
    
    func testMapKeypathToPropertyWithValueBlockReverseBlock() {
        let genders = ["male": Gender.male, "female":Gender.female]
        mapping.mapKeyPath("gender", toProperty: "gender", withValueBlock: { context in
            return genders[context.value as? String ?? ""]
        }, reverse: { context in
            return genders.filter({ key,value in
                value == context.value as? Gender
            }).map { $0.0 }.first
        })
        
        let sut = mapping.propertyMappings["gender"] as? EKPropertyMapping
        
        
        XCTAssert(sut?.valueBlock?(EKMappingContext(keyPath: "gender", value: "male")) as? Gender == Gender.male)
        XCTAssertEqual(sut?.reverseBlock?(EKMappingContext(keyPath: "gender", value: Gender.male)) as? String, "male")
        XCTAssertEqual(sut?.reverseBlock?(EKMappingContext(keyPath: "gender", value: Gender.female)) as? String, "female")
    }
    
    func testMapPropertiesFromMappingObject() {
        let ufo = EKObjectMapping(contextProvider: EKObjectContextProvider(objectClass: ColoredUFO.self))
        ufo.mapProperties(fromMappingObject: UFO.objectMapping())
        
        let shape = ufo.propertyMappings["shape"] as? EKPropertyMapping
        let captain = ufo.hasOneMappings.firstObject as? EKRelationshipMapping
        let crew = ufo.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(shape?.keyPath, "shape")
        XCTAssertEqual(shape?.property, "shape")
        
        XCTAssertEqual(captain?.keyPath, "captain")
        XCTAssertEqual(captain?.property, "captain")
        
        XCTAssertEqual(crew?.keyPath, "crew")
        XCTAssertEqual(crew?.property, "crew")
    }
}

class EKObjectMappingRelationshipsMappingTestCase : XCTestCase {
    var sut : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        sut = MappingProvider.personMapping()
    }
    
    func testHasOneMappingForKey() {
        XCTAssertEqual(sut.hasOneMappings.count, 1)
        
        let car = sut.hasOneMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(car?.keyPath, "car")
        XCTAssertEqual(car?.property, "car")
    }
    
    func testHasOneMappingForKeypathForProperty() {
        sut.hasOneMappings.removeAllObjects()
        
        sut.hasOne(Car.self, forKeyPath: "car", forProperty:"personCar")
        
        let car = sut.hasOneMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(car?.keyPath, "car")
        XCTAssertEqual(car?.property, "personCar")
    }
    
    func testHasManyMappingForKeypathForProperty() {
        sut.hasManyMappings.removeAllObjects()
        
        sut.hasMany(Phone.self, forKeyPath: "phones", forProperty:"personPhones")
        
        let car = sut.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(car?.keyPath, "phones")
        XCTAssertEqual(car?.property, "personPhones")
    }
    
    func testHasManyMappingForKey() {
        XCTAssertEqual(sut.hasManyMappings.count, 1)
        let phones = sut.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssertEqual(phones?.keyPath, "phones")
        XCTAssertEqual(phones?.property, "phones")
    }
}

class EKObjectMappingCustomRElationshipsMappingTestCase : XCTestCase {
    var person : EKObjectMapping!
    var phone : EKObjectMapping!
    
    override func setUp() {
        super.setUp()
        person = EKObjectMapping(contextProvider: EKObjectContextProvider(objectClass: Person.self))
        phone = Phone.objectMapping()
    }
    
    func testHasOneCarMappingWithPhoneSubstitution() {
        person.hasOne(Car.self, forKeyPath: "phone", forProperty: "car", with: phone)
        
        let sut = person.hasOneMappings.firstObject as? EKRelationshipMapping
        
        XCTAssert(sut?.mapping(for: sut as Any) === phone)
        XCTAssertEqual(sut?.keyPath, "phone")
        XCTAssertEqual(sut?.property, "car")
    }
    
    func testHasManyPhoneMappingWithCarSubstitution() {
        person.hasMany(Car.self, forKeyPath: "phone", forProperty: "car", with: phone)
        
        let sut = person.hasManyMappings.firstObject as? EKRelationshipMapping
        
        XCTAssert(sut?.mapping(for: sut as Any) === phone)
        XCTAssertEqual(sut?.keyPath, "phone")
        XCTAssertEqual(sut?.property, "car")
    }
}

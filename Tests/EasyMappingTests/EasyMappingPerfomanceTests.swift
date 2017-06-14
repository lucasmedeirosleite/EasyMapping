//
//  EasyMappingPerfomanceTests.swift
//  EasyMapping
//
//  Created by Denys Telezhkin on 28.04.17.
//  Copyright © 2017 EasyMapping. All rights reserved.
//

import XCTest

class EasyMappingNSObjectPerfomanceTests: XCTestCase {
    
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
    
    func benchmark(fixture: String, mapping: EKObjectMapping, times: Int) {
        let info = FixtureLoader.dictionary(fromFileNamed: fixture)
        
        for _ in 0...times {
            _ = EKMapper(mappingStore: EKObjectStore()).object(fromExternalRepresentation: info, with: mapping)
        }
    }
    
    func testCar() {
        measure {
            self.benchmark(fixture: "Car.json", mapping: MappingProvider.carMapping(), times: 1000)
        }
    }
    
    func testCarWithRoot() {
        measure {
            self.benchmark(fixture: "CarWithRoot.json", mapping: MappingProvider.carWithRootKeyMapping(), times: 1000)
        }
    }
    
    func testCarWithNestedAttributes() {
        measure {
            self.benchmark(fixture: "CarWithNestedAttributes.json", mapping: MappingProvider.carNestedAttributesMapping(), times: 1000)
        }
    }
    
    func testCarWithDate() {
        measure {
            self.benchmark(fixture: "CarWithDate.json", mapping: MappingProvider.carWithDateMapping(), times: 1000)
        }
    }
    
    func testPerson() {
        measure {
            self.benchmark(fixture: "Person.json", mapping: MappingProvider.personMapping(), times: 1000)
        }
    }
    
    func testPersonWithNullPhones() {
        measure {
            self.benchmark(fixture: "PersonWithNullPhones.json", mapping: MappingProvider.personWithCarMapping(), times: 1000)
        }
    }
    
    func testPersonWithNullCar() {
        measure {
            self.benchmark(fixture: "PersonWithNullCar.json", mapping: MappingProvider.personWithPhonesMapping(), times: 1000)
        }
    }
    
    func testMale() {
        measure {
            self.benchmark(fixture: "Male.json", mapping: MappingProvider.personWithOnlyValueBlockMapping(), times: 1000)
        }
    }
    
    func testAddress() {
        measure {
            self.benchmark(fixture: "Address.json", mapping: MappingProvider.addressMapping(), times: 1000)
        }
    }
    
    func testNative() {
        measure {
            self.benchmark(fixture: "Native.json", mapping: Native.objectMapping(), times: 1000)
        }
    }
    
    func testPlane() {
        measure {
            self.benchmark(fixture: "Plane.json", mapping: Plane.objectMapping(), times: 1000)
        }
    }
    
    func testAlien() {
        measure {
            self.benchmark(fixture: "Alien.json", mapping: Alien.objectMapping(), times: 1000)
        }
    }
    
    func testNativeChild() {
        measure {
            self.benchmark(fixture: "NativeChild.json", mapping: NativeChild.objectMapping(), times: 1000)
        }
    }
}

class EasyMappingCoreDataPerfomanceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        ManagedCar.register(ManagedMappingProvider.carMapping())
        ManagedPhone.register(ManagedMappingProvider.phoneMapping())
        ManagedPerson.register(ManagedMappingProvider.personMapping())
        
        EKCoreDataManager.sharedInstance().deleteAllObjectsInCoreData()
    }
    
    override func tearDown() {
        super.tearDown()
        ManagedCar.register(nil)
        ManagedPhone.register(nil)
        ManagedPerson.register(nil)
    }
    
    func benchmark(fixture: String, mapping: EKObjectMapping, times: Int) {
        let info = FixtureLoader.dictionary(fromFileNamed: fixture)
        let store = EKManagedObjectStore(context: EKCoreDataManager.sharedInstance().managedObjectContext)
        let mapper = EKMapper(mappingStore: store)
        for _ in 0...times {
            _ = mapper.object(fromExternalRepresentation: info, with: mapping)
            _ = try? EKCoreDataManager.sharedInstance().managedObjectContext.save()
        }
    }
    
    func testCar() {
        measure {
            self.benchmark(fixture: "Car.json", mapping: ManagedMappingProvider.carMapping(), times: 100)
        }
    }
    
    func testCarWithRoot() {
        measure {
            self.benchmark(fixture: "CarWithRoot.json", mapping: ManagedMappingProvider.carWithRootKeyMapping(), times: 100)
        }
    }
    
    func testCarWithNestedAttributes() {
        measure {
            self.benchmark(fixture: "CarWithNestedAttributes.json", mapping: ManagedMappingProvider.carNestedAttributesMapping(), times: 100)
        }
    }
    
    func testCarWithDate() {
        measure {
            self.benchmark(fixture: "CarWithDate.json", mapping: ManagedMappingProvider.carWithDateMapping(), times: 100)
        }
    }
    
    func testPerson() {
        measure {
            self.benchmark(fixture: "Person.json", mapping: ManagedMappingProvider.personMapping(), times: 100)
        }
    }
    
    func testPersonWithNullPhones() {
        measure {
            self.benchmark(fixture: "PersonWithNullPhones.json", mapping: ManagedMappingProvider.personWithCarMapping(), times: 100)
        }
    }
    
    func testPersonWithNullCar() {
        measure {
            self.benchmark(fixture: "PersonWithNullCar.json", mapping: ManagedMappingProvider.personWithPhonesMapping(), times: 100)
        }
    }
    
    func testMale() {
        measure {
            self.benchmark(fixture: "Male.json", mapping: ManagedMappingProvider.personWithOnlyValueBlockMapping(), times: 100)
        }
    }
    
    var importData : [[String:Any]] {
        return (0...5000).map { index in
            [
                "id":index,
                "name":"Name \(index)",
                "email":"\(index)@email.com",
                "phones": [
                    [
                        "id":index*5,
                        "number":"11111",
                        "ddi":"ddivalue \(index*5)",
                        "ddd":"dddvalue" ],
                    [
                        "id":index*5+1,
                        "number":"11111",
                        "ddi":"ddivalue \(index*5 + 1)",
                        "ddd":"dddvalue"
                    ],
                    [
                        "id":index*5+2,
                        "number":"11111",
                        "ddi":"ddivalue \(index*5 + 2)",
                        "ddd":"dddvalue"
                    ],
                    [
                        "id":index*5+3,
                        "number":"11111",
                        "ddi":"ddivalue \(index*5 + 3)",
                        "ddd":"dddvalue"
                    ],
                    [
                        "id":index*5+4,
                        "number":"11111",
                        "ddi":"ddivalue \(index*5 + 4)",
                        "ddd":"dddvalue"
                    ]
                ]
            ]
        }
    }
    
    func testCoreDataImport() {
        let store = EKManagedObjectStore(context: EKCoreDataManager.sharedInstance().managedObjectContext)
        let mapper = EKMapper(mappingStore: store)
        let data = self.importData
        measure {
            mapper.arrayOfObjects(fromExternalRepresentation: data,
                                                 with: ManagedMappingProvider.personWithPhonesMapping())
        }
    }
}

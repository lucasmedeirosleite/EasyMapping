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

class EKCoreDataImporterTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        ManagedPerson.register(ManagedMappingProvider.personMapping())
        ManagedCar.register(ManagedMappingProvider.carMapping())
        ManagedPhone.register(ManagedMappingProvider.phoneMapping())
    }
    
    override func tearDown() {
        super.tearDown()
        ManagedPerson.register(nil)
        ManagedCar.register(nil)
        ManagedPhone.register(nil)
    }
    
    func testImporterIsAbleToCollectEntityNames() {
        let importer = EKCoreDataImporter(mapping: ManagedMappingProvider.personMapping(), externalRepresentation: [:], context: Storage.shared.context)
        
        XCTAssertEqual(importer.entityNames, Set(["ManagedPerson", "ManagedCar", "ManagedPhone"]))
    }
    
    func testImporterAbleToCollectEntitiesWithRootKey() {
        let importer = EKCoreDataImporter(mapping: ManagedMappingProvider.carWithRootKeyMapping(), externalRepresentation: [:], context: Storage.shared.context)
        
        XCTAssertEqual(importer.entityNames, Set(["ManagedCar"]))
    }
    
    func testImporterCanCollectEntitiesWithComplexStructure() {
        let mapping = EKManagedObjectMapping(entityName: "ManagedPerson")
        ManagedCar.register(ManagedMappingProvider.carWithRootKeyMapping())
        mapping.hasOne(ManagedCar.self, forKeyPath: "car")
        mapping.hasOne(ManagedPhone.self, forKeyPath: "phone")
        let addressMapping = EKManagedObjectMapping(forEntityName: "Address") {
            $0.hasOne(ManagedPerson.self, forKeyPath: "postman")
        }
        Address.register(addressMapping)
        mapping.hasOne(Address.self, forKeyPath: "addressBook")
        
        let sut = EKCoreDataImporter(mapping: mapping, externalRepresentation: [:],
                                     context: Storage.shared.context)
        
        XCTAssertEqual(sut.entityNames, Set(["ManagedPerson","ManagedCar","ManagedPhone","Address"]))
    }
    
    func testImporterIsAbleToCollectFromRecursiveMapping() {
        let sut = EKCoreDataImporter(mapping: One.objectMapping(), externalRepresentation: [:], context: Storage.shared.context)
        
        XCTAssertEqual(sut.entityNames, Set(["One","Two", "Three"]))
    }
    
    func testImporterIsAbleToCollectEntitiesWithRootKeypath() {
        let info = FixtureLoader.json(fromFileNamed: "CarWithRoot.json")
        
        let sut = EKCoreDataImporter(mapping: ManagedMappingProvider.carWithRootKeyMapping(), externalRepresentation: info, context: Storage.shared.context)
        
        XCTAssertEqual(sut.existingEntitiesPrimaryKeys, ["ManagedCar":Set([1])])
    }
    
    func testImporterIsAbleToCollectEntitiesFromArrayOfObjects() {
        let info = FixtureLoader.array(fromFileNamed: "Cars.json")
        
        let sut = EKCoreDataImporter(mapping: ManagedMappingProvider.carMapping(),
                                     externalRepresentation: info,
                                     context: Storage.shared.context)
        
        XCTAssertEqual(sut.existingEntitiesPrimaryKeys, ["ManagedCar":Set([1,2])])
    }
    
    func testShouldCollectEntitiesFromHasOneAndHasManyRelationships() {
        let info = FixtureLoader.dictionary(fromFileNamed: "Person.json")
        
        let sut = EKCoreDataImporter(mapping: ManagedMappingProvider.personMapping(),
                                     externalRepresentation: info,
                                     context: Storage.shared.context)
        
        XCTAssertEqual(sut.existingEntitiesPrimaryKeys, [
            "ManagedCar":Set([3]),
            "ManagedPerson":Set([23]),
            "ManagedPhone":Set([1,2])
        ])
    }
    
    func testShouldCollectEntitiesRecursively() {
        let info = FixtureLoader.dictionary(fromFileNamed: "ComplexRepresentation.json")
        Plane.register(ManagedMappingProvider.complexPlaneMapping())
        defer { Plane.register(nil) }
        
        let sut = EKCoreDataImporter(mapping: ManagedMappingProvider.complexPlaneMapping(),
                                     externalRepresentation: info,
                                     context: Storage.shared.context)
        
        XCTAssertEqual(sut.existingEntitiesPrimaryKeys, [
            "ManagedCar":Set([3,8]),
            "ManagedPerson":Set([3,17,89]),
            "ManagedPhone":Set([1,2,4,5]),
            "Plane":Set<Int>()
        ])
    }
    
    func testShouldCollectEntitiesWhenHasOneMappingHasNull() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithNullCar.json")
        
        let sut = EKCoreDataImporter(mapping: ManagedMappingProvider.personMapping(),
                                     externalRepresentation: info,
                                     context: Storage.shared.context)
        
        XCTAssertEqual(sut.existingEntitiesPrimaryKeys, [
            "ManagedCar":Set<Int>(),
            "ManagedPerson":Set([5]),
            "ManagedPhone":Set([6,7])
        ])
    }
    
    func testShouldCollectEntitiesWhenHasManyMappingHasNull() {
        let info = FixtureLoader.dictionary(fromFileNamed: "PersonWithNullPhones.json")
        
        let sut = EKCoreDataImporter(mapping: ManagedMappingProvider.personMapping(),
                                     externalRepresentation: info,
                                     context: Storage.shared.context)
        
        XCTAssertEqual(sut.existingEntitiesPrimaryKeys, [
            "ManagedCar":Set([56]),
            "ManagedPerson":Set([23]),
            "ManagedPhone":Set<Int>()
        ])
    }
}

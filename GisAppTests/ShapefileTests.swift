//
//  ShapefileTests.swift
//  GisAppTests
//
//  Created by Sebastian Wiatrzyk on 15/05/2021.
//

import XCTest

class ShapefileTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // http://www.arcgis.com/home/item.html?id=a5067fb3b0b74b188d7b650fa5c64b39
    
    func testRecords() {
        let path = Bundle(for: ShapefileTests.self).path(forResource:"Kantone", ofType: "shp")!
        
        let sr = try! ShapefileReader(path:path)

        XCTAssertEqual(sr.dbf!.numberOfRecords, 26)

        let records = try! sr.dbf!.allRecords()
        XCTAssertEqual(records.count, 26)

        let rec = try! sr.dbf!.recordAtIndex(1)
        XCTAssertEqual(rec[1] as? String, "BE")

        print("\(#function) pass")
    }

    func testShapes() {
        let path = Bundle(for: ShapefileTests.self).path(forResource:"Kantone", ofType: "shp")!
        
        let sr = try! ShapefileReader(path:path)

        let shapes = sr.shp!.allShapes()
        XCTAssertEqual(shapes.count, 26)
        
        let shape2 = shapes[2]
        XCTAssertEqual(shape2.shapeType, ShapeType.polygon)
        XCTAssertEqual(shape2.parts.count, 5)
        XCTAssertEqual(shape2.points.count, 531)
        XCTAssert(shape2.bbox.x_max > 0)
        
        XCTAssertEqual(sr.shp.allShapes().count, try! sr.dbf!.allRecords().count)
    }

    func testShx() {
        let path = Bundle(for: ShapefileTests.self).path(forResource:"Kantone", ofType: "shp")!
        
        let sr = try! ShapefileReader(path:path)

        let offset = sr.shx!.shapeOffsetAtIndex(2)!
        let (_, shape2_) = try! sr.shp!.shapeAtOffset(UInt64(offset))!
        
        let shape2__ = sr.shp!.allShapes()[2]
        let shape2___ = sr[2]!

        XCTAssertEqual(shape2_.parts.count, shape2__.parts.count)
        XCTAssertEqual(shape2_.points.count, shape2__.points.count)
        XCTAssertEqual(shape2_.parts.count, shape2___.parts.count)
        XCTAssertEqual(shape2_.points.count, shape2___.points.count)
        
        XCTAssertEqual(sr.dbf!.numberOfRecords, sr.shx!.numberOfShapes)
    }
    
}

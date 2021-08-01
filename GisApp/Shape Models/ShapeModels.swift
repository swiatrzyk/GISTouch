//
//  ShapeModels.swift
//  GisApp
//
//  Created by Sebastian Wiatrzyk on 01/08/2021.
//

import Foundation

/// Based on ESRI Shapefile documentation: https://www.esri.com/content/dam/esrisites/sitecore-archive/Files/Pdfs/library/whitepapers/pdfs/shapefile.pdf
enum ShapeModels {
    struct BoundingBox {
        let xMin: Double
        let yMin: Double
        let xMax: Double
        let yMax: Double
    }
    
    struct Bounding {
        let mMin: Double
        let mMax: Double
    }
    
    // MARK: - Shape types
    /*
     Point {
        Double  X   // X coordinate
        Double  Y   // Y coordinate
     }
     */
    struct Point {
        let x: Double
        let y: Double
    }
    
    /*
     MultiPoint {
         Double[4]             Box              // Bounding Box
         Integer               NumPoints        // Number of Points
         Point[NumPoints]      Points           // The Points in the Set
     }
     */
    struct MultiPoint {
        let boundingBox: Bounding
        let points: [Point] // 🚧 chante to `Set`
    }
    
    
    /*
     PolyLine
     {
        Double[4]            Box            // Bounding Box
        Integer              NumParts       // Number of Parts
        Integer              NumPoints      // Total Number of Points
        Integer[NumParts]    Parts          // Index to First Point in Part
        Point[NumPoints]     Points         // Points for All Parts
     }
     */
    struct Polyline {
        let boundingBox: Bounding
        let parts: [Int]
        let points: [Point]
    }
    
    /*
     Polygon
     {
        Double[4]            Box             // Bounding Box
        Integer              NumParts        // Number of Parts
        Integer              NumPoints       // Total Number of Points
        Integer[NumParts]    Parts           // Index to First Point in Part
        Point[NumPoints]     Points          // Points for All Parts
     }
     */
    struct Polygon {
        let parts: [Int]
        let points: [Point]
    }
    
    /*
     PointM
     {
        Double    X    // X coordinate
        Double    Y    // Y coordinate
        Double    M    // Measure
     }
     */
    struct PointM {
        let x: Double
        let y: Double
        let m: Double
    }
    
    
    /*
     MultiPointM
     {
        Double[4]            Box            // Bounding Box
        Integer              NumPoints      // Number of Points
        Point[NumPoints]     Points         // The Points in the Set
        Double[2]            M Range        // Bounding Measure Range
        Double[NumPoints]    M Array        // Measures
     }
     */
    struct MultiPointM {
        let box: BoundingBox
        let points: [Point] // 🚧 chante to `Set`
        let boundingMeasure: Bounding
        let measures: [Double]
    }
    
    /*
     PolyLineM
     {
        Double[4]           Box          // Bounding Box
        Integer             NumParts     // Number of Parts
        Integer             NumPoints    // Total Number of Points
        Integer[NumParts]   Parts        // Index to First Point in Part
        Point[NumPoints]    Points       // Points for All Parts
        Double[2]           M Range      // Bounding Measure Range
        Double[NumPoints]   M Array      // Measures for All Points
     }
     */
    struct PolyLineM {
        let box: BoundingBox
        let points: [Point] // 🚧 chante to `Set`
        let boundingMeasure: Bounding
        let measures: [Double]
    }
    
    /*
     PolygonM
     {
        Double[4]           Box          // Bounding Box
        Integer             NumParts     // Number of Parts
        Integer             NumPoints    // Total Number of Points
        Integer[NumParts]   Parts        // Index to First Point in Part
        Point[NumPoints]    Points       // Points for All Parts
        Double[2]           M Range      // Bounding Measure Range
        Double[NumPoints]   M Array      // Measures for All Points
     }
     */
    struct PolygonM {
        let box: BoundingBox
        let points: [Point] // 🚧 chante to `Set`
        let boundingMeasure: Bounding
        let measures: [Double]
    }
    
    /*
     PointZ
     {
         Double    X    // X coordinate
         Double    Y    // Y coordinate
         Double    Z    // Z coordinate
         Double    M    // Measure
     }
     */
    struct PointZ {
        let x: Double
        let y: Double
        let z: Double
        let m: Double
    }
    
    /*
     MultiPointM
     {
        Double[4]            Box            // Bounding Box
        Integer              NumPoints      // Number of Points
        Point[NumPoints]     Points         // The Points in the Set
        Double[2]            Z Range        // Bounding Z Range
        Double[NumPoints]    Z Array        // Z Values
        Double[2]            M Range        // Bounding Measure Range
        Double[NumPoints]    M Array        // Measures
     }
     */
    struct MultiPointZ {
        let boundingBox: Bounding
        let points: [Point] // 🚧 chante to `Set`
        let boudingZ: Bounding
        let zValues: [Double]
        let measureBouding: Bounding
        let meazures: [Double]
    }
    
    /*
     PolyLineZ
     {
        Double[4]           Box          // Bounding Box
        Integer             NumParts     // Number of Parts
        Integer             NumPoints    // Total Number of Points
        Integer[NumParts]   Parts        // Index to First Point in Part
        Point[NumPoints]    Points       // Points for All Parts
        Integer             Z Range      // Bounding Z Range
        Integer             Z Array      // Z Values for All Points
        Double[2]           M Range      // Bounding Measure Range
        Double[NumPoints]   M Array      // Measures for All Points
     }
     */
    struct PolyLineZ {
        let box: BoundingBox
        let points: [Point] // 🚧 chante to `Set`
        let boudingZ: Bounding
        let zValues: [Double]
        let boundingMeasure: Bounding
        let measures: [Double]
    }
    
    /*
     PolygonZ
     {
        Double[4]           Box          // Bounding Box
        Integer             NumParts     // Number of Parts
        Integer             NumPoints    // Total Number of Points
        Integer[NumParts]   Parts        // Index to First Point in Part
        Point[NumPoints]    Points       // Points for All Parts
        Integer             Z Range      // Bounding Z Range
        Integer             Z Array      // Z Values for All Points
        Double[2]           M Range      // Bounding Measure Range
        Double[NumPoints]   M Array      // Measures for All Points
     }
     */
    struct PolygonZ {
        let box: BoundingBox
        let points: [Point] // 🚧 chante to `Set`
        let boudingZ: Bounding
        let zValues: [Double]
        let boundingMeasure: Bounding
        let measures: [Double]
    }
    
    /*
     MultiPatch
     {
        Double[4]            Box         // Bounding Box
        Integer              NumParts    // Number of Parts
        Integer              NumPoints   // Total Number of Points
        Integer[NumParts]    Parts       // Index to First Point in Part
        Integer[NumParts]    PartTypes   // Part Type
        Point[NumPoints]     Points      // Points for All Parts
        Double[2]            Z Range     // Bounding Z Range
        Double[NumPoints]    Z Array     // Z Values for All Points
        Double[2]            M Range     // Bounding Measure Range
        Double[NumPoints]    M Array     // Measures
     }
     */
    struct MultiPatch {
        let boundingBox: BoundingBox
        let parts: [Int]
        let partsTypes: [PartTypes]
        let points: [Point]
        let boundingZ: Bounding
        let zValues: [Double]
        let boundingMeasure: Bounding
        let measures: [Double]
    }
    
    enum PartTypes: Int {
        case triangleFan = 1
        case outerRing = 2
        case innerRing = 3
        case firstRing = 4
        case ring = 5
    }
}

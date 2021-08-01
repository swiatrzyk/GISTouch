//
//  ShplipAdapter.swift
//  
//
//  Created by Sebastian Wiatrzyk on 01/08/2021.
//

import Foundation

class ShplibAdapter {
    static func getPolygonsFromShapeFile(shpFilePath: String) -> [MKPolygon] {
        let path = shpFilePath.cString(using: .utf8)
        let shp = SHPOpen(path, "rb")
        var numEntities: Int32 = 0
        var shapeType: Int32 = 0
        SHPGetInfo(shp, &numEntities, &shapeType, nil, nil)
        var allPolygons = [MKPolygon]()
        for index in 0..<numEntities {
            let shpObject: SHPObject = SHPReadObject(shp, Int32(index)).pointee
            switch shpObject.nSHPType {
            case SHPT_POLYGON, SHPT_POLYGONZ, SHPT_POLYGONM:
                let partsAmount = Int(shpObject.nParts)
                let totalVertexAmount = Int(shpObject.nVertices)
                for n in 0..<partsAmount {
                    let startVertexIndex = Int(shpObject.panPartStart[n])
                    let partVertexCount: Int
                    let isLastIteration: Bool = n == partsAmount - 1
                    if isLastIteration {
                        partVertexCount = totalVertexAmount - startVertexIndex
                    } else {
                        partVertexCount = Int(shpObject.panPartStart[n + 1]) - startVertexIndex
                    }
                    let endVertexIndex = startVertexIndex + partVertexCount
                    var coordinates = [CLLocationCoordinate2D]()
                    for vertexIndex in startVertexIndex..<endVertexIndex {
                        let coordinate = CLLocationCoordinate2D(latitude: shpObject.padfY[vertexIndex],
                                                                longitude: shpObject.padfX[vertexIndex])
                        coordinates.append(coordinate)
                    }
                    let polygon = MKPolygon(coordinates: &coordinates,
                                            count: partVertexCount)
                    allPolygons.append(polygon)
                }
            default:
                L.logger.warning("Uknown shape type")
                break
            }
        }
        return allPolygons
    }
}

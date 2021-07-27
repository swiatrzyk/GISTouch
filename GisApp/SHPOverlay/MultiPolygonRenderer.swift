//
//  MultiPolygonRenderer.swift
//  GisApp
//
//  Created by Sebastian Wiatrzyk on 27/07/2021.
//

import MapKit

class MultiPolygonRenderer : MKOverlayPathRenderer {
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        if let multiPolygon = self.overlay as? MultiPolygonOverlay {
            for polygon in multiPolygon.polygons {
                let boundRect = polygon.boundingMapRect
                
                if  boundRect.intersects(mapRect) {
                    if let path = self.polyPath(polygon: polygon) {
                        self.applyFillProperties(to: context, atZoomScale:zoomScale)
                        context.beginPath()
                        context.addPath(path)
                        context.drawPath(using: .eoFill)
                        self.applyStrokeProperties(to: context, atZoomScale:zoomScale)
                        context.beginPath()
                        context.addPath(path)
                        context.strokePath()
                    }
                }
            }
        } else {
            L.logger.warning("Unknown overlay object: \(overlay)")
            return
        }
    }
    
    func polyPath(polygon: MKPolygon) -> CGPath? {
        let points = polygon.points()
        let pointCount = polygon.pointCount
        
        if pointCount < 3 {
            L.logger.warning("Points in polygon less than 3 for polygon object: \(polygon)")
            return nil
        }
        
        let path = CGMutablePath()
        
        for interiorPolygon in polygon.interiorPolygons ?? [MKPolygon]() {
            if let interiorPath = polyPath(polygon: interiorPolygon) {
                path.addPath(interiorPath)
            }
        }
        
        var relativePoint = self.point(for: points[0])
        path.move(to: CGPoint(x: relativePoint.x, y: relativePoint.y))
        for point in UnsafeBufferPointer(start: points, count: pointCount) {
            relativePoint = self.point(for: point)
            path.addLine(to: CGPoint(x: relativePoint.x, y: relativePoint.y))
        }
        return path
    }
}

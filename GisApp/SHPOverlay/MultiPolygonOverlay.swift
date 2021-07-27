
class MultiPolygonOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D {
        get { 
            MKMapPoint(x: boundingMapRect.midX, y: boundingMapRect.midY).coordinate

        }
    }

    var polygons = [MKPolygon]()
    var boundingMapRect = MKMapRect()
    
    //------------------------------------------------------
    init(with filePath: String) {
        super.init()
        polygons = getPolygons(from: filePath)
        for polygon in polygons {
            boundingMapRect = boundingMapRect.union(polygon.boundingMapRect)
        }
    }
    
    private func getPolygons(from filePath: String) -> [MKPolygon] {
        return getPolygonsFromShapeFile(filePath).compactMap({ overlay in
            guard let overlay = overlay as? MKPolygon else {
                L.logger.warning("⚠️ Method `getPolygonsFromShapeFile` failed to parse to `MKOverlay` for object: \(overlay)")
                return nil
            }
            return overlay
        })
    }
    //------------------------------------------------------
//    init(polygons:[AnyObject]!) {
//        if (self = super.init() != nil) {
//            _polygons = polygons.copy()
//
//            let polyCount:UInt = _polygons.count()
//            if (polyCount != 0) {
//                _boundingMapRect = _polygons.objectAtIndex(0).boundingMapRect()
//                var i:UInt
//                for  ; i < polyCount ; i++ {
//                    _boundingMapRect = MKMapRectUnion(_boundingMapRect, _polygons.objectAtIndex(i).boundingMapRect())
//                 }
//            }
//        }
//        return self
//    }
    //-----------------------------------------------------------
}

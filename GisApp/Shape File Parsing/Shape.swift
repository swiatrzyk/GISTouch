
import Foundation

class Shape {
    
    init(type: ShapeType = .nullShape) {
        self.shapeType = type
    }
    
    var shapeType: ShapeType
    var points: [MapPoint] = []
    var bbox: (x_min:Double, y_min:Double, x_max:Double, y_max:Double) = (0.0,0.0,0.0,0.0)
    var parts: [Int] = []
    var partTypes: [Int] = []
    var z: Double = 0.0
    var m: [Double?] = []
    
    func partPointsGenerator() -> AnyIterator<[MapPoint]> {
        
        var indices = Array(self.parts)
        indices.append(self.points.count-1)
        
        var i = 0
        
        return AnyIterator {
            if self.shapeType.hasParts == false { return nil }
            
            if i == indices.count - 1 { return nil }
            
            let partPoints = Array(self.points[indices[i]..<indices[i+1]])
            
            i += 1
            
            return partPoints
        }
    }
}

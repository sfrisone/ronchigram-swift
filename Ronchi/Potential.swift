//
//  Potential.swift
//  Ronchigram
//
//  Created by James LeBeau on 5/24/17.
//  Copyright © 2017 The Handsome Microscopist. All rights reserved.
//
/*
import Foundation
import MathFramework


public class Potential: NSObject {
    
    public var potential:Matrix
    public var subpotential:Matrix
    public var atoms:Array<Any>
    public var realSize:NSSize
    
    override init() {
        potential = Matrix(512, 512, "complex")
        subpotential = Matrix(11, 11, "complex")
        atoms = []
        realSize.width = CGFloat(potential.columns)
        realSize.height = CGFloat(potential.rows)
    }
    
    public func initWithPixels (_ size:NSSize, _ rSize:NSSize) -> () {
        
    }
    
    func returnPotential() -> (Potential) {
        return self
    }
    
    func potentialWithAtoms(_ inputAtoms:Array<Any>) {
        self.atoms = inputAtoms
        self.calculateSubPotential()
    }
    
    func calculateSubPotential() {
        
        let numPixX = Float(self.potential.columns)
        let numPixY = Float(self.potential.rows)
        var oldValue:Double
        var newValue:Double
        
        let cols = self.potential.columns
        
        var potCalcPoint:NSPoint
        
        let pixSizeX = numPixX/Float(realSize.width)
        let pixSizeY = numPixY/Float(realSize.height)
        
        let pixCalcRangeX = self.subpotential.rows
        let pixCalcRangeY = self.subpotential.columns
        
        let atomicNumber = 6
        
        for i in 0..<pixCalcRangeY {
            for j in 0..<pixCalcRangeX {
                
                potCalcPoint.x = CGFloat(Float(j - (pixCalcRangeX/2))/pixSizeX)
                potCalcPoint.y = CGFloat(Float(i - (pixCalcRangeY/2))/pixSizeY)
                
                oldValue = Double(subpotential.real[cols*i + j])
                newValue = projectedPotentialForZ(atomicNumber, potCalcPoint)
                
                self.subpotential.real[cols*i + j] = Float(oldValue + newValue)
            }
            
            self.fillPotentialMatrix()
        }
    }
    
    func randomPotentialWithDensity (_ density:Float, _ withZ:Int) -> () {
        
        let numPots = lroundf(density*Float(realSize.width)*Float(realSize.height))
        
        let potCenter:NSPoint
        
        var newAtom = [String: NSNumber]()
        var newAtoms = [Any]()
        
        for k in 0..<numPots {
            
            potCenter.x = CGFloat(arc4random() % 10000 / UInt32(10000.0)) * realSize.width
            potCenter.y = CGFloat(arc4random() % 10000 / UInt32(10000.0)) * realSize.height
            
            let intermediateX = Float(potCenter.x)
            let intermediateY = Float(potCenter.y)
            
            newAtom["KSAPotCenterX"] = NSNumber.init(value:intermediateX)
            newAtom["KSAPotCenterY"] = NSNumber.init(value:intermediateY)
            newAtom["KSAAtomicNumber"] = NSNumber.init(value:6)
            
            newAtoms.append(newAtom)
        }
        self.potentialWithAtoms(newAtoms)
    }
    
    
    
    func fillPotentialMatrix() {
        
        let numPixX = self.subpotential.columns
        let numPixY = self.subpotential.rows
        let numPots = self.atoms.count
        
        // potCener:NSPoint = potCenter, potCorner
        
        for k in 0..<numPots {
            
        }
        
    }
    
    
    
}


*/





//
//  Matrix.swift
//  newRonchi
//
//  Created by LeBeau Group iMac on 8/25/17.
//  Copyright © 2017 LeBeau Group iMac. All rights reserved.
//

import Foundation
import Cocoa
import Accelerate





struct MatrixConstant {
    static let elementwise = "element-wise"
    static let product = "product"
}

struct MatrixOutput {
    static let uint16 = 16
    static let uint8 = 8
    static let float = 32
}

infix operator .*



// Setting up the class of objects Matrix

public class Matrix: CustomStringConvertible , CustomPlaygroundQuickLookable  {
    
    // Properties:
    //   number of rows and columns, number of elements,
    //   is it complex or real, maximum and mimimum element
    
    public let rows:Int
    public let columns:Int
    public var type:String
    
    public var real:Array<Float>
    public var imag:Array<Float>?
    
    public var count:Int {
        return rows*columns
    }
    
    var complex:Bool {
        if (imag as [Float]?) != nil {
            return true
        } else {
            return false
        }
    }
    
    public var max:Complex {
        
        var maxValue = Complex(0,0)
        
        let length = vDSP_Length(count)
        
        if type == "real" {
            vDSP_maxv(real, 1, &maxValue.a, length)
        } else {
            vDSP_maxv(real, 1, &maxValue.a, length)
            vDSP_maxv(imag!, 1, &maxValue.b, length)
        }
        
        return maxValue
        
    }
    
    public var min:Complex {
        
        var minValue = Complex(0,0)
        
        let length = vDSP_Length(count)
        
        if type == "real" {
            vDSP_minv(real, 1, &minValue.a, length)
        } else {
            vDSP_minv(real, 1, &minValue.a, length)
            vDSP_minv(imag!, 1, &minValue.b, length)
        }
        
        return minValue
        
    }
    
    
    // Initialization
    // Set number of rows and columns, and whether the matrix is real or complex.
    
    public init(_ rows:Int, _ columns:Int, _ type:String?) {
        
        self.rows = rows
        self.columns = columns
        
        if let newType = type {
            
            if newType == "real" {
                self.type = newType
                real = Array(repeating:Float(0), count: rows*columns)
                imag = nil
            } else if newType == "complex" {
                self.type = newType
                real = Array(repeating:Float(0), count: rows*columns)
                imag = Array(repeating:Float(0), count: rows*columns)
            } else {
                self.type = "real"
                real = Array(repeating:Float(0), count: rows*columns)
                imag = nil
            }
            
        } else {
            self.type = "real"
            real = Array(repeating:Float(0), count: rows*columns)
            imag = nil
        }
        
    }
    
    
    // Function that gives an identity matrix of size n.
    // First creates an n by n matrix of zeroes, then sets the values
    // along the main diagonal to 1.0 using the set function (below).
    
    public class func identity(size:Int) -> Matrix {
        
        let newMat = Matrix(size, size, "real")
        
        for i in 0..<size {
            newMat.set(i, i, 1.0)
        }
        
        return newMat
        
    }
    
    
    // Function that sets specific elements in a matrix to a value.
    // The set function is called by the identity function (above).
    // i:Int and j:Int result in the index of the element to set.
    // value:Any is the value that the function sets Matrix[i][j] to.
    // value must be a Float or Double (Double is converted to Float).
    
    func set(_ i:Int, _ j:Int, _ value:Any) {
        
        let index = columns*i + j
        
        switch value {
        case let complexValue as Complex:
            real[index] = complexValue.a
            imag?[index] = complexValue.b
        case let floatValue as Float:
            real[index] = floatValue
        case let doubleValue as Double:
            real[index] = Float(doubleValue)
        default:
            print("Value is not a valid type, it must be Float or Double.")
        }
    }
    
    
    
    // Function that returns the value of a matrix at index i, j.
    // To use, type aMatrix.ij(i, j), a tuple of one float (real portion)
    // and one optional float (imaginary portion) is returned
    
    public func ij(_ i:Int, _ j:Int) -> (Float, Float?) {
        
        var element:Int
        
        element = (i-1) + (j-1)*self.columns
        
        return (self.real[element], self.imag?[element])
        
    }
    
    
    
    // I have no idea what any of this is supposed to do or mean.
    
    
    // TODO: Add capability to set a range with an array
    /*
     func set(array:[Float], type:String) {
     if type == "real" && count == array.count {
     self.real = array
     }
     }
     
     func convert() -> Matrix {
     
     let newMat:Matrix
     
     if complex {
     newMat = Matrix(rows, columns)
     newMat.real = real
     newMat.imag = imag!
     } else {
     newMat = Matrix(rows, columns, "complex")
     newMat.real = real
     }
     
     return newMat
     
     }
     */
    
    
    
    // Operators: add, subtract (sub), and multiply (mul).
    // Does element-wise calculations on matrices of the same size,
    // which can have real and complex elements. Both are not required to be
    // real or complex, one can be real and the other complex, etc.
    // Does NOT return a new matrix! It modifies one using values from another.
    // How to use:
    //   matrixOne.mul(matrixTwo)
    //   or
    //   matrixTwo.mul(matrixOne)
    // Both of the above are equaivalent because calculations are element-wise,
    // only the first changes the elements in matrixOne, and the second changes
    // the elements in matrixTwo.
    
    func add(_ addMatrix:Matrix) {
        
        guard self.sameSize(addMatrix) else {
            print("Matrices are not the same size, element-wise calculation cannot be performed.")
            return
        }
        
        let length:vDSP_Length = UInt(self.count)
        vDSP_vadd(addMatrix.real, 1, self.real, 1, &self.real, 1, length)
        
        if self.imag != nil && addMatrix.imag != nil {
            vDSP_vadd(addMatrix.imag!, 1, self.imag!, 1, &self.imag!, 1, length)
            
        } else if self.imag == nil && addMatrix.imag != nil {
            self.imag = addMatrix.imag
        }
    }
    
    
    func sub(_ subMatrix:Matrix) {
        
        guard self.sameSize(subMatrix) else {
            print("Matrices are not the same size, element-wise calculation cannot be performed.")
            return
        }
        
        let length:vDSP_Length = UInt(self.real.count)
        vDSP_vsub(subMatrix.real, 1, self.real, 1, &self.real, 1, length)
        
        let count = self.real.count
        
        if self.imag != nil && subMatrix.imag != nil {
            vDSP_vsub(subMatrix.imag!, 1, self.imag!, 1, &self.imag!, 1, length)
            
        } else if self.imag == nil && subMatrix.imag != nil {
            self.imag = [Float](repeatElement(0.0, count: self.real.count))
            self.type = "complex"
            
            for i in 0..<count {
                self.imag?[i] = -1 * subMatrix.imag![i]
            }
        }
    }
    
    
    func mul(_ mulMatrix:Matrix) {
        
        guard self.sameSize(mulMatrix) else {
            print("Matrices are not the same size, element-wise calculation cannot be performed.")
            return
        }
        
        let count = self.real.count
        
        let oldSelf = Matrix(self.rows, self.columns, self.type)
        oldSelf.real = self.real
        oldSelf.imag = self.imag
        
        if self.imag != nil && mulMatrix.imag != nil {
            for i in 0..<count {
                self.real[i] = (self.real[i] * mulMatrix.real[i]) + (self.imag![i] * mulMatrix.imag![i])
                self.imag![i] = (oldSelf.imag![i] * mulMatrix.real[i]) + (oldSelf.real[i] * mulMatrix.imag![i])
            }
            
        } else if self.imag == nil && mulMatrix.imag != nil {
            self.type = "complex"
            self.imag = [Float](repeatElement(0.0, count: self.real.count))
            
            for i in 0..<count {
                self.real[i] = self.real[i] * mulMatrix.real[i]
                self.imag![i] = oldSelf.real[i] * mulMatrix.imag![i]
            }
            
        } else if self.imag != nil && mulMatrix.imag == nil {
            for i in 0..<count {
                self.real[i] = self.real[i] * mulMatrix.real[i]
                self.imag![i] = oldSelf.imag![i] * mulMatrix.real[i]
            }
            
        } else if self.imag == nil && mulMatrix.imag == nil {
            let length:vDSP_Length = UInt(self.count)
            vDSP_vmul(mulMatrix.real, 1, self.real, 1, &self.real, 1, length)
        }
    }
    
    
    // Function that determines if two matrices are the same size.
    // sameSize is called by .add(Matrix), .sub(Matrix), and .mul(Matrix),
    // which perform element-wise calculations.
    
    func sameSize(_ compareMatrix:Matrix) -> Bool {
        
        if self.rows == compareMatrix.rows && self.columns == compareMatrix.columns {
            return true
            
        } else {
            return false
        }
    }
    
    
    // Defines a variable "description" for a string displaying all elements
    // of a matrix in rows and columns.
    // Retrieve this variable using aMatrix.description
    
    public var description:String {
        
        var outString = ""
        var index = 0
        
        for i in 0..<rows {
            for j in 0..<columns {
                index = i*self.columns + j
                
                if self.imag != nil {
                    var sign:String
                    let b = self.imag![index]
                    
                    if b<0 {
                        sign = " - "
                    } else {
                        sign = " + "
                    }
                    
                    outString = outString + String(self.real[index])
                    outString = outString + sign + String(Swift.abs(self.imag![index])) + "i \t"
                    
                } else {
                    outString = outString + String(self.real[index]) + "\t"
                }
            }
            
            outString = outString + "\n"
        }
        
        return outString
    }
    
    
    // Functions that scale between 0 and 255 or 0 and 65535 using max and min
    // from original matrix so the matrix can be turned into an image.
    
    func realUint8() -> [UInt8] {
                
        var maximum = self.max
        let minimum = self.min
        
        if maximum.a == 0 {
            maximum.a = 1
        }
        
        if  maximum.b == 0 {
            maximum.b = 1
        }
        
        var outUint8:[UInt8] = [UInt8].init(repeating: UInt8(0), count:self.count)
        
        for i in 0..<self.real.count {
            let val = real[i]
            
            outUint8[i] = UInt8((real[i]-minimum.a)/(maximum.a-minimum.a)*255)
        }
        
        return outUint8
    }
    
    
    
    func realUint16() -> [UInt16]{
        
        var maximum = self.max
        let minimum = self.min
        
        if maximum.a == 0 {
            maximum.a = 1
        }
        
        var outUint16:[UInt16] = [UInt16].init(repeating: UInt16(0), count:self.count)
        
        for i in 0..<real.count{
            outUint16[i] = UInt16((real[i]-minimum.a)/(maximum.a-minimum.a)*255)
        }
        
        return outUint16
    }
    
    
    
    func imagUint8() -> [UInt8]{
        
        var maximum = self.max
        let minimum = self.min
        
        if  maximum.b == 0 {
            maximum.b = 1
        }
        
        var outUInt8:[UInt8] = [UInt8].init(repeating: UInt8(0), count:self.count)
        
        if self.imag != nil{
            for i in 0..<real.count{
                outUInt8[i] = UInt8((imag![i]-minimum.b)/(maximum.b-minimum.b)*255)
            }
        }
        
        return outUInt8
    }
    
    
    
    func imagUint16() -> [UInt16]{
        
        var maximum = self.max
        let minimum = self.min
        
        if  maximum.b == 0 {
            maximum.b = 1
        }
        
        var outUint16:[UInt16] = [UInt16].init(repeating: UInt16(0), count:self.count)
        
        if self.imag != nil{
            
            for i in 0..<imag!.count{
                outUint16[i] = UInt16((imag![i]-minimum.b)/(maximum.b-minimum.b)*255)
            }
        }
        
        return outUint16
    }
    
    
    
    // Function that generates NSImage from a matrix.
    // Need to specify part ("real" or "imag"), and format (MatrixOutput.uint8, etc ???).
    
    public func imageRepresentation(part:String, format:Int) -> CGImage? {
        
        let typeSize:Int = format/8
        let dataSize:Int = format*self.count
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).union(CGBitmapInfo())
        var providerRef:CGDataProvider?
        
        if format == MatrixOutput.uint16 {
            var out:[UInt16]
            
            if part == "imag" {
                out = self.imagUint16()
            } else {
                out = self.realUint16()
            }
            
            providerRef = CGDataProvider(data: NSData(bytes: &out, length: dataSize))!
            
        } else {
            var out:[UInt8]
            
            if part == "imag" {
                out = self.imagUint8()
            } else {
                out = self.realUint8()
            }
            
            let data = NSData(bytes: &out, length: typeSize*self.count)
            
            providerRef = CGDataProvider(data: data)!
        }
        
        
        if let image = CGImage(width: self.columns,
                               height: self.rows,
                               bitsPerComponent: format,
                               bitsPerPixel: format,
                               bytesPerRow: typeSize*self.columns,
                               space: CGColorSpaceCreateDeviceGray(),
                               bitmapInfo: bitmapInfo,
                               provider: providerRef!,
                               decode: nil,
                               shouldInterpolate: true,
                               intent: CGColorRenderingIntent.defaultIntent){
            
            return image
        }
        
        return nil
    }
    
    
    
    
    /// A custom playground Quick Look for this instance.
    ///
    /// If this type has value semantics, the `PlaygroundQuickLook` instance
    /// should be unaffected by subsequent mutations.
    
    // For some reason including this makes the operators stop working right because
    // they're converted to uint8, and some value is less than that type's allowed minimum;
    // if unecessary for running of program, should probably remove this section.
    
    public var customPlaygroundQuickLook: PlaygroundQuickLook{
     
     
        let realPartImage = NSImage(cgImage:self.imageRepresentation(part: "real", format: MatrixOutput.uint8)!,size:NSSize.init(width: columns, height: rows))
     
     var combinedImage:NSImage?
     
     if type == "complex"{
     
     let imagPartImage =  NSImage(cgImage:self.imageRepresentation(part: "image", format: MatrixOutput.uint8)!,size:NSSize.init(width: columns, height: rows))
     
     
     combinedImage = NSImage(size: NSSize.init(width: 2*columns, height: rows), flipped:false, drawingHandler: {rect in
     
     let realHalfRect = NSRect(x: 0, y: 0, width: self.columns, height: self.rows)
     realPartImage.draw(in:realHalfRect)
     
     let imagHalfRect = NSRect(x: self.columns+1, y: 0, width: self.columns, height: self.rows)
     imagPartImage.draw(in:imagHalfRect)
     
     return true
     })
     
     }
     
     if combinedImage != nil{
     return .image(combinedImage!)
     }else{
     return .image(realPartImage)
     }
     //        else{
     //           return PlaygroundQuickLook.text(self.description)
     //        }
     }

    
    
    
}


//
//
// Operators for Matrices
//
//


// Element-wise addition, subtraction, and multiplication.
// Use +, -, and .* as infix operators.
// Works for complex and real matrices, and combinations thereof.
// Returns a new matrix, unless they aren't the same size,
// in which case returns nil and prints a warning.

public func +(lhs:Matrix, rhs:Matrix) -> Matrix? {
    
    guard lhs.sameSize(rhs) else {
        print("Matrices are not the same size, element-wise calculation cannot be performed.")
        return nil
    }
    
    var newMatrix = Matrix(lhs.rows, lhs.columns, lhs.type)
    newMatrix.real = lhs.real
    newMatrix.imag = lhs.imag
    let length:vDSP_Length = UInt(newMatrix.real.count)
    
    vDSP_vadd(rhs.real, 1, newMatrix.real, 1, &newMatrix.real, 1, length)
    
    if lhs.imag == nil && rhs.imag == nil {
        newMatrix.imag = nil
        
    } else if lhs.imag != nil && rhs.imag != nil {
        vDSP_vadd(rhs.imag!, 1, newMatrix.imag!, 1, &newMatrix.imag!, 1, length)
        
    } else if lhs.imag != nil && rhs.imag == nil {
        newMatrix.imag = lhs.imag
        
    } else if lhs.imag == nil && rhs.imag != nil {
        newMatrix.imag = rhs.imag
    }
    
    return newMatrix
}



public func -(lhs:Matrix, rhs:Matrix) -> Matrix? {
    
    guard lhs.sameSize(rhs) else {
        print("Matrices are not the same size, element-wise calculation cannot be performed.")
        return nil
    }
    
    var newMatrix = Matrix(lhs.rows, lhs.columns, lhs.type)
    newMatrix.real = lhs.real
    newMatrix.imag = lhs.imag
    let length:vDSP_Length = UInt(newMatrix.count)
    
    vDSP_vsub(rhs.real, 1, newMatrix.real, 1, &newMatrix.real, 1, length)
    
    if lhs.imag == nil && rhs.imag == nil {
        newMatrix.imag = nil
        newMatrix.type = "real"
        
    } else if lhs.imag != nil && rhs.imag != nil {
        vDSP_vsub(rhs.imag!, 1, newMatrix.imag!, 1, &newMatrix.imag!, 1, length)
        
    } else if lhs.imag != nil && rhs.imag == nil {
        newMatrix.imag = lhs.imag
        newMatrix.type = "complex"
        
    } else if lhs.imag == nil && rhs.imag != nil {
        newMatrix.type = "complex"
        newMatrix.imag = [Float](repeatElement(0.0, count: newMatrix.real.count))
        
        for i in 0..<newMatrix.imag!.count {
            newMatrix.imag![i] = -1 * rhs.imag![i]
        }
    }
    
    return newMatrix
}



public func .*(lhs:Matrix, rhs:Matrix) -> Matrix? {
    
    guard lhs.sameSize(rhs) else {
        print("Matrices are not the same size, element-wise calculation cannot be performed.")
        return nil
    }
    
    var newMatrix = Matrix(lhs.rows, lhs.columns, "complex")
    newMatrix.real = [Float](repeatElement(0.0, count: newMatrix.real.count))
    newMatrix.imag = [Float](repeatElement(0.0, count: newMatrix.real.count))
    var lhsCopy = lhs
    var rhsCopy = rhs
    let count = newMatrix.real.count
    
    if lhs.imag == nil {
        lhsCopy.imag = [Float](repeatElement(0.0, count: newMatrix.real.count))
        lhsCopy.type = "complex"
    }
    
    if rhs.imag == nil {
        rhsCopy.imag = [Float](repeatElement(0.0, count: newMatrix.real.count))
        rhsCopy.type = "complex"
    }
    
    for i in 0..<count {
        newMatrix.real[i] = (lhsCopy.real[i] * rhsCopy.real[i]) + (lhsCopy.imag![i] * rhsCopy.imag![i])
        newMatrix.imag![i] = (lhsCopy.imag![i] * rhsCopy.real[i]) + (lhsCopy.real[i] * rhsCopy.imag![i])
    }
    
    let compare = [Float](repeatElement(0.0, count: newMatrix.real.count))
    
    if newMatrix.imag! == compare {
        newMatrix.imag = nil
        newMatrix.type = "real"
    }
    
    return newMatrix
}


// Function that returns the complex conjugate of a matrix.

public func complexConj(_ input:Matrix) -> (Matrix) {
    
    var output = Matrix(input.rows, input.columns, input.type)
    var complex = Complex(0,0)
    var n = Complex(0,0)
    
    for i in 0..<input.count {
        complex.a = input.real[i]
        complex.b = input.imag![i]
        n = complex.conj()
        output.real[i] = n.a
        output.imag![i] = n.b
    }
    
    return output
}




// Function that normalizes a matrix between 0 and 255.
// Used before image representations are produced when values are
// very large or very small.

public func normalize(_ mat:Matrix) {
    let max = mat.max.a
    let min = mat.min.a
    let max2 = mat.max.b
    let min2 = mat.min.b
    
    for i in 0..<mat.count {
        mat.real[i] = (mat.real[i]/(max-min))*Float(255)
        mat.imag![i] = (mat.imag![i]/(max2-min2))*Float(255)
    }
}





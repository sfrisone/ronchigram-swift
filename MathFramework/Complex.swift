//
//  Complex.swift
//  newRonchi
//
//  Created by LeBeau Group iMac on 8/25/17.
//  Copyright © 2017 LeBeau Group iMac. All rights reserved.
//

import Foundation
import Cocoa
import Accelerate


//had to make the target Ronchi as well as MathFramework because for some reason Complex doesn't import with MathFramework all the time
//should probably fix that

public struct Complex:CustomStringConvertible, Any {
    
    
    // set up a complex number as Complex(a, b), where "a" and "b" are
    // of type Float (even if entered as type Int).
    // "a" is the real portion of the complex number and "b" is the
    // imaginary portion.
    // if a value for "b" isn't given, it's assumed to be zero. (ie
    // you can write "1.0 + 0.0i" as simply "Complex(1)")
    
    public var a:Float = 0.0
    public var b:Float = 0.0
    
    public init(_ a:Float, _ b:Float) {
        self.a = a
        self.b = b
    }
    
    public init(_ a:Int, _ b:Int) {
        self.a = Float(a)
        self.b = Float(b)
    }
    
    public init(_ a:Int) {
        self.a = Float(a)
    }
    
    public init(_ a:Float) {
        self.a = a
    }
    
    
    // display the complex number as "a + bi" or "a - bi" when printed
    
    public var description:String {
        
        var sign:String
        
        if b < 0 {
            sign = " - "
        } else {
            sign = " + "
        }
        
        return String(a) + sign + String(Swift.abs(b)) + "i"
    }
    
    
    // basic "functions" for complex numbers:
    //   return absolute value, return conjugate,
    //   return real part (a), and return imaginary part (b).
    // call these in the following manner:
    //   var aComplexNumber = Complex(a, b)
    //   aComplexNumber.abs(); aComplexNumber.conj(); etc
    
    public func abs() -> Float {
        return sqrt(a*a + b*b)
    }
    public func conj() -> Complex {
        return Complex(a, -b)
    }
    public func real() -> Float {
        return a
    }
    public func imag() -> Float {
        return b
    }
    
}


// operators for complex number pairs: +, -, *, and /.
// to use the functions, enter as:
//   Complex(a, b) (operator) Complex(c, d)
// except minus the parenthesis around (operator), as in:
//   Complex(1, 2) + Complex(3, 4)

func -(lhs:Complex, rhs:Complex) -> Complex {
    return Complex(lhs.a - rhs.a, lhs.b - rhs.b)
}

func +(lhs:Complex, rhs:Complex) -> Complex {
    return Complex(lhs.a + rhs.a, lhs.b + rhs.b)
}

func *(lhs:Complex, rhs:Complex) -> Complex {
    
    let prodA = lhs.a*rhs.a - lhs.b*rhs.b
    let prodB = lhs.a*rhs.b + lhs.b*rhs.a
    
    return Complex(prodA, prodB)
}

func /(lhs:Complex, rhs:Complex) -> Complex {
    
    let numA = lhs.a*rhs.a + lhs.b*rhs.b
    let numB = lhs.b*rhs.a - lhs.a*rhs.b
    let denom = rhs.a*rhs.a + rhs.b*rhs.b
    
    return Complex(numA/denom, numB/denom)
}


// operators for complex/real number pairs: +, -, *, and /.
// to use the operators, enter as:
//   Float (operator) Complex(a, b)
//   or
//   Complex(a, b) (operator) Float
// except minus the parenthesis around (operator), as in:
//   Complex(1, 2) + Float(3)

public func -(lhs:Complex, rhs:Float) -> Complex {
    return Complex(lhs.a - rhs, lhs.b)
}

public func +(lhs:Complex, rhs:Float) -> Complex {
    return Complex(lhs.a + rhs, lhs.b)
}

public func *(lhs:Complex, rhs:Float) -> Complex {
    return Complex(lhs.a*rhs, lhs.b*rhs)
}

public func /(lhs:Complex, rhs:Float) -> Complex {
    return Complex(lhs.a/rhs, lhs.b/rhs)
}

public func -(lhs:Float, rhs:Complex) -> Complex {
    return Complex(lhs - rhs.a, rhs.b)
}

public func +(lhs:Float, rhs:Complex) -> Complex {
    return Complex(lhs + rhs.a, rhs.b)
}

public func *(lhs:Float, rhs:Complex) -> Complex {
    return Complex(lhs*rhs.a, lhs*rhs.b)
}

public func /(lhs:Float, rhs:Complex) -> Complex {
    return Complex(lhs/rhs.a, lhs/rhs.b)
}



// function to raise a complex number to a power
// use: cpow(base, power); returns a complex number
// works for all integer powers

public func cpow(_ base:Complex, _ power:Int) -> Complex {
    
    var ans:Complex
    
    if power == 0 {
        
        ans = Complex(1,0)
        
    } else if power == 1 {
        
        ans = base
        
    } else if power == -1 {
        
        ans = 1/base
        
    } else {
        
        ans = base
        
        if power > 0 {
            
            for _ in 2...power {
                ans = ans * base
            }
            
        } else {
            
            for _ in 2...abs(power) {
                ans = ans * base
                ans = Complex(ans.a, -ans.b)
            }
            
            ans = 1/ans
            
        }
    }
    return ans
}





//
//  ViewController.swift
//  Ronchi
//
//  Created by James LeBeau on 6/12/17.
//  Copyright © 2017 The Handsome Microscopist. All rights reserved.
//

import Cocoa
import Accelerate
import MathFramework



class ViewController: NSViewController {
   
    
    @IBOutlet weak var modeButtons: NSSegmentedControl!
    @IBOutlet weak var theImage: ImageView!
    
    @IBOutlet var tree: NSTreeController!
    
    

    var probe = Probe(256, 256, [Aberratio(0, 1, 0, 0),
                                 Aberratio(1, 0, 0, 0),
                                 Aberratio(1, 2, 0, 0),
                                 Aberratio(2, 1, 0, 0),
                                 Aberratio(2, 3, 0, 0),
                                 Aberratio(3, 0, 0, 0),
                                 Aberratio(3, 2, 0, 0),
                                 Aberratio(3, 4, 0, 0),
                                 Aberratio(4, 1, 0, 0),
                                 Aberratio(4, 3, 0, 0),
                                 Aberratio(4, 5, 0, 0),
                                 Aberratio(5, 0, 0, 0),
                                 Aberratio(5, 2, 0, 0),
                                 Aberratio(5, 4, 0, 0),
                                 Aberratio(5, 6, 0, 0),
                                 Aberratio(6, 1, 0, 0),
                                 Aberratio(6, 3, 0, 0),
                                 Aberratio(6, 5, 0, 0),
                                 Aberratio(6, 7, 0, 0),
                                 Aberratio(7, 0, 0, 0),
                                 Aberratio(7, 2, 0, 0),
                                 Aberratio(7, 4, 0, 0),
                                 Aberratio(7, 6, 0, 0),
                                 Aberratio(7, 8, 0, 0)])
    
    let names = ["Beam/Image Shift", "Defocus", "Twofold Astigmatism", "Second-Order Axial Coma", "Threefold Astigmatism", "Third-Order Spherical Aberration", "Third-Order Star-Aberration", "Fourfold Astigmatism", "Fourth-Order Axial Coma", "Fourth-Order Three-Lobe Aberration", "Fivefold Astigmatism", "Fifth-Order Spherical Aberration", "Fifth-Order Star-Aberration", "Fifth-Order Rosette Aberration", "Sixfold Astigmatism", "Sixth-Order Axial Coma", "Sixth-Order Three-Lobe Aberration", "Sixth-Order Pentacle Aberration", "Sevenfold Aberration", "Seventh-Order Spherical Aberration", "Seventh-Order Star-Aberration", "Seventh-Order Rosette Aberration", "Seventh-Order Chaplet Aberration", "Eightfold Astigmatism"]
    let krivanekLabels = ["C_0,1", "C_1,0", "C_1,2", "C_2,1", "C_2,3", "C_3,0", "C_3,2", "C_3,4", "C_4,1", "C_4,3", "C_4,5", "C_5,0", "C_5,2", "C_5,4", "C_5,6", "C_6,1", "C_6,3", "C_6,5", "C_6,7", "C_7,0", "C_7,2", "C_7,4", "C_7,6", "C_7,8"]
    
    /*
    func setControllerInfoValues (_ probe:Probe) -> Array<Any> {
        var controllerInfo = Array(repeatElement(["", 0, 0], count: 24))
        for i in 0..<24 {
            controllerInfo[i][0] = krivanekLabels[i]
            controllerInfo[i][1] = probe.setAberrations[i].Cnma.floatValue
            controllerInfo[i][2] = probe.setAberrations[i].Cnmb.floatValue
        }
        return controllerInfo
    }
    
    func cnmaVals (_ probe:Probe) -> Array<Any> {
        var cnma = [Float]()
        for i in 0..<24 {
            cnma[i] = probe.setAberrations[i].Cnma.floatValue
        }
        return cnma
    }
    func cnmbVals (_ probe:Probe) -> Array<Any> {
        var cnmb = [Float]()
        for i in 0..<24 {
            cnmb[i] = probe.setAberrations[i].Cnmb.floatValue
        }
        return cnmb
    }
    */
    
    @IBAction func modeButtons(_ sender: NSSegmentedControl) {
        
        if sender.intValue == 0 {
            // ronchigram - not yet functional
        } else if sender.intValue == 1 {
            // probe
            
            probe.calculateProbe()
            let image = FFTController.init(probe.waveFunction)
            let img1 = image.plateToProbe(probe.waveFunction)
            let img = img1.imageRepresentation(part:"real", format:8)
            theImage.setImageWithCGImageRef(img!)
            
        } else if sender.intValue == 2 {
            // phase plate
            
            probe.calculateProbe()
            let img = probe.waveFunction.imageRepresentation(part:"real", format:8)
            theImage.setImageWithCGImageRef(img!)
            
        } else if sender.intValue == 3 {
            // image - not yet functional
        }
        
    }
    
    
    
    /*
    var circle = Matrix(512, 512, "real")
    var setInnRad:Int = 50
    var setOutRad:Int = 50
    
    @IBAction func changeInnerRadius(_ sender: NSSlider) {
        
        setInnRad = Int(sender.intValue)
        if checkRadius(setInnRad, setOutRad) != true {
            innerRadius.integerValue = setOutRad
        }
        innRadText.stringValue = String(setInnRad)
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
   
    @IBAction func changeOuterRadius(_ sender: NSSlider) {
        
        setOutRad = Int(sender.intValue)
        if checkRadius(setInnRad, setOutRad) != true {
            outerRadius.integerValue = setInnRad
        }
        outRadText.stringValue = String(setOutRad)
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
    
    @IBAction func innRadUpPush(_ sender: NSButton) {
        
        setInnRad += 1
        if checkRadius(setInnRad, setOutRad) != true {
            innerRadius.integerValue = setOutRad
            setInnRad = setOutRad
        }
        innRadText.stringValue = String(setInnRad)
        innerRadius.integerValue = setInnRad
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
    
    @IBAction func innRadDownPush(_ sender: NSButton) {
        
        setInnRad -= 1
        if checkRadius(setInnRad, setOutRad) != true {
            innerRadius.integerValue = setOutRad
            setInnRad = setOutRad
        }
        innRadText.stringValue = String(setInnRad)
        innerRadius.integerValue = setInnRad
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
    
    @IBAction func outRadUpPush(_ sender: NSButton) {
        
        setOutRad += 1
        if checkRadius(setInnRad, setOutRad) != true {
            innerRadius.integerValue = setInnRad
            setOutRad = setInnRad
        }
        outRadText.stringValue = String(setOutRad)
        outerRadius.integerValue = setOutRad
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
    
    @IBAction func outRadDownPush(_ sender: NSButton) {
        
        setOutRad -= 1
        if checkRadius(setInnRad, setOutRad) != true {
            innerRadius.integerValue = setInnRad
            setOutRad = setInnRad
        }
        outRadText.stringValue = String(setOutRad)
        outerRadius.integerValue = setOutRad
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
    
    /*
    @IBAction func innRadTextEnter(_ sender: NSTextField) {
     
        setInnRad = Int(sender.intValue)
        let img = drawCircle(setInnRad, setOutRad)
        theImage.setImageWithCGImageRef(img!)
    }
    */
     
    func drawCircle(_ innRad: Int, _ outRad: Int) -> CGImage? {
 
        let xo = Int(circle.rows/2)
        let yo = Int(circle.columns/2)
        let r = outRad
        let r2 = innRad
        let rows = circle.rows-1
        let columns = circle.columns-1
        let valid:Bool
        let img:CGImage?
        
        valid = checkRadius(innRad, outRad)
        
        if valid == true {
            for i in 0...rows {
                for j in 0...columns {
                    if (i-xo)*(i-xo) + (j-yo)*(j-yo) <= r*r && (i-xo)*(i-xo) + (j-yo)*(j-yo) >= r2*r2 {
                        circle.real[i*circle.columns + j] = Float(1)
                    } else {
                        circle.real[i*circle.columns + j] = 0.0
                    }
                }
            }
        }
        img = circle.imageRepresentation(part:"real", format:8)
        return img
    }
    
    func checkRadius(_ inner: Int, _ outer: Int) -> Bool {
        if inner <= outer {
            return true
        } else {
            return false
        }
    }
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tree.add(Aberratio(0, 1, 0, 0))
        
        let probe1 = Probe(256, 256)
        probe1.apertureSize = 10
        let probe2 = probe1.probeWithAberration([Aberratio(2, 3, 0, 0)], probe1.realSize, probe1.apertureSize, probe1.lambda, NSSize(width: probe1.waveSize, height: probe1.waveSize))
        probe2.calculateProbe()
        
        let image = FFTController.init(probe2.waveFunction)
        
        let img1 = image.plateToProbe(probe2.waveFunction)
        
        let img = img1.imageRepresentation(part:"real", format:8)
        
        theImage.setImageWithCGImageRef(img!)
        
        
        // need to figure out how to set values in view-based NSTableView
        
        let krivanekLabels = ["C_0,1", "C_1,0", "C_1,2", "C_2,1", "C_2,3", "C_3,0", "C_3,2", "C_3,4", "C_4,1", "C_4,3", "C_4,5", "C_5,0", "C_5,2", "C_5,4", "C_5,6", "C_6,1", "C_6,3", "C_6,5", "C_6,7", "C_7,0", "C_7,2", "C_7,4", "C_7,6", "C_7,8"]
        let Cnma = Array(repeatElement(Float(0), count: 24))
        let Cnmb = Array(repeatElement(Float(0), count: 24))
        
        
        
        
        //viewController 
         
        /*
        for i in 0...2 {
            if i == 0 {
                for j in 0...23 {
                    tableView(aberrationTable, names[i], i, j)
                }
            } else if i == 1 {
                for j in 0...23 {
                    tableView(aberrationTable, Cnma[i], i, j)
                }
            } else {
                for j in 0...23 {
                    tableView(aberrationTable, Cnma[i], i, j)
                }
            }
        }
        */
        
        //Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}




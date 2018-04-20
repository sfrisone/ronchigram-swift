
import Foundation
import CoreImage
import Cocoa



class ImageView: NSView{
    
    var rootLayer:CALayer = CALayer();
    var imageLayer:CALayer = CALayer();
    

    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        setupLayers()
        
        self.autoresizesSubviews = true

    }
    
    func setupLayers(){
        
        
        
        rootLayer.backgroundColor = CGColor.black
        rootLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        rootLayer.contentsGravity = kCAGravityResizeAspect
        
        rootLayer.addSublayer(imageLayer)
        
        imageLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
        imageLayer.contentsGravity = kCAGravityResizeAspect
        
        self.layer = rootLayer
        self.wantsLayer = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Drawing code here.

    }
    
    func setImageWithCGImageRef(_ image:CGImage) {
        imageLayer.contents = image;
        imageLayer.frame = rootLayer.frame;
    }
    
    
}








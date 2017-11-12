//
//  ViewController.swift
//  AnimationGroupFadeBtnDemo
//
//  Created by 刘隆昌 on 2017/11/12.
//  Copyright © 2017年 刘隆昌. All rights reserved.
//

import UIKit


let Screen = UIScreen.main.bounds.size


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let imageView = UIImageView.init(frame: self.view.bounds);
        imageView.image = UIImage.init(named: "111.jpg");
        self.view.addSubview(imageView);
        
        let spacing = 41;
        let btnWidth = (Screen.width-CGFloat(spacing*4))/3-20;
        let yy = Screen.height - 200;
        
        let cancelBtn = UIButton.init(type: .custom);
        cancelBtn.frame = CGRect.init(x: Screen.width-(btnWidth+15), y: yy, width: btnWidth, height: btnWidth);
        cancelBtn.layer.cornerRadius = btnWidth/2;
        cancelBtn.layer.masksToBounds = true;
        cancelBtn.setTitle("展开", for: .normal);
        cancelBtn.backgroundColor = UIColor.red
        cancelBtn.addTarget(self, action: #selector(ViewController.btnAction(btn:)), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        
    }
    
    
    @objc func btnAction(btn:UIButton){
        
        let view : SelectBtnView = SelectBtnView.init(frame: UIScreen.main.bounds, cancelBtnFrame: btn);
        UIApplication.shared.keyWindow?.addSubview(view);
        view.show();
        
        
        view.btnClickClosure = {(_ selectedBtnText:String) in
            
            let message = "点击了\(selectedBtnText)"
            if selectedBtnText == "按钮1" {
                print("点击了按钮1");
            }else if(selectedBtnText == "按钮2"){
                print("点击了按钮2");
            }else{
                print("点击了按钮3");
            }
            
            let alert = UIAlertController.init(title: "温馨提示", message: message, preferredStyle: .alert);
            
            alert.addAction(UIAlertAction.init(title: "知道了", style: .cancel, handler: { (action) in
                
            }) );

            self.present(alert, animated: true, completion: nil);
            
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





typealias BtnClickClosure = (_ str:String)->Void


class SelectBtnView: UIView {
    
    var btnClickClosure : BtnClickClosure! = nil;
    
    var _btnFrames : NSMutableArray = []
    var _btns : NSMutableArray = []
    var cancelBtn : UIButton! = nil
    var _openBtn : UIButton! = nil
    
    
    
    
    init(frame: CGRect,cancelBtnFrame btn:UIButton) {
        super.init(frame: frame)
        
        _openBtn = btn;
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.uiConfigure()
    }
    
    func uiConfigure(){
        
        let spacing : CGFloat = 41;
        let btnWidth : CGFloat = (Screen.width-(spacing*4))/3;
        let yy = (Screen.height/2)-(btnWidth/2);
        let btnTitles = ["按钮1","按钮2","按钮3"];
        
        for (idx,obj) in btnTitles.enumerated() {
            let selectBtn = UIButton.init(type: .custom);
            selectBtn.frame = CGRect.init(x: Screen.width-(btnWidth+15), y: Screen.height-200, width: btnWidth, height: btnWidth)
            selectBtn.layer.cornerRadius = btnWidth/2;
            selectBtn.layer.masksToBounds = true;
            
            selectBtn.setTitle(btnTitles[idx], for: .normal)
            selectBtn.backgroundColor = UIColor.init(red: CGFloat(Double(arc4random()%256)/255.0), green: CGFloat(Double(arc4random()%256)/255.0), blue: CGFloat(Double(arc4random()%256)/255.0), alpha: 1)
            selectBtn.addTarget(self, action: #selector(SelectBtnView.selectBtnClick(btn:)), for: .touchUpInside)
            self.addSubview(selectBtn)
            _btns.add(selectBtn);
            let frame = CGRect.init(x: CGFloat(idx)*(btnWidth+spacing)+spacing, y: yy, width: btnWidth, height: btnWidth);
            let value = NSValue.init(cgRect: frame);
            _btnFrames.add(value);
        }
        
        cancelBtn = UIButton.init(type: .custom)
        //外部展开按钮 相对 keyWindow 的frame
        var newFrame = _openBtn.superview?.convert(_openBtn.frame, to: UIApplication.shared.keyWindow);
        cancelBtn.frame = newFrame!;
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width/2;
        cancelBtn.layer.masksToBounds = true;
        cancelBtn.setTitle("取消", for: .normal);
        cancelBtn.backgroundColor = UIColor.init(red: CGFloat(Double(arc4random()%256)/255.0), green: CGFloat(Double(arc4random()%256)/255.0), blue: CGFloat(Double(arc4random()%256)/255.0), alpha: 1)
        cancelBtn.addTarget(self, action: #selector(SelectBtnView.cancelBtnAction(btn:)), for: .touchUpInside)
        self.addSubview(cancelBtn);
        
    }
    
    
    @objc func cancelBtnAction(btn:UIButton){
        if !cancelBtn.isSelected {
            self.close()
        }else{
            self.open(isOpen: true)
        }
        cancelBtn.isSelected = !cancelBtn.isSelected;
    }
    
    func show(){
        self.open(isOpen: false);
    }
    
    func close(){
        for (_,obj) in _btns.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.init(rawValue: 0)], animations: {
                (obj as! UIButton).transform = CGAffineTransform.init(rotationAngle: CGFloat.pi*2);
                (obj as! UIButton).frame = self.cancelBtn.frame;
            }, completion: { (finish) in
                if(finish){
                    self.removeFromSuperview()
                }
            })
        }
    }
    
    func open(isOpen:Bool){
        for (idx,obj) in _btns.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, options: [.init(rawValue: 0)], animations: {
                (obj as! UIButton).transform = CGAffineTransform.init(rotationAngle: CGFloat.pi*2)
                let value = self._btnFrames[idx]
                (obj as! UIButton).frame = (value as! NSValue).cgRectValue;
            }, completion: { (finished) in
                if finished && isOpen {
                    self.removeFromSuperview();
                }
            })
        }
    }
    
    
    
    @objc func selectBtnClick(btn:UIButton){
        if self.btnClickClosure != nil {
            self.btnClickClosure((btn.titleLabel?.text)!);
            self.open(isOpen: true);
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

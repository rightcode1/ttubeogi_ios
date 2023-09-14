//
//  UpdateNicknameViewController.swift
//  WorkDonation
//
//  Created by hoonKim on 2021/05/27.
//

import UIKit
import DropDown

class UpdateNicknameViewController: BaseViewController {
  @IBOutlet var nicknameTextField: UITextField!
  @IBOutlet var phonTextField: UITextField!
  
  
  @IBOutlet var doSpinner: UIView!
  @IBOutlet var doLabel: UILabel!
  
  @IBOutlet var guSpinner: UIView!
  @IBOutlet var guLabel: UILabel!
  
  @IBOutlet var genderSpinner: UIView!
  @IBOutlet var genderLabel: UILabel!
  
  @IBOutlet var ageSpinner: UIView!
  @IBOutlet var ageLabel: UILabel!
  
  var diff: String?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if diff == "수정"{
      getUserInfo()
    }
    phonTextField.keyboardType = .numberPad
    
    
    dropbox(doSpinner,doLabel,["서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종",
                               "경기", "강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주"])
    dropbox(genderSpinner,genderLabel,["남성","여성"])
    dropbox(ageSpinner,ageLabel,["10대","20대","30대","40대","50대"])
  }
  
  func getUserInfo() {
    ApiService.request(router: UserApi.userInfo, success: { (response: ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }else {
          self.nicknameTextField.text = value.user.name
          self.phonTextField.text = value.user.tel
          self.doLabel.text = value.user.address1
          self.guLabel.text = value.user.address2
          self.ageLabel.text = value.user.age
          
          self.doLabel.textColor = .black
          self.guLabel.textColor = .black
          self.ageLabel.textColor = .black
          if value.user.gender == "M"{
            self.genderLabel.text = "남성"
          }else{
            self.genderLabel.text = "여성"
          }
          self.genderLabel.textColor = .black
        }
      } else {
        if value.code >= 202 {
          self.callMSGDialog(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.callMSGDialog(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func dropbox(_ dropView: UIView,_ dropLabel: UILabel,_ stringList: [String]){
    
      let dropDown = DropDown()
      dropDown.dataSource = stringList
      dropDown.anchorView = dropView
      dropDown.backgroundColor = .white
      dropDown.direction = .bottom
      dropDown.selectionAction = { [weak self] (index: Int, item: String) in
        guard let self = self else { return }
        dropLabel.text = item
        dropLabel.textColor = .black
        if dropView == self.doSpinner{
          print("!!!")
          self.updateList(index+1)
        }
      }
      dropDown.reloadAllComponents()

    dropView.rx.gesture(.tap()).when(.recognized).subscribe(onNext: { [weak self] _ in
          guard let self = self else { return }
          dropDown.show()
        }).disposed(by: disposeBag)
  }
  func updateInfo() {
    
    let stringPhone = phonTextField.text!
    print(stringPhone)
    var gender : String = "M"
    if genderLabel.text != "남성"{
      gender = "F"
    }
        
    ApiService.request(router: UserApi.updateNickname(name: self.nicknameTextField.text ?? "", tel: Int(stringPhone) ?? 0, address1: self.doLabel.text ?? "", address2: self.guLabel.text ?? "", gender: gender, age: self.ageLabel.text ?? ""), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "수정되었습니다") {
          if self.diff == "수정"{
            self.backPress()
          }else{
              self.moveToMain()
          }
        }
      }
      
    }) { (error) in
      if error?.statusCode == 400{
        self.doAlert(message: "중복된 닉네임입니다.")
      }
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  func moveToMain() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
  
  func updateList(_ index: Int) {
    print("!!!!")
    ApiService.request(router: UserApi.addressList(id: index), success: { (response: ApiResponse<AddressListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        var StringList :[String]=[]
        for count in 0..<value.list.count{
          StringList.append(value.list[count].name)
        }
        self.dropbox(self.guSpinner,self.guLabel,StringList)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapUpdate(_ sender: UIButton) {
    if nicknameTextField.text!.isEmpty {
      doAlert(message: "닉네임을 입력해주세요.")
      return
    }else if phonTextField.text!.isEmpty {
      doAlert(message: "휴대폰 번호를 올바르게 입력해주세요.")
      return
    }else if phonTextField.text!.count != 11 {
      doAlert(message: "휴대폰을 입력해주세요.")
      return
    }else if doLabel.text == "선택"{
      doAlert(message: "지역 시/도를 선택해주세요.")
      return
    }else if guLabel.text == "선택" {
      doAlert(message: "지역 군/구를 선택해주세요.")
      return
    }else if genderLabel.text == "선택" {
      doAlert(message: "성별을 선택해주세요.")
      return
    }else if ageLabel.text == "선택" {
      doAlert(message: "연령대를 선택해주세요.")
      return
    }
    updateInfo()
  }
  
}

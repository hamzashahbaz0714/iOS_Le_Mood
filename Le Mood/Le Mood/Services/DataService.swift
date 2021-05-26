//
//  DataService.swift
//  Flippin
//
//  Created by Hamza Shahbaz on 14/08/2019.
//  Copyright © 2019 Hamza Shahbaz. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class DataService{
    static let instance = DataService()
    
    let userReference = Firestore.firestore().collection("users")
    let patientReference = Firestore.firestore().collection("Patients")
    
    var currentUser : UserModel!
    
    func setCurrentUser(user:UserModel){
        self.currentUser = user
    }
    
    func emptyCurrentUser(){
        currentUser = nil
    }
    
    func updateUser(user:UserModel){
        userReference.document(user.id).setData([
            "id":user.id,
            "name":user.name,
            "email":user.email,
            "phoneNumber": user.phoneNumber,
            "image": user.image,
            "gender": user.gender,
            "country":user.country,
            "region": user.region,
            "createdAt": FieldValue.serverTimestamp()
        ], merge: true) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
            }
        }
    }
    
    func getUserOfID(userID:String,handler: @escaping(_ success:Bool,_ user:UserModel?)->()){
        let userRef = userReference.document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let id = data["id"] as? String ?? "Not Found"
                let name = data["name"] as? String ?? "Not Found"
                let email = data["email"] as? String ?? "Not Found"
                let gender = data["gender"] as? String ?? "Not Found"
                let country = data["country"] as? String ?? "Not Found"
                let region = data["region"] as? String ?? "Not Found"
                let image = data["image"] as? String ?? "Not Found"
                let phoneNumber = data["phoneNumber"] as? String ?? "Not Found"
                
                
                let user = UserModel(id: id, name: name, email: email, phoneNumber: phoneNumber, image: image, gender: gender, country: country, region: region)
                
                handler(true,user)
                
            } else {
                handler(false,nil)
                print("Document does not exist")
            }
        }
    }
    
    func saveMood(mood: MoodModel,docId: String){
        userReference.document(Auth.auth().currentUser!.uid).collection("moods").document(docId).setData([
            "moodId":mood.moodId,
            "moodType":mood.moodType,
            "moodValue":mood.moodValue,
            "time": mood.time,
            "date": mood.date,
            "createdAt": FieldValue.serverTimestamp()
        ], merge: true) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
            }
        }
    }
    
    func getAllFriends(handler: @escaping(_ success:Bool,_ allUser:[UserModel]?)->()){
        var userArray  = [UserModel]()
        userReference.getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let data = document.data()
                let id = data["id"] as? String ?? "Not Found"
                let name = data["name"] as? String ?? "Not Found"
                let email = data["email"] as? String ?? "Not Found"
                let gender = data["gender"] as? String ?? "Not Found"
                let country = data["country"] as? String ?? "Not Found"
                let region = data["region"] as? String ?? "Not Found"
                let image = data["image"] as? String ?? "Not Found"
                let phoneNumber = data["phoneNumber"] as? String ?? "Not Found"
                let user = UserModel(id: id, name: name, email: email, phoneNumber: phoneNumber, image: image, gender: gender, country: country, region: region)
                userArray.append(user)
            }
            handler(true,userArray)
        }
    }
    
    func getMoodByDate(handler: @escaping(_ success:Bool,_ mood:MoodModel?)->()){
        let userRef = userReference.document(Auth.auth().currentUser!.uid).collection("moods").whereField("date", in: [getCurrentDate()])
        userRef.getDocuments(completion: { (snapshot, error) in
            if snapshot?.documents.count  ?? 0 > 0 {
                for document in snapshot!.documents {
                    if document == document {
                        let data = document.data()
                        let moodId = data["moodId"] as? String ?? "Not Found"
                        let moodType = data["moodType"] as? String ?? "Not Found"
                        let moodValue = data["moodValue"] as? Int ?? 0
                        let time = data["time"] as? String ?? "Not Found"
                        let date = data["date"] as? String ?? "Not Found"
                        
                        let mood = MoodModel(moodId: moodId, moodType: moodType, moodValue: moodValue, time: time, date: date)
                        handler(true,mood)
                        break
                    }
                    else
                    {
                        handler(false,nil)
                    }
                }
            }
            else
            {
                handler(false,nil)
                
            }
        })
        
    }
    
    
    func uploadProfilePicture(image:UIImage, handler :@escaping(_ success:Bool,_ picUrl:String)->()){
        var downloadLink = ""
        let imageData = image.jpegData(compressionQuality: 0.8)
        let storageRef = Storage.storage().reference().child("Profile Pics").child(("\(Auth.auth().currentUser?.uid ?? "").jpg"))
        _ = storageRef.putData(imageData!, metadata: nil) { (metaData, error) in
            print("upload task finished")
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil
                {
                    print(error!)
                    handler(false, "")
                }
                else
                {
                    downloadLink = (url?.absoluteString)!
                    
                    
                    handler(true,downloadLink)
                }
            })
        }
    }
    //    func saveRecord(patient: Patient,pid: String){
    //
    //        patientReference.document(pid).setData([
    //            "pId": patient.pId,
    //            "postbyId": patient.postbyId,
    //            "patientName": patient.patientName,
    //            "dob": patient.dob,
    //            "medicalRecord": patient.medicalRecord,
    //            "comment":patient.comment,
    //        ])
    //    }
    //    func saveInferiorVenaRecord(inferior:InferiorVenaModel, collectionId: String, collectionName: String){
    //        patientReference.document(collectionId).collection(collectionName).document(collectionId).setData([
    //            "type":inferior.type,
    //            "rMM2":inferior.rMM2,
    //            "rMM":inferior.rMM,
    //            "cMM2":inferior.cMM2,
    //            "cMM":inferior.cMM,
    //            "difference":inferior.difference,
    //            "length": inferior.length
    //        ], merge: true) { (err) in
    //            if let err = err {
    //                debugPrint("Error adding document: \(err)")
    //            } else {
    //            }
    //        }
    //    }
    //
    //
    //    func SaveLFVeinRecord(vein:LRVeinModel, collectionId: String, collectionName: String){
    //        patientReference.document(collectionId).collection(collectionName).document(collectionId).setData([
    //            "rMM2L":vein.rMM2L,
    //            "rMMW":vein.rMMW,
    //            "cMM2L":vein.cMM2L,
    //            "cMMW":vein.cMMW,
    //            "difference":vein.difference,
    //            "stentDeployL": vein.stentDeployL,
    //            "stentDeployR": vein.stentDeployR,
    //            "pSMM2": vein.pSMM2,
    //            "pSMM": vein.pSMM
    //        ], merge: true) { (err) in
    //            if let err = err {
    //                debugPrint("Error adding document: \(err)")
    //            } else {
    //            }
    //        }
    //    }
    //
    //    func getInferiorVenaData(collectionName:String, collectionID: String ,handler: @escaping(_ success:Bool,_ venaCave: InferiorVenaModel?)->()){
    //        patientReference.document(collectionID).collection(collectionName).document(collectionID).addSnapshotListener { (snapshot, error) in
    //            guard let data = snapshot?.data() else {
    //                handler(false, nil)
    //                return
    //            }
    //            let type = data["type"] as? String ?? "Not Found"
    //            let rMM2 = data["rMM2"] as? String ?? "Not Found"
    //            let rMM = data["rMM"] as? String ?? "Not Found"
    //            let cMM2 = data["cMM2"] as? String ?? "Not Found"
    //            let cMM = data["cMM"] as? String ?? "Not Found"
    //            let difference = data["difference"] as? String ?? "Not Found"
    //            let length = data["length"] as? String ?? "Not Found"
    //
    //            let venaCave = InferiorVenaModel(type: type, rMM2: rMM2, rMM: rMM, cMM2: cMM2, cMM: cMM, difference: difference, length: length)
    //            handler(true, venaCave)
    //
    //        }
    //    }
    //    func getLRVeinData(collectionName:String, collectionID: String ,handler: @escaping(_ success:Bool,_ veinModel: LRVeinModel?)->()){
    //        patientReference.document(collectionID).collection(collectionName).document(collectionID).addSnapshotListener { (snapshot, error) in
    //            guard let data = snapshot?.data() else {
    //                handler(false, nil)
    //                return
    //            }
    //            let rMM2L = data["rMM2L"] as? String ?? "Not Found"
    //            let rMMW = data["rMMW"] as? String ?? "Not Found"
    //            let cMM2L = data["cMM2L"] as? String ?? "Not Found"
    //            let cMMW = data["cMMW"] as? String ?? "Not Found"
    //            let difference = data["difference"] as? String ?? "Not Found"
    //            let pSMM2 = data["pSMM2"] as? String ?? "Not Found"
    //            let pSMM = data["pSMM"] as? String ?? "Not Found"
    //            let stentDeployL = data["stentDeployL"] as? String ?? "Not Found"
    //            let stentDeployR = data["stentDeployR"] as? String ?? "Not Found"
    //
    //            let vein = LRVeinModel(rMM2L: rMM2L, rMMW: rMMW, cMM2L: cMM2L, cMMW: cMMW, difference: difference, stentDeployL: stentDeployL, stentDeployR: stentDeployR, pSMM2: pSMM2, pSMM: pSMM)
    //            handler(true, vein)
    //
    //        }
    //    }
    //
    //    func getPatient(handler: @escaping(_ success:Bool,_ patient: [Patient]?)->()){
    //        patientReference.whereField("postbyId", in: [Auth.auth().currentUser!.uid]).addSnapshotListener { (snapshot, error) in
    //            guard let snapshot = snapshot else {
    //                print("Error \(error!)")
    //                return
    //            }
    //            var patient:[Patient] = []
    //            for document in snapshot.documents {
    //                let data = document.data()
    //                let pId = data["pId"] as? String ?? "Not Found"
    //                let postbyId = data["postbyId"] as? String ?? "Not Found"
    //                let patientName = data["patientName"] as? String ?? "Not Found"
    //                let dob = data["dob"] as? String ?? ""
    //                let medicalRecord = data["medicalRecord"] as? String ?? ""
    //                let comment = data["comment"] as? String ?? ""
    //
    //                let pat = Patient(pId: pId, postbyId: postbyId, patientName: patientName, dob: dob, medicalRecord: medicalRecord, comment: comment)
    //                patient.append(pat)
    //                handler(true,patient)
    //            }
    //        }
    //
    //
    //    }
    //
    
    
}
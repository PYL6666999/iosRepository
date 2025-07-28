//
//  ViewController.swift
//  Project10
//
//  Created by Pyl on 2025/7/25.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    @objc func addNewPerson() {
//        let picker = UIImagePickerController()
//        picker.allowsEditing = true
//        picker.delegate = self
//        
//        // 优先使用相机，如果设备支持的话
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//        }else {
//            picker.sourceType = .photoLibrary
//        }
//
//        present(picker, animated: true)
        
        let ac = UIAlertController(title: "Add Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        // 选项1：使用相机拍照
           ac.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
               self?.showImagePicker(sourceType: .camera)
           })

           // 选项2：从相册选取
           ac.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
               self?.showImagePicker(sourceType: .photoLibrary)
           })

           // 取消
           ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

           present(ac, animated: true)
        
    }

    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            let alert = UIAlertController(title: "Not Available", message: "This source is not supported on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func save() {
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject:people, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodePeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodePeople
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let person = people[indexPath.item]
        //
        //        let ac = UIAlertController(title: "Rename person", message: nil,
        //                                   preferredStyle: .alert)
        //        ac.addTextField()
        //
        //        ac.addAction(UIAlertAction(title: "OK",style: .default){
        //            [weak self, weak ac] _ in
        //            guard let newName = ac?.textFields?[0].text else { return }
        //            person.name = newName
        //            self?.collectionView.reloadData()
        //
        //
        //
        //            }
        //        })
        //        ac.addAction(UIAlertAction(title:"Cancel", style: .cancel))
        //        present(ac, animated: true)
        //    }
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        // 重命名
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let renameAC = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            renameAC.addTextField()
            renameAC.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak renameAC] _ in
                guard let newName = renameAC?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            renameAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(renameAC, animated: true)
        })
        
        // 删除
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.deleteItems(at: [indexPath])
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}



//
//  RegistroTableViewController.swift
//  campanhabrinquedo
//
//  Created by user204576 on 1/9/22.
//

import UIKit
import CoreData
import Firebase

class RegistrosTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Doacao>!
    
    let collection = "doacao" // "doacao"
    var doacaoList: [DoacaoItem] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    var listener: ListenerRegistration!
    
    func loadDoacaoList(){
        listener = firestore.collection(collection).order(by: "conservacao", descending: true ).addSnapshotListener(
            includeMetadataChanges: true, listener: {
                snapshot, error in
                if let error = error {
                    print(error)
                }else{
                    guard let snapshot = snapshot else {return}
                    print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                    if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                        self.showItemsFrom(snapshot)
                    }
                }
            })
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot){
        doacaoList.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let brinquedo = data["brinquedo"] as? String, let conservacao = data["conservacao"] as? String, let doador = data["doador"] as? String,
               let endereco = data["endereco"] as? String,
               let telefone = data["telefone"] as? String {
                let doacaoItem = DoacaoItem(id: document.documentID, brinquedo: brinquedo, conservacao: conservacao, doador: doador, endereco: endereco, telefone: telefone)
                doacaoList.append(doacaoItem)
            }
        }
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDoacaoList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registroViewController = segue.destination as? RegistroViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            registroViewController.doacao = fetchedResultsController.object(at: indexPath)
        }
    }
    
    @IBAction func adicionarItem(_ sender: Any) {
        showAlertForItem()
    }

    func showAlertForItem(_ item: DoacaoItem? = nil){
        let alert = UIAlertController(title: "Doacao", message: "Informe os dados da doacao",
                                      preferredStyle: .alert)
        alert.addTextField {
            textField in textField.placeholder = "Nome doador"
            textField.keyboardType = .default
            textField.text = item?.doador.description
            
        }
        alert.addTextField {
            textField in textField.placeholder = "Brinquedo"
            textField.keyboardType = .default
            textField.text = item?.brinquedo.description
        }
        
                        alert.addTextField {
            textField in textField.placeholder = "Novo, Usado, Precisa de reparo"
            textField.keyboardType = .default
            textField.text = item?.conservacao.description
        }
        alert.addTextField {
                textField in textField.placeholder = "Endereco"
                textField.keyboardType = .default
                textField.text = item?.endereco.description
        }
        alert.addTextField {
            textField in textField.placeholder = "Telefone"
            textField.keyboardType = .default
            textField.text = item?.telefone.description
        }
            
            
        let okAction = UIAlertAction(title: "Ok", style: .default){
            _ in guard let doador = alert.textFields?.first?.text,
                       let brinquedo = alert.textFields?[1].text,
                       let conservacao = alert.textFields?[2].text,
                       let endereco = alert.textFields?[3].text,
                       let telefone = alert.textFields?.last?.text else{return}
                       
                       
        let data: [String: Any] = [
            "doador": doador,
            "brinquedo": brinquedo,
            "conservacao": conservacao,
            "endereco": endereco,
            "telefone": telefone        ]

            if let item = item {
                self.firestore.collection(self.collection).document(item.id).updateData(data)
            }else{
                self.firestore.collection(self.collection).addDocument(data: data)
            }

        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func loadRegistros(){
        let fetchRequest: NSFetchRequest<Doacao> = Doacao.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "doador", ascending:false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doacaoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RegistroTableViewCell else { return UITableViewCell() }

        //let registro = fetchedResultsController.object(at: indexPath)
        //cell.configWith(registro)
        
        let doacaoItem = doacaoList[indexPath.row]
        cell.LabelDoador.text = doacaoItem.doador
        cell.LabelBrinquedo.text = doacaoItem.brinquedo
        cell.LabelEndereco.text = doacaoItem.endereco
        
        //cell.imageViewPoster.image = UIImage(named: movie.image)
        return cell
    }
    	
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let doacaoItem = doacaoList[indexPath.row]
            firestore.collection(collection).document(doacaoItem.id).delete()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doacaoItem = doacaoList[indexPath.row]
        showAlertForItem(doacaoItem)
    }
  	
}


extension RegistrosTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}

















//
//  ViewController.swift
//  ajudacidadao
//
//  Created by user204576 on 1/8/22.
//

import UIKit

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var descricaoProblemaLabel: UITextView!
    @IBOutlet weak var enderecoProblemaLabel: UILabel!
    @IBOutlet weak var imagemProblemaImage: UIImageView!
    @IBOutlet weak var nomeDenuncianteLabel: UILabel!
    var doacao: Doacao?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registroFormViewController = segue.destination as? RegistroFormViewController{
            registroFormViewController.doacao = doacao
        }
    }

    func prepareScreen(){
        if let doacao = doacao{
            descricaoProblemaLabel.text = doacao.brinquedo
            enderecoProblemaLabel.text = doacao.endereco
            nomeDenuncianteLabel.text = doacao.doador
            
        }
        
    }
    
    

}


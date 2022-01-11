//
//  MovieTableViewCell.swift
//  ajudacidadao
//
//  Created by user204576 on 1/9/22.
//

import UIKit

class RegistroTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelDoador: UILabel!
    @IBOutlet weak var LabelEndereco: UILabel!
    @IBOutlet weak var LabelBrinquedo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configWith(_ doacao: Doacao){
        LabelDoador?.text = doacao.doador
        LabelEndereco?.text = doacao.endereco
        LabelBrinquedo?.text = doacao.brinquedo
    }
}

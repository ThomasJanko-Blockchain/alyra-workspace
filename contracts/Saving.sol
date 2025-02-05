// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SavingsAccount
 * @dev Un contrat de compte d'épargne avec restrictions de retrait pour l'administrateur.
 */
contract SavingsAccount {
    address public admin; // Adresse de l'administrateur
    uint256 public firstDepositTime; // Temps du premier dépôt
    uint256 public totalBalance; // Solde total du contrat
    uint256 public transactionCounter; // Compteur de transactions

    // Mapping pour stocker l'historique des transactions
    mapping(uint256 => Transaction) public transactions;

    // Structure d'une transaction
    struct Transaction {
        uint256 id;
        address sender;
        uint256 amount;
        uint256 timestamp;
    }

    /**
     * @dev Événements pour journalisation des actions
     */
    event Deposit(address indexed sender, uint256 amount, uint256 transactionId);
    event Withdraw(address indexed admin, uint256 amount);

    /**
     * @dev Le déployeur du contrat devient l'administrateur.
     */
    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Modifier pour restreindre l'accès à l'administrateur.
     */
    modifier onlyAdmin() {
        require(msg.sender == admin, "Seul l'admin peut effectuer cette action");
        _;
    }

    /**
     * @dev Fonction pour déposer des ethers sur le contrat.
     */
    function deposit() public payable {
        require(msg.value > 0, unicode"Le montant doit être supérieur à 0");

        // Enregistrer la date du premier dépôt
        if (totalBalance == 0) {
            firstDepositTime = block.timestamp;
        }

        // Mise à jour du solde total
        totalBalance += msg.value;

        // Sauvegarde de la transaction
        transactions[transactionCounter] = Transaction(
            transactionCounter,
            msg.sender,
            msg.value,
            block.timestamp
        );

        emit Deposit(msg.sender, msg.value, transactionCounter);

        transactionCounter++;
    }

    /**
     * @dev Fonction pour retirer les fonds (seul l'administrateur peut le faire après 3 mois).
     */
    function withdraw() public onlyAdmin {
        require(totalBalance > 0, "Pas de fonds disponibles");
        require(
            block.timestamp >= firstDepositTime + 90 days,
            unicode"Les fonds ne peuvent être retirés qu'après 3 mois"
        );

        uint256 amountToWithdraw = totalBalance;
        totalBalance = 0; // Réinitialisation du solde avant le transfert

        payable(admin).transfer(amountToWithdraw);

        emit Withdraw(admin, amountToWithdraw);
    }

    /**
     * @dev Fonction pour obtenir le solde du contrat.
     * @return Le solde du contrat en Wei.
     */
    function getBalance() public view returns (uint256) {
        return totalBalance;
    }

    /**
     * @dev Fonction pour récupérer une transaction spécifique par son ID.
     * @param _id L'ID de la transaction.
     * @return Les détails de la transaction.
     */
    function getTransaction(uint256 _id) public view returns (Transaction memory) {
        require(_id < transactionCounter, "Transaction inexistante");
        return transactions[_id];
    }
}

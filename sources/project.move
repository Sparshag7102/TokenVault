module MyModule::TokenVault {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing the vault with stored funds.
    struct Vault has store, key {
        balance: u64,
    }

    /// Function to deposit Aptos Coins into the vault.
    public fun deposit(user: &signer, amount: u64) acquires Vault {
        let vault = borrow_global_mut<Vault>(signer::address_of(user));
        let deposit_amount = coin::withdraw<AptosCoin>(user, amount);
        coin::deposit<AptosCoin>(signer::address_of(user), deposit_amount);
        vault.balance = vault.balance + amount;
    }

    /// Function for the owner to withdraw Aptos Coins from the vault.
    public fun withdraw(owner: &signer, amount: u64) acquires Vault {
        let vault = borrow_global_mut<Vault>(signer::address_of(owner));
        assert!(vault.balance >= amount, 1);

        // Withdraw from the owner's account
        let withdraw_amount = coin::withdraw<AptosCoin>(owner, amount);

        // Deposit to owner's address
        coin::deposit<AptosCoin>(signer::address_of(owner), withdraw_amount);

        // Update balance
        vault.balance = vault.balance - amount;
    }
}
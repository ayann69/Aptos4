module Chai::ChaiPurchase {

    use 0x1::Diem;
    use 0x1::Account;
    use 0x1::Event;

    struct Chai {
        price: u64,
        inventory: u64,
    }

    struct ChaiPurchasedEvent has copy, drop, store {
        buyer: address,
        amount: u64,
    }

    public fun initialize(account: &signer) {
        let chai = Chai {
            price: 1000, // Price of one chai in microdiems
            inventory: 1000, // Initial inventory
        };
        move_to(account, chai);
    }

    public fun buy_chai(buyer: &signer, amount: u64) {
        let chai_ref = borrow_global_mut<Chai>(0x1::Account::address_of(buyer));
        assert!(chai_ref.inventory >= amount, 100); // Ensure enough inventory
        let total_price = chai_ref.price * amount;
        Diem::withdraw(buyer, total_price);
        chai_ref.inventory -= amount;
        let buyer_address = 0x1::Account::address_of(buyer);
        Event::emit_event(&ChaiPurchasedEvent { buyer: buyer_address, amount });
    }

    public fun get_inventory(): u64 {
        let chai_ref = borrow_global<Chai>(0x1);
        chai_ref.inventory
    }

    public fun get_price(): u64 {
        let chai_ref = borrow_global<Chai>(0x1);
        chai_ref.price
    }
}

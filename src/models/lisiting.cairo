use::starknet::ContractAddress;

#[derive(Drop,Serde)]
 struct Listing{
    id:u64,
    seller:ContractAddress,
    price:u64,
    title:felt252,
    description:felt252,
    token_address:ContractAddress,
    quantity:u64,
    is_active:bool,
    created_at:u64,
}

#[generic_trait]
impl  ListingImpl of ListingTrait  {
    fn is_available( self : Listing) -> bool {
        self.is_active && self.quantity > 0
    }
}


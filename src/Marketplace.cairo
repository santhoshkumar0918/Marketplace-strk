#[starknet::contract]

mod Marketplace{
    use::starknet::{ContractAddress,get_caller_address,get_block_timestamp};
    use::marketplace::models::listing::{Listing,ListingImpl};
    use::marketplace::models::user::User;
    use::marketplace::models::order::{Order,OrderStatus};
}

#[event]

#[derive(Drop,starknet::Event)]
enum Event{
    ListingCreated: LisitingCreated,
    ListingUpdated:ListingUpdated,
    OrderCreated:OrderCreated,
    OrderUpdated:OrderUpdated,
}

#[derive(Drop,starknet::Event)]
struct ListingCreated{
    listing_created:u64,
    seller:ContractAddress,
    price:u256,
}

#[derive(Drop,starknet::Event)]
struct ListingUpdated{
    lisitng_id:u64,
    is_active:bool,
    quantity:u64,
}

#[derive(Drop,starknet::Event)]
 struct OrderCreated{
    order_id:u64,
    lisitng_id:u64,
    buyer:ContractAddress,
    seller:ContractAddress,
    total_price:u256,
    quantity:u64,
 }

#[derive(Drop,starknet::Event)]
struct OrderUpdated{
    order_id:u64,
    status:OrderStatus,
}

#[storage]
struct storage{
    listings:Legacymap::<u64,Listing>,
    listing_count:u64,
    orders:Legacymap::<u64,Order>,
    orders_count:u64,
    users:Legacymap::<ContractAddress,user>,
    users_listings:Legacymap::<(ContractAddress,u64),u64>,
    users_orders:Legacymap::<(ContractAddress,u64),u64>,
    platform_fee:u64,
    admin:ContractAddress,
}
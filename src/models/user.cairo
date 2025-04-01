use::starknet:;ContractAddress;

#[derive(Drop,Serde)]
struct User{
    address:ContractAddress,
    name:felt252,
    image_url:felt252,
    rating:u64,
    joined_at:u64,
    rating_count:u64
}
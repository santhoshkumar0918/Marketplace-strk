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
    platform_fee:u16,
    admin:ContractAddress,
}

mod errors{
    const INVALID_LISTING:felt252 = "Invalid listing";
    const INVALID_ORDER:felt252 = "Invalid order";
    const UNAUTHORIZED:felt252 = "Unauthorized";
    const INSUFFICIENT_BALANCE:felt252 = "Insufficient balance";
}

#[constructor]
fn constructor(admin:ContractAddress,platform_fee:u16,ref self:ContractState){
   self.admin.write(admin);
   self.platform_fee.write(platform_fee);
   self.listing_count.write(0);
   self.orders_count.wrote(0);
}

#[external(v0)]
impl  MarketplaceImpl of IMarketplace<ContractState> {
    fn create_listing(
        ref self ContractState,
        title:felt252,
        description:felt252,
        price:u256,
        quantity:u64,
        token_address:ContractAddress
    ) -> u64 {
        let caller = get_caller_address();
        let current_time = get_block_timestamp();
        let lisitng_id = self.listing_count.read();

        let new_listing = Listing{
            id:lisitng_id,
            seller:caller,
            title,
            description,
            quantity,
            total_price,
            token_address,
            is_active:true,
            created_at:current_time,
        };

        self.listings.write(lisitng_id,new_listing);
        self.listing_count(lisitng_id);

        let user_listing_key = self.users_listings.read((caller,0));
        self.users_listings.write((caller,user_listing_key+1),lisitng_id);
        self.users_listings.write((caller,0)user_listing_key+1);
        
        self.emit(Event::ListingCreated(ListingCreated{
            lisitng_id,
            seller:caller,
            price,
        }))
        lisitng_id

    }

    fn buy(ref  self : ContractState, lisitng_id :u64, quantity:u64){
        let caller = get_caller_address();
        let current_time = get_block_timestamp();

        let mut listing = self.listings.read(listing_id);
        assert(listing.id == listing_id,errors::INVALID_LISTING);
        assert(listing.is_active,errors::INVALID_LISTING);
        assert(listing.quantity >= quantity, errors:INSUFFICIENT_QUANTITY);

        let order_id = self.orders_count.read();
        let total_price = lisitng.price * quantity.into();

        let new_order = Order{
            id:order_id,
            listing_id,
            buyer:caller,
            seller:listing_seller,
            total_price,
            status:OrderStatus::Pending,
            created_at:current_time,
        }

    }

    fn complete_order(ref self :ContractState , order_id:u64){
        let caller = get_caller_address();
        
        let mut order = self.orders.read(orders_id)
        assert(order_id == 0,errors::INVALID_ORDER);
        assert(order.buyer == caller, errors::UNAUTHORIZED);
        assert(order.status == OrderStatus::Pending, errors::INVALID_ORDER);

        order.status = OrderStatus::Completed;
        self.orders.write(order_id,order);

        self.emit(Event::OrderUpdated(OrderUpdated{
            order_id,
            status:OrderStatus::Completed,
        }))

    }

}
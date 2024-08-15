use spacetimedb::{spacetimedb, ReducerContext, Identity, Timestamp};

// table area
#[spacetimedb(table)]
pub struct Person {
    name: String
}

#[spacetimedb(reducer)]
pub fn add(name: String) {
    Person::insert(Person { name });
}

//
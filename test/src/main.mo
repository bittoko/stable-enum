import Enum "../../src";
import { range; toArray } "mo:base/Iter";
import Array "mo:base/Array";
import Blob "mo:base/Blob";

actor {

  stable let state = Enum.State.init({size=122});
  
  let enum = Enum.Enumeration( state );

  public query func vals(): async [Blob] { toArray<Blob>( enum.vals() ) };

  public query func get(i: Nat): async Blob { enum.get(i) };

  public query func lookup(): async ?Nat {
    enum.lookup( Blob.fromArray( Array.tabulate<Nat8>(122, func(_)=0xAB) ) )
  };

  public func add(): async Enum.Return<Nat> {
    var byte : Nat8 = 0x00;
    for ( inc in range(0, 600) ) {
      if ( byte < 255 ) byte += 1;
      let blob : Blob = Blob.fromArray( Array.tabulate<Nat8>(122, func(_)=byte) );
      switch( enum.add(blob) ){
        case( #err msg ) return #err(msg);
        case( #ok _ ) ()
      };
    };
    #ok( enum.size() )
  };

};

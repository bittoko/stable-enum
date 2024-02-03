import { new; grow } "mo:base/Region";
import { trap } "mo:base/Debug";
import T "types";
import C "const";

module {

  let page_size : Nat64 = C.PAGE_SIZE;

  public type InitParams = {size : Nat64; capacity: Nat64};

  public func init(params: InitParams): T.StableArray {
    let memory_region : T.Region = new();
    if ( params.size > page_size ) trap("mo:stable-enum/array: line 13");
    let block_count : Nat64 = page_size / params.size;
    var page_count : Nat64 = params.capacity / block_count;
    if ( params.capacity % block_count > 0 ) page_count+=1;
    let initial_capacity : Nat64 = block_count * page_count;
    if( grow(memory_region, page_count) == 0xFFFF_FFFF_FFFF_FFFF ) trap("mo:stable-enum/array: line 20");
    let stable_array : T.StableArray = {
      var next = 0;
      var capacity = initial_capacity;
      element_size = params.size;
      elements = memory_region
    };
    stable_array
  };

  public class Array()

};
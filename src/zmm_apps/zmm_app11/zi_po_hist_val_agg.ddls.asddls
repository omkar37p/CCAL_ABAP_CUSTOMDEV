@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase order Reversed Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PO_HIST_VAL_AGG
  as select from I_PurchaseOrderItemAPI01 as I
//    left outer join ZI_PO_GR_AGG as GR
//      on  I.PurchaseOrder     = GR.PurchaseOrder
//      and I.PurchaseOrderItem = GR.PurchaseOrderItem
{
  key I.PurchaseOrder,
  key I.PurchaseOrderItem

//  sum(
//      case
//          when I.IsCompletelyDelivered = 'X'
//          then coalesce( GR.GRAmount , 0 )
//
//          else coalesce( cast( I.NetAmount as abap.dec(23,2) ), 0 )
//      end
//  ) as InrAmt,
//
//  count(*) as debug

}
//group by
//  I.PurchaseOrder

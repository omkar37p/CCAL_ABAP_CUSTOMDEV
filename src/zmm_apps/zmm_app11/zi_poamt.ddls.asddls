@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_POAMT
  as select from    ZI_PO_DELV_STATUS        as PDS
    left outer join ZMM_PO_REVERSED as MDI on MDI.PurchaseOrder = PDS.PurchaseOrder
                                               and MDI.PurchaseOrderItem = PDS.PurchaseOrderItem   //"new code 
//    left outer join I_MaterialDocumentItem_2 as MDI on MDI.PurchaseOrder = PDS.PurchaseOrder
//                                               and MDI.PurchaseOrderItem = PDS.PurchaseOrderItem  //""old code

{
  key   PDS.BudgetCode,
        PDS.PurchaseOrder,
        PDS.BaseUnit,
        PDS.DocumentCurrency,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        PDS.POqty                     as POqty,
        @Semantics.amount.currencyCode: 'DocumentCurrency'
        PDS.POrate                    as Rate,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'
        MDI.QuantityInEntryUnit       as MIGOqty,
        @Semantics.amount.currencyCode: 'DocumentCurrency'
        cast( case
                when PDS.POqty = MDI.QuantityInEntryUnit and PDS.Status = 'X'
                  then cast(PDS.POrate as abap.dec( 13, 2 )) * cast(MDI.QuantityInEntryUnit as abap.dec( 13, 2 ))

                when MDI.QuantityInEntryUnit < PDS.POqty and PDS.Status = 'X'
                  then cast(PDS.POrate as abap.dec( 13, 2 )) * cast(MDI.QuantityInEntryUnit as abap.dec( 13, 2 ))

                when MDI.QuantityInEntryUnit is null and PDS.Status <> 'X'
                  then cast(PDS.POrate as abap.dec( 13, 2 )) * cast(PDS.POqty as abap.dec( 13, 2 ))

                when MDI.QuantityInEntryUnit is null and PDS.Status = 'X'
                  then 0
//New one added by 14-07-26
               when MDI.QuantityInEntryUnit is not initial and PDS.Status <> 'X'
                  then cast(PDS.POrate as abap.dec( 13, 2 )) * cast(PDS.POqty as abap.dec( 13, 2 ))
//New one added by 14-07-26
             else 0
           end  as abap.dec( 17, 2 )) as POAmt
//        @Semantics.amount.currencyCode: 'DocumentCurrency'
//        cast(
//          case
//            when PDS.Status = 'X'
//              then cast( PDS.POrate as abap.dec(13,2) )
//                 * cast( PDS.POqty as abap.dec(13,2) )
//
//            else 0
//          end
//          as abap.dec(17,2)
//        )                             as TotalPOAmt


}
group by
  PDS.PurchaseOrder,
  PDS.BaseUnit,
  PDS.DocumentCurrency,
  PDS.POqty,
  PDS.POrate,
  MDI.QuantityInEntryUnit,
  PDS.Status,
  PDS.BudgetCode


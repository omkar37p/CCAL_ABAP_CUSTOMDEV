@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order with Budget detials'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURORD_DATA01
  as select from I_PurchaseOrderItemAPI01
  association [0..*] to I_PurchaseOrderAPI01 as _POhdr on $projection.PurchaseOrder = _POhdr.PurchaseOrder
  association [0..*] to I_PurchaseOrderHistoryAPI01 as _POhstr on $projection.PurchaseOrder = _POhstr.PurchaseOrder
                                                                and $projection.PurchaseOrderItem = _POhstr.PurchaseOrderItem
                                                                and _POhstr.PurchasingHistoryCategory = 'E'
                                                                and _POhstr.IsCompletelyDelivered = 'X'
                                                               
  
{
  key I_PurchaseOrderItemAPI01.PurchaseOrder,
  key I_PurchaseOrderItemAPI01.PurchaseOrderItem,
      I_PurchaseOrderItemAPI01.DocumentCurrency,
      I_PurchaseOrderItemAPI01.PurchasingDocumentDeletionCode,
      I_PurchaseOrderItemAPI01.Material,
      I_PurchaseOrderItemAPI01.MaterialType,
      I_PurchaseOrderItemAPI01.Plant,
      I_PurchaseOrderItemAPI01.PurchaseOrderQuantityUnit                                                                       as POUNIT,
      I_PurchaseOrderItemAPI01.NetPriceQuantity,
      I_PurchaseOrderItemAPI01.IsCompletelyDelivered,
      I_PurchaseOrderItemAPI01.IsFinallyInvoiced,
      I_PurchaseOrderItemAPI01.PurchaseRequisition,
      I_PurchaseOrderItemAPI01.PurchaseRequisitionItem,
      I_PurchaseOrderItemAPI01.BaseUnit,
      I_PurchaseOrderItemAPI01.OrderPriceUnit                                                                                  as PRICEUNIT,
      @Semantics.quantity.unitOfMeasure: 'POUNIT'
      I_PurchaseOrderItemAPI01.OrderQuantity,
      @Semantics.amount.currencyCode: 'bdgcurr'
      I_PurchaseOrderItemAPI01.NetPriceAmount,
      @Semantics.amount.currencyCode: 'bdgcurr'
      I_PurchaseOrderItemAPI01.NetAmount                                                                                       as netamt,
      @Semantics.amount.currencyCode: 'bdgcurr'
      I_PurchaseOrderItemAPI01.EffectiveAmount                                                                                 as effamt,
      _POhdr.ExchangeRate                                                                                                      as ExcRate,
      @Semantics.amount.currencyCode: 'bdgcurr'
//      case when _POhstr.IsCompletelyDelivered <> 'X'
//      then
//           ( cast(_POhdr.ExchangeRate as abap.dec( 13, 2 )) * cast(I_PurchaseOrderItemAPI01.EffectiveAmount as  abap.dec( 13, 2 )  ))
//           else 
//      ( cast(_POhdr.ExchangeRate as abap.dec( 13, 2 )) * cast(_POhstr.PurchaseOrderAmount as abap.dec( 13, 2 )) ) end  as inramt,
//@Semantics.amount.currencyCode: 'Currency'
cast(
    case
        when ( I_PurchaseOrderItemAPI01.IsCompletelyDelivered ) = 'X'
        then
            cast(_POhdr.ExchangeRate as abap.dec(13,2)) * cast(_POhstr.PurOrdAmountInCompanyCodeCrcy as abap.dec(13,2))
        else
            cast(_POhdr.ExchangeRate as abap.dec(13,2)) * cast(I_PurchaseOrderItemAPI01.EffectiveAmount as abap.dec(13,2))
    end
    as abap.dec( 17, 2 )
) as inramt,
//cast(_POhdr.ExchangeRate as abap.dec(13,2)) * cast(I_PurchaseOrderItemAPI01.EffectiveAmount as abap.dec(13,2))as inramt,
// cast(_POhdr.ExchangeRate as abap.dec(13,2)) * cast(_POhstr.PurchaseOrderAmount as abap.dec(13,2))as inramt,
      @Semantics.amount.currencyCode: 'bdgcurr'
      I_PurchaseOrderItemAPI01.YY1_allotted_budget_PDI                                                                         as bdgamt,
      I_PurchaseOrderItemAPI01.YY1_allotted_budget_PDIC                                                                        as bdgcurr,
      I_PurchaseOrderItemAPI01.YY1_budget_code_PDI                                                                             as bdgcode,
      /* Associations */
      I_PurchaseOrderItemAPI01._PurchaseOrder,
      I_PurchaseOrderItemAPI01._PurOrdAcctAssignment,
      I_PurchaseOrderItemAPI01._PurOrdScheduleLine,
      I_PurchaseOrderItemAPI01._YY1_allotted_budget_PDI
 

}
where
  I_PurchaseOrderItemAPI01.PurchasingDocumentDeletionCode <> 'L'

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - PO Data new'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_APP11_PO3 
  as select from I_PurchaseOrderItemAPI01
  left outer join ZMM_APP11_PO4 as poh on poh.PurchaseOrder = I_PurchaseOrderItemAPI01.PurchaseOrder
                                          and poh.PurchaseOrderItem = I_PurchaseOrderItemAPI01.PurchaseOrderItem  
  association [0..*] to I_PurchaseOrderAPI01 as _POhdr on $projection.PurchaseOrder = _POhdr.PurchaseOrder
//  association [0..*] to I_PurchaseOrderHistoryAPI01 as _POhstr on $projection.PurchaseOrder = _POhstr.PurchaseOrder
//                                                                and $projection.PurchaseOrderItem = _POhstr.PurchaseOrderItem
//                                                                and _POhstr.PurchasingHistoryCategory = 'E'
//                                                                and _POhstr.IsCompletelyDelivered = 'X'
  association [0..*] to I_PurchaseOrderHistoryAPI01 as _POhstr on  _POhstr.PurchaseOrder = poh.PurchaseOrder
                                                                and _POhstr.PurchasingHistoryDocument = poh.PurchasingHistoryDocument    
                                                                and  _POhstr.PurchaseOrderItem = poh.PurchaseOrderItem
                                                                and _POhstr.PurchasingHistoryDocumentItem = poh.PurchasingHistoryDocumentItem
                                                                and _POhstr.PurchasingHistoryCategory = 'E'
                                                                and _POhstr.IsCompletelyDelivered = 'X'                                                                
{
  key I_PurchaseOrderItemAPI01.PurchaseOrder,
  key I_PurchaseOrderItemAPI01.PurchaseOrderItem,
      I_PurchaseOrderItemAPI01.PurchaseOrderQuantityUnit as POUNIT,    
      _POhdr.ExchangeRate as ExcRate,
      I_PurchaseOrderItemAPI01.IsCompletelyDelivered,
      @Semantics.amount.currencyCode: 'bdgcurr'
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
      @Semantics.amount.currencyCode: 'bdgcurr'
      I_PurchaseOrderItemAPI01.YY1_allotted_budget_PDI as bdgamt,
      I_PurchaseOrderItemAPI01.YY1_allotted_budget_PDIC as bdgcurr,
      I_PurchaseOrderItemAPI01.YY1_budget_code_PDI as bdgcode
      
}
where
  I_PurchaseOrderItemAPI01.PurchasingDocumentDeletionCode <> 'L'

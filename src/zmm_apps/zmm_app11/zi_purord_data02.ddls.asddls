@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Orders Budget Detials'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED 
}
define view entity ZI_PURORD_DATA02
  as select from I_PurchaseOrderItemAPI01 as _POitm
    inner join   I_PurchaseOrderAPI01     as _POhdr on _POhdr.PurchaseOrder = _POitm.PurchaseOrder
    inner join   I_ProductDescription_2   as _mdesc on  _mdesc.Product  = _POitm.Material
                                                    and _mdesc.Language = 'E'
    inner join   I_Supplier               as _supp  on _supp.Supplier = _POhdr.Supplier
    inner join   I_PurchaseOrderStatus    as _sts   on _sts.PurchaseOrder = _POitm.PurchaseOrder

{
  key _POitm.PurchaseOrder,
  key _POitm.PurchaseOrderItem,
      _POitm.DocumentCurrency,
      _POitm.PurchasingDocumentDeletionCode,
      _POitm.Material,
      _POitm.MaterialType,
      _POitm.Plant,
      _POitm.PurchaseOrderQuantityUnit                                                                       as POUNIT,
      _POitm.NetPriceQuantity,
      _POitm.IsCompletelyDelivered,
      _POitm.IsFinallyInvoiced,
      _POitm.PurchaseRequisition,
      _POitm.PurchaseRequisitionItem,
      _POitm.BaseUnit,
      _POitm.OrderPriceUnit                                                                                  as PRICEUNIT,
      @Semantics.quantity.unitOfMeasure: 'POUNIT'
      _POitm.OrderQuantity,
      @Semantics.amount.currencyCode: 'bdgcurr'
      _POitm.NetPriceAmount,
      @Semantics.amount.currencyCode: 'bdgcurr'
      _POitm.NetAmount                                                                                       as netamt,
      @Semantics.amount.currencyCode: 'bdgcurr'
      _POitm.EffectiveAmount                                                                                 as effamt,
      _POhdr.ExchangeRate                                                                                    as ExcRate,
      @Semantics.amount.currencyCode: 'bdgcurr'
      //      ( cast(_POhdr.ExchangeRate as abap.fltp) * cast(_POitm.OrderQuantity as abap.fltp) ) as inramt,
      ( cast(_POhdr.ExchangeRate as abap.dec( 13, 2 )) * cast(_POitm.EffectiveAmount as abap.dec( 13, 2 )) ) as inramt,
      @Semantics.amount.currencyCode: 'bdgcurr'
      _POitm.YY1_allotted_budget_PDI                                                                         as bdgamt,
      _POitm.YY1_allotted_budget_PDIC                                                                        as bdgcurr,
      right(_POitm.YY1_budget_code_PDI, 10)                                                                  as bdgcode,
      /* Associations */
      _POitm._PurchaseOrder,
      _POitm._PurOrdAcctAssignment,
      _POitm._PurOrdScheduleLine,
      _POitm._YY1_allotted_budget_PDI,
      _mdesc.ProductDescription                                                                              as matdesc,
      _POhdr.Supplier,
      _supp.SupplierName                                                                                     as suppname,
      _POhdr.PurchaseOrderDate                                                                               as POdate,
      _sts.PurchasingDocumentStatus                                                                          as status

}
where
  _POitm.PurchasingDocumentDeletionCode <> 'L'

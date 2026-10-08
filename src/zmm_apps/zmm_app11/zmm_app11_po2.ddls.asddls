@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventory Budget Report - PO data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP11_PO2
  // as select from I_PurchaseRequisitionItemAPI01 as pr
  as select from I_PurchaseOrderItemAPI01 as pr
//      inner join   ZI_PURORD_DATA01         as po on  po.PurchaseOrder     = pr.PurchaseOrder
//                                                and po.PurchaseOrderItem = pr.PurchaseOrderItem
      inner join   ZMM_APP11_PO3         as po on  po.PurchaseOrder     = pr.PurchaseOrder
                                                and po.PurchaseOrderItem = pr.PurchaseOrderItem  
//    inner join   ZI_PO_HIST_VAL_AGG         as po on  po.PurchaseOrder     = pr.PurchaseOrder //  changes "reversed code by 20.06.2026
////                                                and po.PurchaseOrderItem = pr.PurchaseOrderItem //"reversed code by 20.06.2026
{
  key right( pr.YY1_budget_code_PDI, 10 ) as bgdcode,

      //      @Semantics.amount.currencyCode: 'DocumentCurrency'
      sum( po.inramt )                    as totpoamt
//      count(*) as debug_count   "reversed code by 20.06.2026
}
group by
  pr.YY1_budget_code_PDI

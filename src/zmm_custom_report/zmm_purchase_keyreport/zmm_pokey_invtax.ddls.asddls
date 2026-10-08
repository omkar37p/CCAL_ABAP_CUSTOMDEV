@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Key Register Report Tax'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_POKEY_INVTAX
  as select from    I_PurchaseOrderAPI01           as _POH
    inner join      I_PurchaseOrderItemAPI01       as _POI  on _POI.PurchaseOrder = _POH.PurchaseOrder
    left outer join I_PurOrdItmPricingElementAPI01 as ZDGP on ZDGP.PurchaseOrder = _POI.PurchaseOrder
                                                and ZDGP.PurchaseOrderItem = _POI.PurchaseOrderItem
                                                and ZDGP.ConditionType = 'ZDGP'
    left outer join I_PurOrdItmPricingElementAPI01 as ZDGV on ZDGV.PurchaseOrder = _POI.PurchaseOrder
                                                and ZDGV.PurchaseOrderItem = _POI.PurchaseOrderItem
                                                and ZDGV.ConditionType = 'ZDGV'
    left outer join I_PurOrdItmPricingElementAPI01 as ZDNP on ZDNP.PurchaseOrder = _POI.PurchaseOrder
                                                and ZDNP.PurchaseOrderItem = _POI.PurchaseOrderItem
                                                and ZDNP.ConditionType = 'ZDNP'                                                     
{
  key _POI.PurchaseOrder,
  key _POI.PurchaseOrderItem,
      _POI.TaxCode,
      _POI.BaseUnit,
      _POI.DocumentCurrency,
      
      cast(_POI.OrderQuantity as abap.dec( 15, 3 )) as OrderQuantity,      
      cast(_POI.NetPriceAmount as abap.dec( 15, 2 )) as NetPriceAmount,
      cast(_POI.NetAmount as abap.dec( 15, 2 )) as NetAmount,
      case
           when _POI.TaxCode = '1C' then
                cast((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 18) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 18%
           when _POI.TaxCode = '1A' then
                cast((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 5) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 5%  
           when _POI.TaxCode = '1B' then
                cast((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 12) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 12%  
           when _POI.TaxCode = '1D' then
                cast((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 28) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 28%  
                else null end as IGSTAmount,
     
     case
           when _POI.TaxCode = '1F' then
                cast(((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 5 ) / 100 ) / 2 as abap.dec( 15, 2 ))    // Tax Rate CGST/SGST 5%
           when _POI.TaxCode = '1G' then
                cast(((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 12 ) / 100 ) / 2 as abap.dec( 15, 2 ))   // Tax Rate CGST/SGST 5%
           when _POI.TaxCode = '1H' then
                cast(((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 18 ) / 100 ) / 2 as abap.dec( 15, 2 ))   // Tax Rate CGST/SGST 5%
           when _POI.TaxCode = '1I' then
                cast(((cast(_POI.NetAmount as abap.dec( 15, 2 )) * 28 ) / 100 ) / 2 as abap.dec( 15, 2 ))   // Tax Rate CGST/SGST 5%     
                else null end as CSGSTAmount,
     case
            when ZDGP.ConditionType = 'ZDGP' then cast(ZDGP.ConditionAmount as abap.dec( 15, 2 ))
            when ZDGV.ConditionType = 'ZDGV' then  cast(ZDGV.ConditionAmount as abap.dec( 15, 2 ))
            when ZDNP.ConditionType = 'ZDNP'  then cast(ZDNP.ConditionAmount as abap.dec( 15, 2 ))
            else null end as DiscountAmt             
      
   
}

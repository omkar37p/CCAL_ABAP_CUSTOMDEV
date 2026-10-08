@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order GST Tax Value'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP18_POTAX
  as select from I_PurchaseOrderAPI01     as POH
    inner join   I_PurchaseOrderItemAPI01 as POI on POI.PurchaseOrder = POH.PurchaseOrder
{
  key POI.PurchaseOrder,
  key POI.PurchaseOrderItem,
      POI.TaxCode,
      POI.BaseUnit,
      POI.DocumentCurrency,

      cast(POI.OrderQuantity as abap.dec( 15, 3 ))  as OrderQuantity,
      cast(POI.NetPriceAmount as abap.dec( 15, 2 )) as NetPriceAmount,
      cast(POI.NetAmount as abap.dec( 15, 2 ))      as NetAmount,
      case
           when POI.TaxCode = '1C' then
                cast((cast(POI.NetAmount as abap.dec( 15, 2 )) * 18) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 18%
           when POI.TaxCode = '1A' then
                cast((cast(POI.NetAmount as abap.dec( 15, 2 )) * 5) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 5%
           when POI.TaxCode = '1B' then
                cast((cast(POI.NetAmount as abap.dec( 15, 2 )) * 12) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 12%
           when POI.TaxCode = '1D' then
                cast((cast(POI.NetAmount as abap.dec( 15, 2 )) * 28) / 100 as abap.dec( 15, 2 ))         // Tax rate IGST 28%
                else null end                       as IGSTAmount,
      case
            when POI.TaxCode = '1A' then '5.00'
            when POI.TaxCode = '1B' then '12.00'
            when POI.TaxCode = '1C' then '18.00'
            when POI.TaxCode = '1D' then '28.00'
            else null end                           as IGSTConrate,

      case
            when POI.TaxCode = '1A' then 'JIIG'
            when POI.TaxCode = '1B' then 'JIIG'
            when POI.TaxCode = '1C' then 'JIIG'
            when POI.TaxCode = '1D' then 'JIIG'
            else null end                           as IGSTContype,
      case
            when POI.TaxCode = '1F' then
                 cast(((cast(POI.NetAmount as abap.dec( 15, 2 )) * 5 ) / 100 ) / 2 as abap.dec( 15, 2 ))    // Tax Rate CGST/SGST 5%
            when POI.TaxCode = '1G' then
                 cast(((cast(POI.NetAmount as abap.dec( 15, 2 )) * 12 ) / 100 ) / 2 as abap.dec( 15, 2 ))   // Tax Rate CGST/SGST 5%
            when POI.TaxCode = '1H' then
                 cast(((cast(POI.NetAmount as abap.dec( 15, 2 )) * 18 ) / 100 ) / 2 as abap.dec( 15, 2 ))   // Tax Rate CGST/SGST 5%
            when POI.TaxCode = '1I' then
                 cast(((cast(POI.NetAmount as abap.dec( 15, 2 )) * 28 ) / 100 ) / 2 as abap.dec( 15, 2 ))   // Tax Rate CGST/SGST 5%
                 else null end                      as CSGSTAmount,
      case
            when POI.TaxCode = '1F' then '2.50'
            when POI.TaxCode = '1G' then '6.00'
            when POI.TaxCode = '1H' then '9.00'
            when POI.TaxCode = '1I' then '14.00'
            else null end                           as CGSTConrate,

      case
            when POI.TaxCode = '1F' then 'JICG'
            when POI.TaxCode = '1G' then 'JICG'
            when POI.TaxCode = '1H' then 'JICG'
            when POI.TaxCode = '1I' then 'JICG'
            else null end                           as CGSTContype

}

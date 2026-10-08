@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Note Item Print view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_ITEM_PRINT 
as select from ZMM_APP20_ITEM_RV
{
key Uuid,
key Materialdocument,
key Materialdocumentyear,
key Materialdocumentitem,
Plant,
Companycode,
Companycodecurrency,
Material,
Productdescription,
Materialbaseunit,
@Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
Migoqty,
@Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
Poqty,
@Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
Invoiceqty,
@Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
Receivedqty,
@Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
Acceptedqty,
@Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
Rejectedqty
   
}

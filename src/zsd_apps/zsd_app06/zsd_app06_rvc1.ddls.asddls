@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Gate Out delivery Child Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP06_RVC1 as select from I_DeliveryDocument
association to parent ZSD_APP06_RV as _header on $projection.DeliveryDocument = _header.Delvnum
{
   key DeliveryDocument,

   OverallSDProcessStatus,
  
   OverallGoodsMovementStatus,
   
   /* Associations */
  _header,
  
    case when OverallSDProcessStatus = 'B' and OverallGoodsMovementStatus = 'A'
    then 'Delivery In Process'
    when OverallSDProcessStatus = 'B' and OverallGoodsMovementStatus = 'C'
    then 'Delivery Is Completed'
    when  OverallSDProcessStatus = 'C' and OverallGoodsMovementStatus = 'C'
    then 'Delivery Is Completed'
    else 'Delivery In Process' end as STAUSDEL

}

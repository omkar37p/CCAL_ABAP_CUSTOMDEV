@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Gate Out delivery Child Projection Entity 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZSD_APP06_PVC1 as projection on ZSD_APP06_RVC1
{
    key DeliveryDocument,

    OverallSDProcessStatus,
  
    OverallGoodsMovementStatus,
    
    STAUSDEL,
   
    /* Associations */
    _header  : redirected to parent ZSD_APP06_PV
    
  
    
  
}

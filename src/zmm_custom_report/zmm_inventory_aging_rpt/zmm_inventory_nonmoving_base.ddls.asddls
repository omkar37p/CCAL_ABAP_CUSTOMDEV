@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nonmoving date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_INVENTORY_NONMOVING_BASE 
as select from ZINC_DATE_V as ms
{
  key ms.Material         as Material,
  key ms.Batch            as Batch,
  key ms.Plant            as Plant,
  key ms.StorageLocation  as StorageLocation,

  case
    when ms.Pos1 is initial
    then cast( dats_days_between( ms.Pos , $session.system_date ) as abap.int8 )
    else cast( dats_days_between( ms.Pos1 , $session.system_date ) as abap.int8 )
  end as NonMovingDays

    
}

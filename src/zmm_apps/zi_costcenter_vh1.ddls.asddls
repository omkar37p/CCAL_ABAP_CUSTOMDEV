@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cost Center as Depatment VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COSTCENTER_VH1
  as select from I_CostCenter
  association [0..*] to I_CostCenterText as _Text on  $projection.ControllingArea = _Text.ControllingArea
                                                  and $projection.CostCenter      = _Text.CostCenter
                                                  and $projection.ValidityEndDate = _Text.ValidityEndDate
{
  key ControllingArea,
  key CostCenter,
  key ValidityEndDate,
      CompanyCode,
      BusinessArea,
      CostCenterCategory,
      Plant,
      
      _Text.CostCenterDescription as CCname

}

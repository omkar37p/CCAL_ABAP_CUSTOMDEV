@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Parameter'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity zpp_qm_parameter_vh as select from I_InspSpecificationVersion
{
@UI.hidden: true
key InspectionSpecificationPlant,
@Search.defaultSearchElement: true 
key InspectionSpecification,
@UI.hidden: true
key InspectionSpecificationVersion,
@Search.defaultSearchElement: true 
InspectionSpecificationSrchTxt

}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Lot Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: { dataCategory: #VALUE_HELP }
@Search.searchable: true
define view entity ZINSPECTION_VH as select from I_InspectionLot as INS
left outer join I_ProductDescription as prodesc on prodesc.Product = INS.Material
                                              and prodesc.Language = $session.system_language
                                
{
@Search.defaultSearchElement: true
    key INS.InspectionLot,
@Search.defaultSearchElement: true    
    INS.Material as Product,
@Search.defaultSearchElement: true    
    prodesc.ProductDescription as ProductName,
@Search.defaultSearchElement: true    
    INS.Plant,
    INS.InspectionLotType    
}

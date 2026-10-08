@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom Inspection Characteristic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZQM_INSPECTIONCHARACTERISTIC as select from I_InspectionCharacteristic
{
 key InspectionLot,
 key InspPlanOperationInternalID,
 key InspectionCharacteristic,   
     InspectionMethod,
     InspectionMethodPlant,
     InspectionSpecificationUnit,
     InspectionCharacteristicText,
     InspectionSpecification,
     InspSpecInformationField3,
     concat_with_space(InspSpecInformationField1, InspSpecInformationField2, 1) as Inspectionname
//     concat( concat(InspSpecInformationField1,' '), InspSpecInformationField2 ) as Inspectionname
}

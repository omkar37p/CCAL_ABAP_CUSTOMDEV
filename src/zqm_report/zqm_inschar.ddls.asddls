@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Characteristic View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZQM_INSCHAR 
as select from I_InspectionCharacteristic
{
    key InspectionLot,
    key InspectionCharacteristic,
    key InspPlanOperationInternalID,
    
    concat_with_space(
        concat(
            concat(
                cast( cast( InspSpecLowerLimit as abap.dec(15,3) ) as abap.char(20) ),
                '-'
            ),
            cast( cast( InspSpecUpperLimit as abap.dec(15,3) ) as abap.char(20) )
        ),
        InspectionSpecificationUnit,
        1
    ) as Specification,

      //"" Inspection Specification
      case
      when InspSpecLowerLimit is initial
      or InspSpecLowerLimit is null
      then '-'
      else cast( cast( InspSpecLowerLimit as abap.dec(16,3) ) as abap.char(22) )
      end                                             as InspSpecLowerLimit,

      case
      when InspSpecUpperLimit is initial
      or InspSpecUpperLimit is null
      then '-'
      else cast( cast( InspSpecUpperLimit as abap.dec(16,3) ) as abap.char(22) )
      end                                             as InspSpecUpperLimit,
    
    InspSpecLowerLimit as Minimum,
    InspSpecUpperLimit as Maximum
}

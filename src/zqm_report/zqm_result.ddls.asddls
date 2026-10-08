@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QM Custom result view'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZQM_RESULT as select from I_InspectionResult as _INSVAL  //I_InspectionResult I_InspectionCharacteristic _INSVAL _INSCHA
association[0..1] to I_InspectionCharacteristic as _INSCHA  on _INSVAL.InspectionLot = _INSCHA.InspectionLot
                                                and _INSVAL.InspPlanOperationInternalID = _INSCHA.InspPlanOperationInternalID
                                                and _INSVAL.InspectionCharacteristic = _INSCHA.InspectionCharacteristic
association [1..*] to I_BusinessUserBasic as _cbname on _INSVAL.CreatedByUser = _cbname.UserID
association [1..1] to I_InspectionCodeText as _Codetext on _INSVAL.CharacteristicAttributeCatalog = _Codetext.InspectionCatalog
                                                and _INSVAL.CharacteristicAttributeCode = _Codetext.InspectionCode
                                                and _INSVAL.CharacteristicAttributeCodeGrp = _Codetext.InspectionCodeGroup
                                                and _Codetext.Language = $session.system_language                                      

{
key _INSCHA.InspectionLot,
key _INSCHA.InspPlanOperationInternalID,
key _INSCHA.InspectionCharacteristic,
_INSCHA.InspectionCharacteristicText,
_INSCHA.InspectionSpecification,
_INSVAL.CreationDate,
_INSVAL.InspectionEndTime,
_INSVAL.InspectionResultMeanValue as InspectionResultMetest,
cast(_INSVAL.InspectionResultMeanValue as abap.dec( 15, 4 )) as  InResult,
//fltp_to_dec(_INSVAL.InspectionResultMeanValue as abap.dec( 15, 4 )) as  InResult,
_INSVAL.Inspector,
_INSVAL.InspectionResultText as InspectionDescription,
_INSVAL.CharacteristicAttributeCode,
_INSVAL.CharacteristicAttributeCatalog,
_INSVAL.CharacteristicAttributeCodeGrp,
case
    when _INSVAL.InspectionValuationResult = 'A' then 'Accpeted'
    when _INSVAL.InspectionValuationResult = 'R' then 'Rejected'
    else null end as Status,
case
    when _INSVAL.InspectionResultAttribute = '<' then 'NMT'
    else null end as Notmorethen,
_cbname.PersonFullName,
_Codetext    ,
_INSCHA.InspSpecDecimalPlaces
}
where (_INSVAL.InspRsltFreeDefinedTestEquip = 'P' or _INSCHA.InspSpecInformationField1 = 'P');

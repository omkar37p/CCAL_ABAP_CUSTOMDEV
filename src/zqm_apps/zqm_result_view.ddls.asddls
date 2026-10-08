@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QM Inspection Result View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZQM_RESULT_VIEW
  as select from I_InspectionResult         as _Insv
    inner join   ZQM_INSPECTIONCHARACTERISTIC as _Insc on  _Insv.InspectionLot               = _Insc.InspectionLot
                                                     and _Insv.InspPlanOperationInternalID = _Insc.InspPlanOperationInternalID
                                                     and _Insv.InspectionCharacteristic    = _Insc.InspectionCharacteristic
  //association[0..1] to I_InspectionCharacteristic as _Insc  on _Insv.InspectionLot = _Insc.InspectionLot
  //                                                and _Insv.InspPlanOperationInternalID = _Insc.InspPlanOperationInternalID
  //                                                and _Insv.InspectionCharacteristic = _Insc.InspectionCharacteristic
  association [1..1] to I_InspectionCodeText as _Codetext on  _Insv.CharacteristicAttributeCatalog = _Codetext.InspectionCatalog
                                                          and _Insv.CharacteristicAttributeCode    = _Codetext.InspectionCode
                                                          and _Insv.CharacteristicAttributeCodeGrp = _Codetext.InspectionCodeGroup
                                                          and _Codetext.Language                   = $session.system_language

  association [1..*] to ZQM_INSPE_METHOD     as _Method   on  _Method.InspectionMethod      = _Insc.InspectionMethod
                                                          and _Method.InspectionMethodPlant = _Insc.InspectionMethodPlant
  association [1..*] to I_BusinessUserBasic as _cbname on _Insv.CreatedByUser = _cbname.UserID
  association [1..1] to ZQM_UnitOfMeasureText as _unittext on _Insc.InspectionSpecificationUnit = _unittext.UnitOfMeasure
                                                           and _unittext.Language = $session.system_language                                                          


{

  key _Insc.InspectionLot,
  key _Insc.InspPlanOperationInternalID,
  key _Insc.InspectionCharacteristic,
      _Insc.InspectionCharacteristicText,
      _Insc.InspectionSpecification,
//      cast(_Insc.InspectionMethod as abap.sstring( 50 )) as InspectionMethod,
      _Codetext.InspectionCodeText,
      _cbname.PersonFullName,
      _Insv.InspRsltFreeDefinedTestEquip as Indicators,
      case
            when _Insc.InspectionSpecificationUnit is initial then '-'
//            else _unittext.UnitofMeas end as UnitOfMeasureTechnicalName,
            else _unittext.UnitOfMeasureTechnicalName end as UnitOfMeasureTechnicalName,            
      case
          when _Insc.InspectionSpecificationUnit is initial then '-'
          else _Insc.InspectionSpecificationUnit end     as InspectionSpecificationUnit,
      case
//          when _Insc.InspectionSpecificationUnit is initial then _Codetext.InspectionCodeText
          when ( _Insv.CharacteristicAttributeCodeGrp is not initial )  
                        then _Codetext.InspectionCodeText          
          else _Insv.InspectionResultOriginalValue end   as InspectionResultMeanValue,
          
      _Method.InspectionMethodSearchField                as InspectionMeth,

      case
          when _Insc.InspectionSpecificationUnit is initial then _Codetext.InspectionCodeText
          when _Insv.InspectionResultAttribute = '<' then (concat('NMT:', substring(_Insv.InspectionResultOriginalValue,2,24 )))
          when _Insv.InspectionResultAttribute = '>' then (concat('Greater Then:', substring(_Insv.InspectionResultOriginalValue,2,24 )))
          else _Insv.InspectionResultOriginalValue end   as ResultMeanValue,
       concat_with_space(_Insc.Inspectionname, _Insc.InspSpecInformationField3, 1 ) as InspSpecificationName
          
}
where _Insv.InspRsltFreeDefinedTestEquip is initial

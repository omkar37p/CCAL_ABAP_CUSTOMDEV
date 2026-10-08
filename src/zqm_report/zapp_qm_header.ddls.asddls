@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QM Custom report Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZAPP_QM_HEADER
  as select from I_InspectionLot as _insph
//  composition [1..*] of ZAPP_QM_ITEM               as _Qmitem
  inner join  ZQM_RESULT                 as _InspR   on  _InspR.InspectionLot = _insph.InspectionLot
  left outer join I_InspectionOperation as _Opere on _Opere.InspectionLot = _InspR.InspectionLot
                                                                and _Opere.OrderOperationInternalID = _InspR.InspPlanOperationInternalID
  left outer join ZQM_INSCHAR as Spe on Spe.InspectionLot = _InspR.InspectionLot
                                                 and Spe.InspectionCharacteristic = _InspR.InspectionCharacteristic
                                                 and Spe.InspPlanOperationInternalID = _InspR.InspPlanOperationInternalID
                                                 
  association [1..1] to I_ProductDescription       as _PRD_DES on  _insph.Material = _PRD_DES.Product
                                                               and _PRD_DES.Language        = $session.system_language
  association [1..*] to I_BusinessUserBasic        as _cbname  on  _insph.InspectionLotCreatedBy = _cbname.UserID
  association [1..1] to I_MaterialDocumentHeader_2 as _truckNo on  _insph.MaterialDocument     = _truckNo.MaterialDocument
                                                               and _insph.MaterialDocumentYear = _truckNo.MaterialDocumentYear
  association [1..1] to I_Supplier                 as _Supname on  _insph.Supplier = _Supname.Supplier


{

  key _insph.InspectionLot,
  key _InspR.InspPlanOperationInternalID,
  key _InspR.InspectionCharacteristic,
      _insph.Material,
      _insph.Plant,
      _insph.InspectionLotType,
      @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
      _insph.InspectionLotQuantity,
      _insph.InspectionLotQuantityUnit,
      _insph.MaterialDocument,
      _insph.MaterialDocumentItem,
      _insph.MaterialDocumentYear,
      _insph.InspectionLotCreatedOn,
      _insph.InspectionLotText,
      _insph.Batch,
      _insph.InspectionLotStartDate,
      _insph.InspectionLotStartDate as InspectionLotStartDate1,
      _PRD_DES.ProductDescription,
      _cbname.PersonFullName,
      _truckNo.MaterialDocumentHeaderText as Truckno,
      _Supname.BPSupplierFullName,
      _InspR.InspectionSpecification,
      _InspR.InspectionCharacteristicText,
      _InspR.Notmorethen,
      _InspR._Codetext.InspectionCodeText as CharacteristicAttributeCode,
      _InspR.Status,
      _InspR.InspectionDescription,
      _InspR.CreationDate,
      _InspR.InspectionEndTime,
      _InspR.PersonFullName               as ResultCreatedBy,
      _Opere.OperationText,
      _InspR.InResult,
      Spe.Specification,
      Spe.InspSpecLowerLimit,
      Spe.InspSpecUpperLimit
//      cast(_InspR.InResult as abap.dec(5,_InspR.InspSpecDecimalPlaces )) as Result 
      //        _query,
//      _Qmitem


}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QM Custom report item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZAPP_QM_ITEM 
as select from ZQM_RESULT as _Item
left outer join ZAPP_QM_QUERY as _head on _head.InspectionLot = _Item.InspectionLot
//association to parent ZAPP_QM_HEADER as _Qmhead
//                 on $projection.InspectionLot = _Qmhead.InspectionLot

{
    key _Item.InspectionLot,
    key _Item.InspPlanOperationInternalID,
    key _Item.InspectionCharacteristic,
    _Item.InspectionCharacteristicText,
    _Item.InspectionSpecification,
    _Item.Status,
    _Item.InspectionDescription,
    _Item.CreationDate,
    _Item.InspectionEndTime,    
    _Item.Inspector,
    @ObjectModel.text.element: [ 'InspectionCodeText' ]
    _Item.CharacteristicAttributeCode,
    _Item.CharacteristicAttributeCatalog,
    _Item.CharacteristicAttributeCodeGrp,
    _Item.PersonFullName,
    _Item._Codetext.InspectionCodeText,
    @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
    @EndUserText.label: 'Lot Quantity'
    _head.InspectionLotQuantity,
    @EndUserText.label: 'Supplier Name'    
    _head.BPSupplierFullName,
    _head.InspectionLotQuantityUnit,
    @EndUserText.label: 'Inspection Lot Text'        
    _head.InspectionLotText,
    @EndUserText.label: 'Inspection Type'
    _head.InspectionLotType,
    @EndUserText.label: 'Material Code'
    _head.Material,
    _head.Plant,
    @EndUserText.label: 'Material Description'
    _head.ProductDescription, 
    @EndUserText.label: 'Vehicle Number'
    _head.TruckNo
//    _Qmhead
}

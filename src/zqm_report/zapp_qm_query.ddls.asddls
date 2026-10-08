@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'QM Custom report Query node'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAPP_QM_QUERY as select from I_InspectionLot as ins
left outer join I_ProductDescription as _ProDesc on _ProDesc.Product = ins.Material
                                                  and _ProDesc.Language = $session.system_language
left outer join I_MaterialDocumentHeader_2 as _TruckNo on _TruckNo.MaterialDocument = ins.MaterialDocument
                                                  and _TruckNo.MaterialDocumentYear = ins.MaterialDocumentYear
left outer join I_Supplier as _SupName on _SupName.Supplier = ins.Supplier
{
key ins.InspectionLot,
    ins.Material,
    ins.Plant,
    ins.InspectionLotType,
    @Semantics.quantity.unitOfMeasure: 'InspectionLotQuantityUnit'
    ins.InspectionLotQuantity,
    ins.InspectionLotQuantityUnit,
    ins.InspectionLotText,
    _ProDesc.ProductDescription,
    _TruckNo.MaterialDocumentHeaderText as TruckNo,
    _SupName.BPSupplierFullName
}

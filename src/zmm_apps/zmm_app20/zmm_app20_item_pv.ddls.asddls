@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Note Item PV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZMM_APP20_ITEM_PV 
as projection on ZMM_APP20_ITEM_RV
{
    key Uuid,
    key Materialdocument,
    key Materialdocumentyear,
    key Materialdocumentitem,
    Plant,
    Companycode,
    Companycodecurrency,
    Material,
    Productdescription,
    Materialbaseunit,
    @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
    Migoqty,
    @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'    
    Poqty,
    @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'    
    Invoiceqty,
    @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'    
    Receivedqty,
    @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'    
    Acceptedqty,
    @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'    
    Rejectedqty,
    Createdby,
    Createdat,
    Lastchangedby,
    Lastchangedat,
    /* Associations */
    _Header : redirected to parent ZMM_APP20_HEAD_PV
}

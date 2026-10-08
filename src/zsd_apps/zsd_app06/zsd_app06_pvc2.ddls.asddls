@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Gate Out billing Child Projection entity 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZSD_APP06_PVC2 as projection on ZSD_APP06_RVC2
{
    key BillingDocument,
    key BillingDocumentItem,
    ReferenceSDDocument,
    ReferenceSDDocumentItem,
        @Semantics.quantity.unitOfMeasure: 'YY1_CHARWT_BDHU'
    YY1_CHARWT_BDH,
    YY1_CHARWT_BDHU,
    /* Associations */
    _BDH,
     stastr,
    
    _header2 : redirected to parent ZSD_APP06_PV
}

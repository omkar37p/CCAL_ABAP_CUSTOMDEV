@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List - Gate Out billing Child Entity 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_APP06_RVC2 as select from I_BillingDocumentItemBasic as bdi
association[0..1] to I_BillingDocumentBasic as _BDH on _BDH.BillingDocument =  bdi.BillingDocument 

association to parent ZSD_APP06_RV as _header2 on $projection.ReferenceSDDocument = _header2.Delvnum
{
    key bdi.BillingDocument,
    key bdi.BillingDocumentItem,
    bdi.ReferenceSDDocument,
    bdi.ReferenceSDDocumentItem,
    _header2,
    _BDH,
    @Semantics.quantity.unitOfMeasure: 'YY1_CHARWT_BDHU'
    _BDH.YY1_CHARWT_BDH,
    _BDH.YY1_CHARWT_BDHU,
      case when _BDH.OverallSDProcessStatus = 'C' 
    then 'Invoice Is Completed '
    else 
    'Invoice In Progresss'
    end as stastr
   
}
where bdi.SalesDocumentItemCategory = 'TAN'

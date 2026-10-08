@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection Note Item RV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP20_ITEM_RV
  as select from zmm_reject_idb
  association to parent ZMM_APP20_HEAD_RV as _Header on $projection.Uuid = _Header.Uuid
                                                     and $projection.Materialdocument = _Header.Materialdocument
{
  key uuid                 as Uuid,
  key materialdocument     as Materialdocument,
  key materialdocumentyear as Materialdocumentyear,
  key materialdocumentitem as Materialdocumentitem,
      plant                as Plant,
      companycode          as Companycode,
      companycodecurrency  as Companycodecurrency,
      material             as Material,
      productdescription   as Productdescription,
      materialbaseunit     as Materialbaseunit,
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      migoqty              as Migoqty,
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      poqty                as Poqty,
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      invoiceqty           as Invoiceqty,
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      receivedqty          as Receivedqty,
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      acceptedqty          as Acceptedqty,
      @Semantics.quantity.unitOfMeasure: 'Materialbaseunit'
      rejectedqty          as Rejectedqty,
      @Semantics.user.createdBy: true
      createdby            as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat            as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby        as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat        as Lastchangedat,
      _Header
}

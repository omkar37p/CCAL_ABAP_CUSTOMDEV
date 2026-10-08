@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGP/NRGP Inward Entry - CE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_APP15_IV1
  as select from zmm_app15_tb1
  association to parent ZMM_APP15_RV as _Header on  $projection.Uuid   = _Header.Uuid
                                                and $projection.Itemno = _Header.Itemno
{
  key uuid      as Uuid,
  key itemno    as Itemno,
  key sno       as Sno,
      matnr     as Matnr,
      maktx     as Maktx,
      uom       as Uom,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      quantity  as Quantity,
      indt      as Indt,
      intim     as Intim,
      @EndUserText.label: 'Received Quantity'
//      @Semantics.quantity.unitOfMeasure: 'Uom'
      cast(recvqty as abap.dec(10,2) )  as Recvqty,
      @Semantics.quantity.unitOfMeasure: 'Uom'
      penqty    as Penqty,
      invoice   as Invoice,
      createdby as Createdby,
      createdat as Createdat,
      _Header
}

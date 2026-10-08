@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RGB - Inward Processing Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP13_RV1 as select from ZMM_APP12_RV as vdh
association[0..*] to ZMM_APP13_IRV1 as _Item on $projection.Uuid = _Item.Uuid
///composition[0..*] of ZMM_APP13_IRV1 as _Item
{
key Uuid,
Plant,
Plantname,
Gpnum,
Gptype,
Vendnum,
Vendname,
Plnrtndate,
Vehicleno,
Dispby,
Issuedate,
Issuedby,
Transporter,
Remarks,
@Semantics.amount.currencyCode: 'Curky'
Gpvalue,
Curky,
Rsngp,
Frghtscope,
Pcklist,
Delmark,
Mark,
Createdby,
Createdat,
Lastchangedby,
Lastchangedat,
/* Associations */
_Item
} where Gptype = 'RGP'

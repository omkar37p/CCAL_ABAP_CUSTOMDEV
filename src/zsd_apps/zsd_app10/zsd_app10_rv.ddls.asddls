@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Authorised Signer Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSD_APP10_RV
  as select from zsd_app10_tb1
{
  key userid        as Userid,
  key ccode         as Ccode,
  key distchnl      as Distchnl,
  key division      as Division,
      usrname       as Usrname,
      ccname        as Ccname,
      dstchname     as Dstchname,
      divsname      as Divsname,
      signername    as Signername,
      formtmp       as Formtmp,
      formname      as Formname,
      prntque       as Prntque,
      @Semantics.user.createdBy: true
      createdby     as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat     as Createdat,
      @Semantics.user.lastChangedBy: true
      lastchangedby as Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat as Lastchangedat
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view DSC User'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZMM_APP18_B_RPV
  provider contract transactional_query
  as projection on ZMM_APP18_B_RV
{
      @ObjectModel.text.element: [ 'Usrname' ]
      @EndUserText.label: 'User ID'
  key Userid,
      @ObjectModel.text.element: [ 'Ccname' ]
  key Ccode,
      @ObjectModel.text.element: [ 'Plantname' ]
  key Cplant,
      Usrname,
      Ccname,
      Plantname,
      Signername,
      Formtmp,
      Formname,
      Prntque,
      @Semantics.user.createdBy: true
      Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat
}

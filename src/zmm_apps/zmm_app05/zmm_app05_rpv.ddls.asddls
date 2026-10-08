@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Department User - Root PEntity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMM_APP05_RPV
  provider contract transactional_query
  as projection on ZMM_APP05_RV
{
      @EndUserText.label: 'Plant'
      @ObjectModel.text.element: [ 'Plntname' ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_PLANT_VH1',
      element: 'Shpoint' }  , additionalBinding: [{localElement: 'Plntname', element: 'Shpname'}]    }]
  key Plant,
      @EndUserText.label: 'Business User'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BusinessUserVH',
      element: 'UserID' }  , additionalBinding: [{localElement: 'Username', element: 'PersonFullName'}]    }]
  key Userid,
      @EndUserText.label: 'Department'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_COSTCENTER_VH1',
      element: 'CostCenter' }  , additionalBinding: [{localElement: 'Deptname', element: 'CCname'}]    }]
  key Deptid,
      @UI.hidden: true
      Plntname,
      @EndUserText.label: 'User Name'
      Username,
      @EndUserText.label: 'Department Name'
      Deptname,
      @UI.hidden: true
      Mark,
      @UI.hidden: true
      Delmrk,
      @UI.hidden: true
      @Semantics.user.createdBy: true
      Createdby,
      @UI.hidden: true
      @Semantics.systemDateTime.createdAt: true
      Createdat,
      @UI.hidden: true
      @Semantics.user.lastChangedBy: true
      Lastchangedby,
      @UI.hidden: true
      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat
}

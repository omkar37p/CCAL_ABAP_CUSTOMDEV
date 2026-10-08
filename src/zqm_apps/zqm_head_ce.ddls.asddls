@EndUserText.label: 'COA Header Print Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZQM_PRINT_IMP_CLASS'
//@UI.presentationVariant: [{sortOrder: [{by: '_Item.InspectionCharacteristic', direction: #ASC}]}]

define custom entity ZQM_HEAD_CE

{
  key inspection : zqminspno;
  key uuid       : sysuuid_x16;
  reportissueon  : sydate;
  serialno       : abap.numc(10);
  product        : abap.char(40);
  productdesc    : abap.char(50);
  ulrnum         : abap.char(40);
  discipline     : abap.char(100);
  coagroup       : zqmapp_group;
  customer       : abap.char(10);
  truckno        : abap.char(50);
  issuedto       : abap.char(100);
  partyaddress   : abap.char(200);
  reference      : abap.char(200);
  samplereceipt  : abap.dats;
  dateofanalyis  : abap.dats;
  batch          : abap.char(20);
  description    : abap.char(250);
  plant          : abap.char(4);
  nablformat     : zqm_coaformat;
  termscond      : zqm_termscon;
  mfgdate        : sydate;
  reportno       : abap.char(50);
  status         : abap.char(10);
  itmcnt         : abap.numc(3);
  mark           : abap.char(1);
  driver         : abap.char(100);
  conc           : abap.char(50);
  createdby      : abp_creation_user;
  createdat      : abp_creation_tstmpl;
  lastchangedby  : abp_lastchange_user;
  lastchangedat  : abp_lastchange_tstmpl;
  @ObjectModel.filter.enabled: false
//  _Item : association [1..*] to ZQM_ITEM_VIEW on $projection.inspection = _Item.inspectionlot
//                                                  and $projection.uuid = _Item.uuid;
  _Item : association [1..*] to ZQM_ITEM_CE on $projection.inspection = _Item.inspectionlot
                                                  and $projection.uuid = _Item.uuid;                                                  
  
}

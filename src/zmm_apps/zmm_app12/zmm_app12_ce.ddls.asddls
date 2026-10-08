@EndUserText.label: 'Custom Entity For Header Material'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_APPS12_PRINT'
define custom entity ZMM_APP12_CE
// with parameters parameter_name : parameter_type
{
 key uuid   : sysuuid_x16 ;
  rnr        : abap.char(100);
  ruler        : abap.char(100);
  cmpname      : abap.char(100);
  addrs        : abap.char(200);
  gstin        : abap.char(15);
  pan          : abap.char(10);
  email        : abap.char(50);
  statecode    : abap.char(15);
  typ         : abap.char(5);
  rgpno        : abap.numc(10);
  despdt       : abp_creation_tstmpl;
  rgpdt        : abp_creation_tstmpl;
  dispthr      : abap.char(20);
  retndt       : abap.datn;
  transna      : abap.char(80);
  fregts       : abap.char(40);
  vehno        : abap.char(30);
  insurncsc    : abap.char(40);
  contno       : abap.char(40);
  reqdept      : abap.char(60);
  requestedby  : abap.char(40);
  gateenty     : abap.numc(10);
  gatetime     : abap.timn;
  gross        : abap.dec(15,3);
  tare         : abap.dec(15,3);
  netw         : abap.dec(15,3);
  dt           : abp_creation_tstmpl;
  ddt          : abap.datn;
  cmp          : abap.char(100);
  add1         : abap.char(200);
  add2         : abap.char(200);
  gstno        : abap.char(15);
  sc           : abap.char(15);
  pos          : abap.char(40);
  ewbno        : abap.char(50);
  conctno      : abap.char(15);
  ValueInWords : abap.char(200);
  @ObjectModel.filter.enabled: false
  _item : association[1..*] to ZPP_APPS05_CITM on _item.uuid = $projection.uuid ;
 
 
 
 
  
}

LABELS = {
    # "nsx.app": lambda x: "sta.fct.app.flg", # TODO get app in namespace
    "nsx.csm": lambda x: "sta.fct.csm.nxs",
    # "nsx.env": lambda x: "sta.fct.env.t",   # TODO get env in namespace
    # "nsx.svc": lambda x: SERVICES[0],       # TODO validate if defined or throw error
    "nsx.sys": lambda x: "sta.tec.sys.kube"
}
SERVICES = [
    "sta.tec.svc.apache_php",
    "sta.tec.svc.apigw",
    "sta.tec.svc.citrix",
    "sta.tec.svc.cognosgateway",
    "sta.tec.svc.db.mongodb",
    "sta.tec.svc.db.mssqlserver",
    "sta.tec.svc.db.mysql",
    "sta.tec.svc.db.ora",
    "sta.tec.svc.db.oracle",
    "sta.tec.svc.dki",
    "sta.tec.svc.dkm",
    "sta.tec.svc.filenet",
    "sta.tec.svc.flexnet",
    "sta.tec.svc.ihs",
    "sta.tec.svc.iis",
    "sta.tec.svc.iisarr",
    "sta.tec.svc.infoblox",
    "sta.tec.svc.jboss",
    "sta.tec.svc.jenkinsmaster",
    "sta.tec.svc.jenkinsslave",
    "sta.tec.svc.mssqlserver",
    "sta.tec.svc.newtestrobot",
    "sta.tec.svc.powerbi",
    "sta.tec.svc.splunkserver",
    "sta.tec.svc.tomcat",
    "sta.tec.svc.vm*",
    "sta.tec.svc.xld",
    "sta.tec.svc.xlr"
]
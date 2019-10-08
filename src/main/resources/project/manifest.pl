@files = (
 ['//property[propertyName="ui_forms"]/propertySheet/property[propertyName="@PLUGIN_KEY@ - PostgreSQLCreateConfigForm"]/value', 'forms/PostgreSQLCreateConfigForm.xml'],
 ['//property[propertyName="ui_forms"]/propertySheet/property[propertyName="@PLUGIN_KEY@ - PostgreSQLEditConfigForm"]/value', 'forms/PostgreSQLEditConfigForm.xml'],
 ['//procedure[procedureName="ExecuteSQL"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/ExecuteSQL.xml'],
 ['//step[stepName="createCommandLine"]/command', 'CreateCommandLine.pl'],
 ['//step[stepName="runCommandLine"]/command', 'RunCommandLine.pl'],
 ['//property[propertyName="postp_matchers"]/value', 'postp_matchers.pl'],
 ['//property[propertyName="ec_setup"]/value', 'ec_setup.pl'],
 ['//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateConfiguration"]/command' , 'conf/createcfg.pl'],
 ['//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateAndAttachCredential"]/command' , 'conf/createAndAttachCredential.pl'],
 ['//procedure[procedureName="DeleteConfiguration"]/step[stepName="DeleteConfiguration"]/command' , 'conf/deletecfg.pl'],
 ['//property[propertyName="libs"]/propertySheet/property[propertyName="Common.pm"]/value','conf/Common.pm'],
);
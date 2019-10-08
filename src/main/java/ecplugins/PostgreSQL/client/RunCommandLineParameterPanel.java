
// RunCommandLineParameterPanel.java --
//
// RunCommandLineParameterPanel.java is part of ElectricCommander.
//
// Copyright (c) 2005-2014 Electric Cloud, Inc.
// All rights reserved.
//

package ecplugins.PostgreSQL.client;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import com.google.gwt.user.client.ui.CheckBox;
import com.google.gwt.user.client.ui.TextBox;
import com.google.gwt.user.client.ui.TextArea;
import com.google.gwt.user.client.ui.Widget;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.RadioButton;

import com.electriccloud.commander.client.domain.ActualParameter;
import com.electriccloud.commander.client.domain.FormalParameter;
import com.electriccloud.commander.client.util.StringUtil;
import com.electriccloud.commander.gwt.client.ui.FormTable;
import com.electriccloud.commander.gwt.client.ui.ParameterPanel;
import com.electriccloud.commander.gwt.client.ui.ParameterPanelProvider;

import ecinternal.client.InternalComponentBase;

import static com.electriccloud.commander.gwt.client.ui.FormBuilder.MISSING_REQUIRED_ERROR_MESSAGE;

public class RunCommandLineParameterPanel
    extends InternalComponentBase
    implements ParameterPanel,
        ParameterPanelProvider
{

    //~ Static fields/initializers ---------------------------------------------

    private static final String CONFIG_NAME   = "ConfigName";
    private static final String PSQL_PATH  = "PsqlPath";
    private static final String SERVER        = "Server";
    private static final String OUTPUT_FILE   = "OutputFileName";
    private static final String QUERY         = "Query";
    private static final String SQL_FILE_PATH = "SQLFilePath";
    private static final String ADD_COMMANDS  = "AdditionalCommands";
    private static final String WORKING_DIR   = "WorkingDir";
    private static final String RESULT_PROP   = "Result_outpp";
    private final String INCOMPATIBLE_PARAMETERS_ERROR_MESSAGE = "This field is incompatible with another field.";

    //~ Instance fields --------------------------------------------------------

    private FormTable    m_form;
    private TextBox m_ConfigName;
    private TextBox m_PsqlPath;
    private TextBox m_Server;
    private TextBox m_OutputFileName;
    private TextArea m_Query;
    private TextBox m_WorkingDir;
    private TextBox m_SqlFilePath;
    private TextBox m_AdditionalCommands;
    private TextBox m_ResultProperty;

    //~ Methods ----------------------------------------------------------------

    @Override public Widget doInit()
    {
        m_form = getUIFactory().createFormTable();
        m_ConfigName  = new TextBox();
        m_PsqlPath = new TextBox();
        m_Server = new TextBox();
        m_OutputFileName = new TextBox();
        m_Query = new TextArea();
        m_WorkingDir = new TextBox();
        m_SqlFilePath = new TextBox();
        m_AdditionalCommands = new TextBox();
        m_ResultProperty = new TextBox();

        m_form.addFormRow(CONFIG_NAME, "Configuration name:", m_ConfigName, true, "The name of the configuration that contains the user and password to connect to the database server.");
        m_form.addFormRow(PSQL_PATH, "Psql path:", m_PsqlPath, true, "Absolute path to the psql utility.");
        m_form.addFormRow(SERVER, "Server:", m_Server, true, "The name/ip of the server you want to connect to.");
        m_form.addFormRow(OUTPUT_FILE, "Output file:", m_OutputFileName, false, "Name of a file to store output (without extension)");
        m_form.addFormRow(QUERY, "Query:", m_Query, false, "Provide any query you want to run against the database.");
        m_form.addFormRow(SQL_FILE_PATH, "SQL file path:", m_SqlFilePath, false, "Absolute path to a sql file.");
        m_form.addFormRow(ADD_COMMANDS, "Additional commands:", m_AdditionalCommands, false, "Additional commands to be entered.");
        m_form.addFormRow(WORKING_DIR, "Working directory:", m_WorkingDir, false, "Sets the directory where the command will be executed");
        m_form.addFormRow(RESULT_PROP, "Result (output property path):", m_ResultProperty, false, "Property name used to store the result of queries.");

        return m_form.asWidget();
    }

    @Override public boolean validate()
    {
        m_form.clearAllErrors();

        if ( StringUtil.isEmpty( m_ConfigName.getValue() ) ) {
            m_form.setErrorMessage(CONFIG_NAME, MISSING_REQUIRED_ERROR_MESSAGE);
            return false;
        }
        
        if ( StringUtil.isEmpty( m_PsqlPath.getValue() ) ) {
            m_form.setErrorMessage(PSQL_PATH, MISSING_REQUIRED_ERROR_MESSAGE);
            return false;
        }

        if ( StringUtil.isEmpty( m_Server.getValue() ) ) {
            m_form.setErrorMessage(SERVER, MISSING_REQUIRED_ERROR_MESSAGE);
            return false;
        }

        if ( StringUtil.isEmpty( m_Query.getValue() ) && StringUtil.isEmpty( m_SqlFilePath.getValue() ) ) {
            m_form.setErrorMessage(QUERY, MISSING_REQUIRED_ERROR_MESSAGE);
            m_form.setErrorMessage(SQL_FILE_PATH, MISSING_REQUIRED_ERROR_MESSAGE);
            return false;
        } else if ( !StringUtil.isEmpty( m_Query.getValue() ) && !StringUtil.isEmpty( m_SqlFilePath.getValue() ) ) {
            m_form.setErrorMessage(QUERY, INCOMPATIBLE_PARAMETERS_ERROR_MESSAGE);
            m_form.setErrorMessage(SQL_FILE_PATH, INCOMPATIBLE_PARAMETERS_ERROR_MESSAGE);
            return false;
        }

        return true;
    }

    @Override public ParameterPanel getParameterPanel()
    {
        return this;
    }

    @Override public Map<String, String> getValues()
    {
        Map<String, String> values = new HashMap<String, String>();

        values.put(CONFIG_NAME, m_ConfigName.getValue());
        values.put(PSQL_PATH, m_PsqlPath.getValue());
        values.put(SERVER, m_Server.getValue());
        values.put(OUTPUT_FILE, m_OutputFileName.getValue());
        values.put(QUERY, m_Query.getValue());
        values.put(SQL_FILE_PATH, m_SqlFilePath.getValue());
        values.put(ADD_COMMANDS, m_AdditionalCommands.getValue());
        values.put(WORKING_DIR, m_WorkingDir.getValue());
        values.put(RESULT_PROP, m_ResultProperty.getValue());

        return values;
    }

    @Override public void setActualParameters(
            Collection<ActualParameter> actualParameters)
    {
        for (ActualParameter actualParameter : actualParameters) {
            String name  = actualParameter.getName();
            String value = actualParameter.getValue();

            if (CONFIG_NAME.equals(name)) {
                m_ConfigName.setValue(value);
            } else if (PSQL_PATH.equals(name)) {
                m_PsqlPath.setValue(value);
            } else if (SERVER.equals(name)) {
                m_Server.setValue(value);
            } else if (OUTPUT_FILE.equals(name)) {
                m_OutputFileName.setValue(value);
            } else if (QUERY.equals(name)) {
                m_Query.setValue(value);
            } else if (SQL_FILE_PATH.equals(name)) {
                m_SqlFilePath.setValue(value);
            } else if (ADD_COMMANDS.equals(name)) {
                m_AdditionalCommands.setValue(value);
            } else if (WORKING_DIR.equals(name)) {
                m_WorkingDir.setValue(value);
            } else if (RESULT_PROP.equals(name)) {
                m_ResultProperty.setValue(value);
            }
        }
    }

    @Override public void setFormalParameters(
            Collection<FormalParameter> formalParameters) { }
}

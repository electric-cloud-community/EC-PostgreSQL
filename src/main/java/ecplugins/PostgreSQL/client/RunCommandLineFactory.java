
// RunCommandLineFactory.java --
//
// RunCommandLineFactory.java is part of ElectricCommander.
//
// Copyright (c) 2005-2014 Electric Cloud, Inc.
// All rights reserved.
//

package ecplugins.PostgreSQL.client;

import org.jetbrains.annotations.NotNull;

import com.electriccloud.commander.gwt.client.Component;
import com.electriccloud.commander.gwt.client.ComponentContext;

import ecinternal.client.InternalComponentBaseFactory;

public class RunCommandLineFactory
    extends InternalComponentBaseFactory
{

    //~ Methods ----------------------------------------------------------------

    @NotNull @Override protected Component createComponent(
            ComponentContext jso)
    {
        return new RunCommandLineParameterPanel();
    }
}
